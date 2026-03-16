# Break-Out Prototype - Development Guide

## Quick Start

### Prerequisites
- **Godot Engine 4.6** - Download from [godotengine.org](https://godotengine.org)
- **Git** - For version control
- A text editor or IDE (recommended: VS Code with GDScript extension, or Godot's built-in editor)

### Opening the Project

1. Open Godot Engine 4.6
2. Click "Open Project"
3. Navigate to `/home/buckdi/Projekte/godot/projekte/break-out-prototype`
4. Click "Open & Edit"
5. Godot will import the project (first time takes ~30 seconds)

### Running the Game

**In Editor**:
- Press `F5` or click the Play button (▶) in the top toolbar
- Game launches at 1920×1080 windowed
- Controls: A/D or arrow keys to move paddle, spacebar to shoot (if implemented)

**Standalone Executable**:
- See [Exporting](#exporting) section below

## Project Structure

```
src/                    # Game source code
  scenes/              # Game scenes organized by feature
    core/              # Core systems (game manager, states)
    paddle/            # Paddle controller scene
    ball/              # Ball physics scene
    brick/             # Brick destructible objects
    brickmap/          # TileMap for brick layout
    world_border/      # Collision boundaries
    main_menu/         # Menu UI
    game/              # Main gameplay scene
    ui/                # Game HUD and UI
  resources/           # Godot resources
    fonts/             # Font files (.otf, .ttf)
    themes/            # UI theme resources

assets/                # Non-code game assets
  images/              # Textures, sprites, backgrounds
  audio/               # Sound effects and music (prepared for future)

docs/                  # Technical documentation
  ARCHITECTURE.md      # System design and data flow
  DEVELOPMENT.md       # This file
  STYLE_GUIDE.md       # Coding conventions
  GAME_DESIGN.md       # Game mechanics and design

project.godot          # Godot project configuration
build_config.json      # Export builder configuration
export_presets.cfg     # Export profiles (Linux, Windows)
```

## Development Workflow

### Creating a New Scene

1. Right-click in FileSystem panel → New Resource → PackedScene
2. Choose root node type (e.g., Node2D, CharacterBody2D, Control)
3. Add child nodes and scripts
4. Save with descriptive name (e.g., `paddle.tscn`)
5. Place in appropriate folder under `src/scenes/`

### Adding a Script

1. Right-click node → Attach Script
2. Path should follow pattern: `res://src/scenes/[component]/[script_name].gd`
3. Follow Godot naming conventions (snake_case for files)
4. Add class_name if it's a reusable component: `class_name PaddleController extends CharacterBody2D`

### Testing Changes

After modifying code:
1. **Save the file** (Ctrl+S)
2. **Switch back to Godot window** (alt+tab)
3. Godot auto-reloads the script
4. **Press F5** to restart the game and test

### Debugging

**In-Editor Debugging**:
- Set breakpoints by clicking line numbers
- Press F6 to debug (runs with debugger attached)
- Step through code with F10 (step over) or F11 (step into)

**Console Output**:
- View Output panel at bottom of editor
- Use `print()` statements to log debug info
- Example: `print("Ball position: ", ball.position)`

**Scene Tree Inspection**:
- While game runs, click the Remote tab (next to Scene)
- Inspect live node properties and change values
- Useful for debugging node positions, velocities, signal connections

**Physics Visualization**:
- Play menu → Toggle Physics Debug → Visible Collision Shapes
- Displays all collision bodies, areas, and shapes in green/red
- Red = contact point; Green = shape outline

### Committing Changes

Always use clear commit messages:

```bash
cd /home/buckdi/Projekte/godot/projekte/break-out-prototype
git add .
git commit -m "Add: Feature description or Fix: Bug description

Detailed explanation of the change, impact, and any relevant context.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

**Branch Usage**:
- `main` or `master` – Stable release versions
- `develop` – Integration branch for features
- `branch_*` – Feature branches (e.g., `branch_refactor_structure`)

### Code Review Checklist

Before pushing commits, verify:
- [ ] Code follows Godot style guide (see STYLE_GUIDE.md)
- [ ] No hardcoded paths (use `res://` relative paths or UIDs)
- [ ] Signals properly documented in script header
- [ ] Exports have helpful descriptions and ranges
- [ ] No console errors or warnings when running
- [ ] Game can be built/exported without errors

## Building & Exporting

### Export Profiles

The project has two built-in export profiles:

**Linux** (x86_64):
- **Path**: `.exports/` (automatic)
- **Features**: S3TC/BPTC texture compression, Embedded PCK, Console output

**Windows Desktop** (x86_64):
- **Path**: `.exports/` (automatic)
- **Features**: S3TC/BPTC texture compression, Embedded PCK, Direct3D 12 rendering

### Exporting to Standalone Executable

**Via Godot Editor**:
1. Project → Export (Ctrl+Alt+E)
2. Select desired export profile (Linux or Windows Desktop)
3. Click Export
4. Choose output directory and filename
5. Wait for build (30-60 seconds)

**Via Command Line**:
```bash
/usr/local/bin/godot --export-debug "Linux" ".exports/break-out-prototype_linux.x86_64"
/usr/local/bin/godot --export-debug "Windows Desktop" ".exports/break-out-prototype_windows.exe"
```

**Using Build Config**:
External build scripts can use `build_config.json` to automate exports:
```json
{
  "godot": {"path": "/usr/local/bin/godot", "version": "4.6"},
  "build": {
    "project_name": "break-out-prototype",
    "export_root": ".exports/",
    "output_filename": "{project}_{date}_{os}_{type}"
  }
}
```

### After Exporting

Verify the exported game:
1. Navigate to `.exports/` directory
2. Run the executable
3. Test basic gameplay: move paddle, ball physics, brick collision
4. Check for any error messages

## Troubleshooting

### Game Won't Start in Editor
- **Error**: "Scene not found"
- **Solution**: Check that `project.godot` points to correct main scene via UID
- **Fix**: Project → Project Settings → Application → Run → Main Scene

### Scripts Show Red Squiggly Lines
- **Error**: "Cannot find symbol" or "Undefined class"
- **Solution**: Godot may not have indexed the scripts yet
- **Fix**: Wait 5 seconds, or right-click script → Force Update Script (Ctrl+Shift+K)

### Ball/Paddle Positions Wrong After Moving Files
- **Error**: Components spawn off-screen
- **Solution**: Scene references may be broken
- **Fix**: Open the .tscn file in a text editor, verify node references are correct UIDs

### Export Fails
- **Error**: "Export template not found"
- **Solution**: Need to download export templates
- **Fix**: Editor → Export → Install Android/Linux/Windows Templates (depending on target)

### Game Crashes on Start
- **Error**: "Autoload scene not found"
- **Solution**: Game manager path changed
- **Fix**: Project Settings → Autoload → Verify `Game` points to `res://src/scenes/core/game_manager.gd`

## Performance Profiling

### Built-In Profiler
- Debug → Monitor (or F4)
- Watch FPS, Memory usage, Physics time
- If FPS drops below 60, check:
  - Number of active physics objects
  - Number of draw calls (visible in Profiler)
  - Script _process() or _physics_process() time

### Optimization Tips
- Use groups (`add_to_group()`) for batch operations instead of finding nodes
- Cache @onready references to avoid repeated `get_node()` calls
- Disable physics for invisible objects when possible
- Use `call_deferred()` for operations that don't need immediate execution

## Resources & Further Learning

- **Godot Docs**: https://docs.godotengine.org/en/stable/
- **GDScript Style Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Physics in Godot**: https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html
- **Signals Tutorial**: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

## Common Tasks

### Add a New Power-Up
1. Create scene `src/scenes/powerups/[powerup_name].tscn`
2. Use Area2D for pickup collision
3. Listen to brick destruction signal to spawn powerup
4. Check `overlaps_area()` with paddle for collection

### Implement Score Display
1. Add property to Game Manager: `var score = 0`
2. Emit signal on score change: `score_changed.emit(score)`
3. Connect UI to signal: `Game.score_changed.connect(on_score_changed)`
4. Update Label in UI handler: `score_label.text = "Score: %d" % score`

### Add Sound Effects
1. Place .ogg or .mp3 files in `assets/audio/`
2. Create AudioStreamPlayer node in scene
3. Reference audio: `@onready var sfx = $AudioStreamPlayer`
4. Play on event: `sfx.play()`

### Create a New Level
1. Create new TileMapLayer scene: `src/scenes/brickmap/level_2.tscn`
2. Paint different tile layout using TileSet
3. Update game logic to load appropriate level

## Development Tips

- **Use Git branches** for experimental features: `git checkout -b branch_feature_name`
- **Keep scenes small** – Large scenes are slow to load and edit
- **Avoid circular dependencies** – Scene A references Scene B references Scene A
- **Comment complex logic** – Future you will thank current you
- **Test edge cases** – Ball hitting corner, paddle at screen edge, etc.
