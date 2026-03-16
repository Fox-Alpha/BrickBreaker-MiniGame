# Break-Out Prototype - Game Design Document

## Core Concept

**Break-Out Prototype** is a classic arcade-style brick-breaker game. The player controls a paddle to bounce a ball upward, destroying bricks arranged in a grid. The goal is to destroy all bricks without letting the ball fall off the bottom of the screen.

## Game Objectives

### Primary Win Condition
- **Destroy all bricks** in the level without losing all lives
- Advance to next level (if implemented)

### Lose Condition
- Ball falls off the bottom of the screen (death plane)
- Lives reach zero (0 remaining lives)

## Core Gameplay Loop

```
1. Ball spawns above paddle, falling downward
2. Player moves paddle left/right to keep ball in play
3. Ball bounces off paddle, walls, and bricks
4. Bricks are destroyed on ball collision
5. When all bricks destroyed → Level complete
6. When ball falls off bottom → Lose one life
7. If lives remaining → Reset ball and continue
8. If no lives → Game Over
```

## Game Mechanics

### Ball Physics
- **Movement**: Physics-based using RigidBody2D
- **Velocity**: Affected by paddle collision and wall bounces
- **Bounce**: Angle varies based on hit position on paddle
  - Hit near center → ball bounces straight up
  - Hit near edges → ball deflects at up to ±60° angle
- **Speed**: Constant magnitude (for playability)

### Paddle Control
- **Movement**: Horizontal (left/right) only
- **Control Modes**:
  - **Mouse**: Paddle follows cursor position smoothly
  - **Keyboard**: A/D or arrow keys with frame-based acceleration
- **Collision**: Detects ball contact via Area2D overlap
- **Bounce Logic**: Returns ball with new velocity based on hit position

### Brick System
- **Layout**: Arranged in 2D grid via TileMapLayer
- **Destruction**: Destroyed on first ball collision
- **Points**: Award points to player on destruction (design detail: amount TBD)
- **Variants** (future):
  - Normal bricks (1 hit)
  - Hard bricks (multiple hits)
  - Power-up bricks (spawn items on destruction)

### World Boundaries
- **Left/Right Walls**: Ball bounces; paddle constrained to play area
- **Top Wall**: Ball bounces
- **Bottom/Death Plane**: Ball is destroyed; player loses one life
- **Play Area**: 1920×1080 viewport (configurable in project settings)

## Game States

The game uses a state machine with the following primary states:

```
┌─────────────────────────────────────────┐
│ NOTDEFINED (Initial)                    │
└─────────────┬───────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ STARTUP / INITIALIZING (Loading)        │
└─────────────┬───────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ MAIN MENU (Menu Screen)                 │
└─────────┬───────────────────────────────┘
          ├─→ PLAY ─┐
          │         ↓
          │ ┌──────────────────────────────┐
          │ │ GAME (Gameplay Loop)         │
          │ │  ├─ RUNNING                 │
          │ │  ├─ PAUSED (spacebar?)      │
          │ │  ├─ WAITING (between balls) │
          │ │  └─ ENDED (level complete)  │
          │ └──┬───────────────────────────┘
          │    └─→ Repeat / Next Level
          │
          └─→ QUIT ─→ [Exit]
```

**Key States**:
- `NOTDEFINED` – Initial/uninitialized
- `STARTUP/INITIALIZING` – Game loading resources
- `MAIN` / `GAMEMAINMENU` – Main menu screen
- `RUNNING` – Active gameplay
- `PAUSED` / `GAMEPAUSEMENU` – Pause menu
- `WAITING` – Between ball respawns
- `ENDED` / `GAMEOVER` – Game/level complete

## Lives & Respawning

**Lives System**:
- Player starts with **3 lives** (configurable)
- One life lost per ball that falls off bottom
- Ball respawns at screen center above paddle after brief delay
- Game Over when lives reach 0

**Future Enhancement**: Add pause/resume during ball respawn countdown

## Scoring

**Points Awarded** (Placeholder):
- Normal brick destroyed: +10 points
- Hard brick destroyed: +50 points (if implemented)
- Power-up collected: Varies by power-up type (future)

**Score Display**:
- HUD shows current score in top-left or top-center
- (Optional) Implement high score tracking and persistence

## Level Design

### Current Implementation
- Single level with 8×8 grid of bricks (configurable via TileMap)
- All bricks are normal (1-hit) variety
- Static layout (no pattern/procedural generation planned)

### Level Progression (Future)
- Multiple hardcoded levels with increasing difficulty:
  - More bricks
  - Harder brick types
  - Tighter spacing
- Load next level when all bricks destroyed

### Level Editor (Future)
- TileMap-based visual level editor in Godot
- Export/import level layouts
- Create custom levels without code changes

## Input Controls

| Action | Input | Function |
|--------|-------|----------|
| Move Left | A or ← | Move paddle left |
| Move Right | D or → | Move paddle right |
| Shoot | Space | Reserved; not currently used |
| Pause | TBD | Pause/unpause game |
| Menu | TBD | Return to main menu |
| Quit | Alt+F4 or ESC | Close game |

**Note**: Paddle movement automatically constrains to play area.

## UI/UX Elements

