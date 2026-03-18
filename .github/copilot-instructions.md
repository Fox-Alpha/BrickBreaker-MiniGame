# Copilot Instructions for Break-Out Prototype

## Project Overview

Break-Out Prototype is a Godot 4.6 (2D) breakout/brick-breaker game built with GDScript. The project is a single-player prototype featuring a paddle-controlled ball that destroys bricks on a tilemap.

**Branch Strategy**:
- **`develop`** - Active development branch (default for ongoing work)
- **`main`** - Release-only branch (tagged versions only)

See `BRANCHING.md` for complete Git workflow details.

## Build, Test & Export

### Running the Game
- **Editor**: Open `project.godot` in Godot 4.6 and press F5 or click Play
- **Main scene**: `res://src/scenes/game/game.tscn`
- **Export presets**: Located in `export_presets.cfg` (Linux and Windows Desktop profiles)

### Exporting
- Build configuration is in `build_config.json` with profiles for Linux and Windows
- Export root: `.exports/` directory
- Use Godot's export menu or external build scripts to generate executables

### Notes
- No formal testing framework is currently set up
- No linters or formatters are configured
- Project configuration is managed through Godot's UI and project.godot config file

## High-Level Architecture

### Autoload (Singleton)

**`Game` (src/scenes/core/game_manager.gd)**
- Global singleton providing centralized game state management
- Implements `GameStates` enum with 60+ state definitions covering initialization, gameplay, menus, pause, and UI states
- Key signals: `GL_GAMESTATE_CHANGE` (emitted when state changes), `GL_CHANGE_GAMESTATE` (request state change)
- Also initializes global random number generator with fixed seed (19771202)

### Scene Structure

**Main Game Scene** (`res://src/scenes/game/game.tscn`)
- Node2D container for active gameplay
- Dynamically instantiates paddle and ball when game unpauses
- Manages references to: paddle scene, brickmap (TileMapLayer), camera, and canvas layer
- Key signals: `NoMoreBrickInMap`, `GS_GAME_PAUSED`, `GS_GAME_UNPAUSED`

**Component Scenes**
- **Paddle** (`src/scenes/paddle/paddle.tscn`) – CharacterBody2D with mouse or keyboard control
- **Ball** (`src/scenes/ball/ball.tscn`) – RigidBody2D with physics simulation
- **Bricks** (`src/scenes/brick/brick.tscn`) – Static/TileMap-based destructible objects
- **World Borders** (`src/scenes/world_border/world_border.tscn`) – Collision boundary helpers
- **Main Menu** (`src/scenes/main_menu/main_menu.tscn`) – Menu scene with multiple views

**UI**
- **Game UI** (`src/scenes/ui/game_ui.tscn`) – HUD for score, lives, and game status

### Input Mapping

Defined in `project.godot`:
- `p1_left` – A key or Left Arrow
- `p1_right` – D key or Right Arrow
- `shoot` – Spacebar

### Game Window Settings

- Viewport: 1920×1080
- Stretch mode: canvas_items with keep_width aspect ratio
- Initial position: centered at (100, 100)

## Key Conventions

### Code Organization

1. **Region blocks** – Code is organized with `#region` / `#endregion` comments for readability
   - Examples: `#region Signals`, `#region GameStates`, `#region ScenesAndNodes`

2. **Signals** – Broadly used for cross-component communication
   - Global signals are defined in the Game singleton (prefixed with `GL_`)
   - Local signals in individual components (e.g., `HitByBall` in bricks)
   - Use `CONNECT_DEFERRED` when connecting to global state changes to avoid frame-timing issues

3. **Node Naming** – Dynamic nodes use `get_instance_id()` to generate unique names
   - Example: `Brick_{instance_id}`
   - Bricks auto-add themselves to the "Brick" group on tree entry

4. **Preloading** – Heavy/important scenes use `preload()` for early loading
   - Example: `const BALL_BODY = preload("uid://bx7lmlxv60bk7")`
   - Uses Godot's UID system for reliable scene references

5. **Export Variables** – Use `@export` for designer-tunable parameters
   - Example: `@export_range(100.0, 1000.0, 10.0) var SPEED = 650.0`
   - Include type hints and reasonable defaults

6. **Property Setters/Getters** – Custom getters/setters are used for state-dependent logic
   - Example: `GameState` property emits signal on change
   - Pattern documented with examples in globals.gd comments

