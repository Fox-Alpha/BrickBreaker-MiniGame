# Break-Out Prototype - Architecture

## Overview

Break-Out Prototype is a Godot 4.6 2D game implementing the classic breakout/brick-breaker genre. The codebase follows a **hybrid organizational approach**: components are grouped by feature (paddle, ball, brick), while shared systems use centralized management through the Game singleton.

## Core Systems

### Game State Machine (Singleton)

**File**: `src/scenes/core/game_manager.gd` (Autoload: `Game`)

The Game singleton provides centralized state management and global signal coordination.

**Key Features**:
- **GameStates Enum**: 60+ state definitions covering:
  - Initialization states (NOTDEFINED, STARTUP, INITIALIZING, INITIALIZED)
  - Gameplay states (ACTIVE, RUNNING, PAUSED, PAUSED)
  - UI/Menu states (MENU, PAUSE, SETTINGS, SCORE)
  - Session states (GAME_SESSION_INITIALIZED, GAMESESSIONRUNNING, etc.)

- **State Changes**: Use property setter pattern for automatic signal emission:
  ```gdscript
  Game.GameState = Game.GameStates.RUNNING  # Emits GL_GAMESTATE_CHANGE signal
  ```

- **Global Signals**:
  - `GL_GAMESTATE_CHANGE(state: GameStates)` – Emitted after state change
  - `GL_CHANGE_GAMESTATE(state: GameStates)` – Request a state change
  - `Game_Window_Size_Changed` – Emitted when viewport resizes

- **RNG**: Global random number generator with fixed seed (19771202) for reproducible randomness

### Game Scene (Main Gameplay Controller)

**File**: `src/scenes/game/game.gd` / `game.tscn`

The Game scene is the root Node2D for active gameplay, instantiating and managing core gameplay objects.

**Responsibilities**:
- Dynamically instantiate paddle and ball when game starts (via `startgame()`)
- Manage references to tilemap, camera, and canvas layer
- Coordinate between game objects through signals

**Key Signals**:
- `NoMoreBrickInMap` – Fired when all bricks are destroyed
- `GS_GAME_PAUSED` / `GS_GAME_UNPAUSED` – Gameplay pause state changes
- `Reset_Game`, `Player_Score` – Score and reset events

**Design Note**: Game dynamically instantiates the ball using a preloaded scene (`uid://bx7lmlxv60bk7`) and the paddle from an exported PackedScene property. This allows flexibility in swapping scenes without code changes.

## Component Architecture

### Paddle System

**File**: `src/scenes/paddle/paddle.tscn` + `paddle_controller.gd`

**Type**: CharacterBody2D

**Features**:
- Dual control modes (toggleable via `@export var use_mouse`):
  - **Mouse control**: Position smoothly follows cursor via lerp
  - **Keyboard control**: A/D or arrow keys with frame-based acceleration
- Color customization via `@export_color playercolor`
- Speed tuning: `@export_range(100.0, 1000.0, 10.0) SPEED`
- **Collision**: Detects ball collisions via `Area2D` and deflects ball based on hit position
  - Bounce angle calculation: up to ±60° deflection based on hit position relative to paddle center

**Key Methods**:
- `getPaddleSize() -> Vector2i` – Returns collision shape dimensions
- `_mouse_move()` – Updates position based on cursor
- `_move_with_keyboard(delta)` – Handles keyboard input
- `_on_area_2d_body_entered(body)` – Collision callback; deflects ball

### Ball System

**File**: `src/scenes/ball/ball.tscn` + `ball_physics.gd`

**Type**: RigidBody2D

**Features**:
- Physics-based movement using `linear_velocity`
- Initial impulse: `apply_central_impulse(Vector2(0, -1200))`
- Collision handled by Godot's physics engine (no manual move_and_collide)
- Resets to viewport center on `reset()` call

**Design Note**: The ball uses RigidBody2D for automatic physics simulation. Velocity bouncing is handled by the physics engine's collision response. The paddle modifies `linear_velocity` directly on collision.

### Brick System

**Files**:
- `src/scenes/brick/brick.tscn` – Main brick scene
- `brick.gd` – Current implementation
- `brick_base.gd` – Base class (optional)
- `brick_claude_ai.gd.bak` – Legacy alternative (archived)

**Type**: StaticBody2D

**Features**:
- Emits `HitByBall` signal when ball collides
- Auto-adds to "Brick" group on tree entry
- Dynamic naming using instance ID: `Brick_{instance_id}`
- Self-destructs on hit via `queue_free()`