### Main Menu
- Title: "Break-Out Prototype"
- Buttons: Play, Settings, Quit
- (Optional) High score display

### HUD (During Gameplay)
- **Score**: Top-left, large font
- **Lives**: Top-right, visual indicators (3 hearts or text)
- **Level**: Top-center, if multiple levels
- (Optional) Ball/Brick count, combo multiplier

### Pause Menu
- Pause overlay with semi-transparent background
- Options: Resume, Settings, Quit to Menu
- Game remains rendered in background (unpaused state visible)

### Game Over / Win Screen
- Large "GAME OVER" or "LEVEL COMPLETE" message
- Final score display
- Buttons: Play Again, Quit to Menu
- (Optional) Time taken, bricks destroyed, etc.

## Difficulty & Balance

**Current Difficulty**: Moderate
- Paddle width: ~100 pixels (at 1920×1080)
- Ball speed: Moderate (initial impulse ~1200)
- Brick density: 8×8 grid (64 bricks)

**Tuning Parameters**:
```gdscript
const PADDLE_SPEED = 650.0        # Pixels per second
const BALL_INITIAL_IMPULSE = Vector2(0, -1200)
const MAX_BOUNCE_ANGLE = 60.0     # Degrees
const BOUNCE_ANGLE_SCALE = 60.0   # Angle per paddle width
```

**Balance Considerations**:
- Paddle too small → frustrating to keep ball in play
- Paddle too large → game too easy
- Ball too fast → unpredictable bounces
- Ball too slow → tedious gameplay
- Bounce angle too extreme → difficult to control direction

**Testing**: Play test with target audience; adjust paddle width, ball speed, and bounce mechanics based on feedback.

## Future Features & Expansions

### Phase 1 (Planned)
- [ ] Pause/Resume functionality
- [ ] Lives and respawn system
- [ ] Score system with persistence (high score)
- [ ] Sound effects (paddle hit, brick destroy, level complete)
- [ ] Visual feedback (screen shake, particle effects)

### Phase 2 (Backlog)
- [ ] Multiple levels with progression
- [ ] Power-ups (larger paddle, multi-ball, slow-mo, etc.)
- [ ] Hard/destructible brick types
- [ ] Combo system (consecutive bricks without paddle miss)
- [ ] Difficulty settings (easy/normal/hard)
- [ ] Main menu theme music

### Phase 3 (Nice-to-Have)
- [ ] Leaderboard (local or online)
- [ ] Achievements/Challenges
- [ ] Paddle power-ups (paddle size, stickiness, etc.)
- [ ] Procedurally generated brick layouts
- [ ] Endless mode (infinite levels with increasing difficulty)
- [ ] Mobile touch controls
- [ ] Web export (HTML5)

## Known Limitations & Workarounds

| Issue | Status | Notes |
|-------|--------|-------|
| Ball speed increases unbounded | Commented code | Speed clamping logic exists but disabled; enable if speed becomes problematic |
| Pause not fully implemented | Partial | UI exists; need to connect to game state machine |
| No sound system | Not implemented | Placeholder AudioStreamPlayer nodes ready |
| Single level only | Hardcoded | Future: Load levels from files |
| No difficulty selection | Not implemented | All games start at fixed difficulty |

## Art & Audio Style

### Visual Style
- **Theme**: Classic arcade / retro
- **Color Palette**: Bright primary colors (red, blue, yellow)
- **UI Font**: Clean, readable sans-serif
- **Animations**: Minimal; focus on responsive physics

### Audio Style
- **Sound Effects**: Retro arcade bleeps/bloops
- **Music**: Upbeat chiptune-style background track
- **Volume**: Mutable via settings menu

**Current Assets**:
- Background image: `assets/images/bg.jpg`
- Theme colors: `src/resources/themes/game_theme.tres`
- Fonts: `src/resources/fonts/` (ready for .otf/.ttf files)

## Testing Checklist

- [ ] Ball bounces correctly off walls
- [ ] Ball bounces correctly off paddle (various hit positions)
- [ ] Ball bounces correctly off bricks
- [ ] Paddle constrained to play area
- [ ] Brick destroyed on ball collision
- [ ] Bricks regenerate for new level/game
- [ ] Ball respawns after falling off bottom
- [ ] Lives decrement correctly
- [ ] Game Over triggers when lives = 0
- [ ] Level complete triggers when all bricks destroyed
- [ ] Score increments on brick destruction
- [ ] UI updates reflect game state
- [ ] No graphical glitches or overlaps

## Design Notes

### Architecture Decisions
- **RigidBody2D for ball**: Leverages Godot's physics engine; simpler than custom movement
- **CharacterBody2D for paddle**: Allows keyboard input while maintaining collision; simpler than Area2D
- **Signals for communication**: Decouples components; easy to add listeners (e.g., score UI)
- **TileMap for bricks**: Efficient grid-based layout; easily expanded to multiple levels

### Why This Approach?
- **Physics-based**: Feels responsive and satisfying
- **Minimalist**: Clear gameplay without excessive visual effects
- **Extensible**: Easy to add power-ups, levels, and features
- **Retro Appeal**: Classic gameplay with modern tools

## References

- Classic Breakout (Atari, 1976) – Original inspiration
- Arkanoid (1986) – Game mechanics reference
- Godot Physics: https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html