### Class Naming

- Scene-specific controllers use `PascalCase` with descriptive names: `PaddleController`, `BrickMap`
- Legacy/alternate implementations may include descriptors: `brick_claude_ai.gd`, `oldBrick`

### Physics & Collision

- Ball uses `RigidBody2D` with `apply_central_impulse()` for physics-based movement
- Paddle uses `CharacterBody2D` with `move_and_slide()` for kinematic collision
- Paddle bounce logic uses hit position to deflect ball angle (max 60°)
- Bricks use Area2D for collision detection with `body_shape_entered` signals

### Movement & Input

- **Paddle** supports two control modes toggled via `@export var use_mouse`:
  - Mouse: position tracks cursor with lerp smoothing
  - Keyboard: input axis with frame-based acceleration/deceleration
- **Ball** uses `linear_velocity` directly (no move_and_collide; physics engine handles it)

### Game State Management

The `GameStates` enum is intentionally comprehensive (60+ states) but many are not yet used. Follow this pattern when adding new states:
1. Add state to enum in `globals.gd`
2. Emit `GL_GAMESTATE_CHANGE` via property setter or `GL_CHANGE_GAMESTATE` signal to request change
3. Connect listeners with `GL_GAMESTATE_CHANGE.connect(callback, CONNECT_DEFERRED)`

### Incomplete/Legacy Code

- Several scripts have commented-out or incomplete implementations (e.g., `ball_body.gd` physics, registration signals)
- Old code blocks are marked with comments like "# Allgemeine States" or "# Module"
- Use caution when relying on commented code—it may not be current

## File Structure

```
project.godot                       # Project configuration
build_config.json                   # Export builder config
export_presets.cfg                  # Godot export presets

src/                                # Game source code
  scenes/
    core/
      game_manager.gd              # Game singleton (autoload)
    paddle/
      paddle.tscn
      paddle_controller.gd
    ball/
      ball.tscn
      ball_physics.gd
    brick/
      brick.tscn
      brick.gd
      brick_base.gd
    brickmap/
      brick_map.tscn
      brick_map.gd
    world_border/
      world_border.tscn
      world_border.gd
    main_menu/
      main_menu.tscn
      main_view.tscn
      main_view.gd
    game/
      game.tscn                    # Main game scene
      game.gd                       # Main game controller
    ui/
      game_ui.tscn
      game_ui.gd
  resources/
    fonts/
    themes/

assets/                             # Non-code assets
  images/
  audio/

docs/                               # Technical documentation
  ARCHITECTURE.md                  # German (default)
  ARCHITECTURE_en.md               # English version
  DEVELOPMENT.md
  DEVELOPMENT_en.md
  STYLE_GUIDE.md
  STYLE_GUIDE_en.md
  GAME_DESIGN.md
  GAME_DESIGN_en.md

README.md                           # Project overview (German)
BRANCHING.md                        # Git workflow & branch strategy
.github/
  copilot-instructions.md
  mcp-servers.json
.vscode/
  settings.json                     # Godot LSP configuration
```

## Documentation

The project maintains **bilingual documentation** (German and English):

- **German** (default, no suffix): `ARCHITECTURE.md`, `DEVELOPMENT.md`, `STYLE_GUIDE.md`, `GAME_DESIGN.md`
- **English** (with `_en` suffix): `ARCHITECTURE_en.md`, `DEVELOPMENT_en.md`, etc.

When referencing documentation, link to the German version by default. English versions are available for international contributors.

## Debugging Tips

1. **State changes** – Watch console output. Every state change logs to print: `"Global Autoload => _Game_State_Has_Changed(GS:...)"` 
2. **Node inspection** – Use Remote tab in Debugger to inspect live nodes and properties
3. **Signal debugging** – Add temporary prints in signal handlers to trace signal flow
4. **Physics visualization** – Enable "Visible Collision Shapes" in Debug menu for paddle/ball/brick interactions
5. **Window resizing** – Game emits `Game_Window_Size_Changed` signal when viewport resizes

## Notes for Contributors

- The codebase is a prototype with evolving architecture—some patterns are experimental
- Game uses a comprehensive state machine but most states are not yet implemented
- Comments and signal names are a mix of English and German
- Several alternate implementations exist (e.g., brick_claude_ai.gd, oldBrick) for testing/experimentation
- Mouse-based paddle control is the default (may need to verify on your platform)