**Signal Flow**:
```
Ball collides → _on_brick_area_body_shape_entered() fires
→ HitByBall signal emitted
→ _On_Hit_by_ball() handler executes
→ Brick queues for deletion
→ BrickMap detects brick count change
```

### Brick Map System

**Files**: `src/scenes/brickmap/brick_map.tscn` + `brick_map.gd`

**Type**: TileMapLayer

**Responsibilities**:
- Manages 2D grid of brick instances
- Tracks total brick count
- Emits `NoMoreBrickInMap` signal when all bricks destroyed
- Can update tile metadata or visual state per brick

### World Boundaries

**Files**: `src/scenes/world_border/world_border.tscn` + `world_border.gd`

**Purpose**:
- Creates collision boundaries (walls, floor)
- Prevents ball/paddle from leaving play area
- Handles "death plane" detection (ball falls off bottom)

**Implementation**: Uses collision bodies (StaticBody2D or CollisionShape2D) positioned at viewport edges.

### UI System

**Files**: `src/scenes/ui/game_ui.tscn` + `game_ui.gd`

**Type**: CanvasLayer

**Responsibilities**:
- Score display and updates
- Lives counter
- Game status messages
- HUD elements (pause indicator, level info)

**Connection**: Game scene passes ball reference to canvas_layer: `canvas_layer.ball = ball`

### Main Menu System

**Files**:
- `src/scenes/main_menu/main_menu.tscn` – Container scene
- `main_view.tscn` / `main_view.gd` – View content and logic

**Type**: Control-based UI

**Features**:
- Main menu entry point
- Navigation between views (Play, Settings, Quit)
- Transitions to gameplay when "Play" is selected

## Signal Flow Diagram

```
┌─────────────────────────────────────────────┐
│ Game Manager (Singleton)                     │
│  - GameState machine                         │
│  - Global signals: GL_GAMESTATE_CHANGE      │
│  - Window events                             │
└─────────────────────────────────────────────┘
                    ↑
                    │ GL_GAMESTATE_CHANGE
                    │
┌─────────────────────────────────────────────┐
│ Game Scene (Main Game Root)                  │
│  - Instantiates paddle & ball                │
│  - Manages scene-level signals               │
│  - GS_GAME_PAUSED, GS_GAME_UNPAUSED        │
└─────────────────────────────────────────────┘
                    │
         ┌──────────┼──────────┬──────────┐
         ↓          ↓          ↓          ↓
    ┌────────┐ ┌───────┐ ┌──────────┐ ┌────┐
    │ Paddle │ │ Ball  │ │ BrickMap │ │ UI │
    └────────┘ └───────┘ └──────────┘ └────┘
         ↓          ↓          ↓
    ┌────────────────────────────────────┐
    │ Physics Engine                      │
    │ - Collisions (paddle, walls, etc)   │
    │ - Velocity calculations             │
    └────────────────────────────────────┘
```

## Data Flow Example: Brick Destruction

1. **Ball collides with brick** → Physics collision detected
2. **Brick._on_brick_area_body_shape_entered()** executes
3. **HitByBall signal emitted**
4. **Brick._On_Hit_by_ball()** queues brick for deletion
5. **BrickMap detects change** in next frame
6. **If all bricks gone**: BrickMap emits `NoMoreBrickInMap`
7. **Game listens** to NoMoreBrickInMap signal
8. **Game can transition** to win state or next level

## Conventions & Patterns

### State Management Pattern
```gdscript
# Setter-based state change with signal emission
var GameState : GameStates = GameStates.NOTDEFINED :
    set(value):
        GameState = value
        GL_GAMESTATE_CHANGE.emit(GameState)
```

### Signal-Based Communication
Components communicate through signals rather than direct method calls. This decouples systems and allows flexible event subscription.

### Scene-Based Organization
Each feature (paddle, ball, brick) is a self-contained scene folder containing:
- `.tscn` file (scene definition)
- Primary `.gd` file (controller/logic)
- Optional supporting scripts (bases, utilities)
- Collision shapes and visual nodes

## Performance Considerations

- **Physics framerate**: Godot's default physics tick (typically 60 Hz)
- **Ball speed clamping**: Currently commented out; can be re-enabled if ball becomes too fast
- **Brick count tracking**: Efficiently done by counting queue_free() calls or maintaining a counter

## Future Extensibility

The architecture supports easy addition of:
- **Power-ups**: Can be spawned on brick destruction and detected via Area2D
- **Multiple balls**: Ball system can be instantiated multiple times
- **Level progression**: BrickMap can be swapped with different tile layouts
- **Score system**: Game Manager already has infrastructure for score management
- **Sound effects**: Canvas layer can emit signals that trigger audio playback
