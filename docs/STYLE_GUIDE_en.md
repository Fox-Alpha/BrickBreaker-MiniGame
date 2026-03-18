# Break-Out Prototype - Style Guide & Conventions

This guide documents the coding conventions and style rules for the Break-Out Prototype project. We follow the **Godot GDScript Style Guide** with project-specific extensions.

## Reference

- **Godot GDScript Style Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Project Structure**: See docs/DEVELOPMENT.md for folder organization

## Naming Conventions

### Files & Folders

**Rule**: Use `snake_case` for all file and folder names.

**Examples**:
```
✅ CORRECT:
  src/scenes/paddle/paddle_controller.gd
  src/scenes/ball/ball_physics.gd
  src/scenes/main_menu/main_view.gd
  src/resources/themes/game_theme.tres

❌ WRONG:
  src/scenes/paddle/PaddleController.gd
  src/scenes/ball/BallPhysics.gd
  src/scenes/main_menu/MainView.gd
```

**Folder Organization**:
- Feature folders by component: `src/scenes/[component_name]/`
- Shared asset folders by type: `src/resources/[type]/`, `assets/[type]/`
- Documentation in `docs/`

### Class Names

**Rule**: Use `PascalCase` for class names (use `class_name` directive).

**Pattern**: `class_name [ComponentName]Controller extends [NodeType]`

**Examples**:
```gdscript
✅ CORRECT:
  class_name PaddleController extends CharacterBody2D
  class_name BallPhysics extends RigidBody2D
  class_name BrickBase extends StaticBody2D

❌ WRONG:
  class_name paddleController extends CharacterBody2D
  class_name ball_physics extends RigidBody2D
```

**When to use class_name**:
- Always, for reusable components
- Enables type hints and better IDE support
- Allows `@onready` and `@export` to work correctly

### Variables

**Rule**: Use `snake_case` for all variables.

**Scope Prefixes** (optional but recommended):
- Private variables: `_variable` (underscore prefix)
- Constants: `CONSTANT_NAME` (all caps)

**Examples**:
```gdscript
✅ CORRECT:
  var player_speed = 100.0
  var _internal_state = false
  const MAX_VELOCITY = 500.0
  var is_moving: bool = false

❌ WRONG:
  var playerSpeed = 100.0           # camelCase
  var player_Speed = 100.0          # mixed case
  var PLAYER_SPEED = 100.0          # public constant-style
```

### Functions & Methods

**Rule**: Use `snake_case` for function names.

**Callback Pattern**: `_on_[signal_source]_[signal_name]`
- Example: `func _on_timer_timeout() -> void:`
- Example: `func _on_paddle_collision_entered(body: Node2D) -> void:`

**Examples**:
```gdscript
✅ CORRECT:
  func calculate_bounce_angle(hit_pos: float) -> float:
  func _ready() -> void:
  func _on_brick_area_body_entered(body: Node2D) -> void:
  func get_paddle_size() -> Vector2i:

❌ WRONG:
  func CalculateBounceAngle(hit_pos: float) -> float:
  func onBrickAreaBodyEntered(body: Node2D) -> void:
  func getPaddleSize() -> Vector2i:
```

### Constants

**Rule**: Use `SCREAMING_SNAKE_CASE` for all constants.

**Scope**: Define at top of script after imports.

**Examples**:
```gdscript
✅ CORRECT:
  const BALL_SPEED = 100.0
  const MAX_BOUNCE_ANGLE = 60.0
  const INITIAL_IMPULSE = Vector2(0, -1200)
  const PLAYER_COLORS = ["red", "blue", "green"]

❌ WRONG:
  const ball_speed = 100.0
  const BallSpeed = 100.0
```

### Signals

**Rule**: Use `snake_case` for signal names.

**Naming Pattern**:
- Local signals: descriptive verb phrases
- Global signals: prefix with system name (e.g., `GL_` for Game Manager global)

**Examples**:
```gdscript
✅ CORRECT:
  signal brick_destroyed(brick_id: int)
  signal player_scored(points: int)
  signal GL_GAMESTATE_CHANGE(state: GameStates)
  signal GS_GAME_PAUSED
  signal NoMoreBrickInMap

❌ WRONG:
  signal BrickDestroyed
  signal brick_Destroyed
```

## Type Hints

**Rule**: Always include type hints for function parameters and return values.

**Pattern**:
```gdscript
func function_name(param: Type) -> ReturnType:
    var local_var: Type = value
    return result
```

**Examples**:
```gdscript
✅ CORRECT:
  func calculate_velocity(direction: Vector2, speed: float) -> Vector2:
      return direction * speed
  
  func _on_brick_hit(body: Node2D) -> void:
      var position: Vector2 = body.global_position
      print("Hit at: ", position)

❌ WRONG:
  func calculate_velocity(direction, speed):
      return direction * speed
  
  func _on_brick_hit(body):
      print("Hit at: ", body.global_position)
```

**Common Type Annotations**:
- `void` – No return value
- `int`, `float`, `bool`, `String` – Primitives
- `Vector2`, `Vector2i`, `Vector3` – Geometry
- `Node`, `Node2D`, `Control` – Node types
- `Array[Type]`, `Dictionary[KeyType, ValueType]` – Collections
- `PackedScene`, `Resource` – Game objects
- Custom classes via `class_name`

## Code Organization

### File Structure

Organize scripts in this order:

```gdscript
# 1. Class definition
class_name MyComponent extends Node2D

# 2. Imports/Dependencies
extends Node2D

# 3. Constants
const SPEED = 100.0

# 4. Enums
enum State { IDLE, MOVING, JUMPING }

# 5. Signals
signal speed_changed(new_speed: float)

# 6. Exported variables (@export)
@export var is_active: bool = true
@export_range(0.0, 100.0) var acceleration = 50.0

# 7. Public variables
var velocity: Vector2 = Vector2.ZERO

# 8. Private variables
var _internal_state: int = 0
var _cached_size: Vector2

# 9. @onready variables
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

# 10. Lifecycle methods (_ready, _process, _physics_process)
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

# 11. Public methods
func take_damage(amount: int) -> void:
    pass

# 12. Private methods
func _calculate_velocity() -> Vector2:
    pass

# 13. Signal handlers
func _on_timer_timeout() -> void:
    pass
```

### Code Regions

Use `#region` and `#endregion` comments to group related code:

```gdscript
#region Signals
signal brick_destroyed(brick_id: int)
signal player_scored(points: int)
#endregion

#region Exports
@export var speed: float = 100.0
@export_color var color: Color = Color.WHITE
#endregion

#region Lifecycle
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass
#endregion

#region Movement
func move_left() -> void:
    pass

func move_right() -> void:
    pass
#endregion
```

## Code Style

### Indentation
- **Use tabs** for indentation (Godot default)
- **4 spaces** if tabs not available
- **Consistency** – Use EditorConfig or Godot's formatter

### Line Length
- **Soft limit**: 80 characters
- **Hard limit**: 120 characters
- Break long lines for readability

**Example**:
```gdscript
✅ CORRECT (readability):
  velocity = direction.normalized() * speed

  signal_name.connect(
      callback_function,
      CONNECT_DEFERRED
  )

❌ WRONG (hard to read):
  very_long_variable_name = some_function_call(arg1, arg2, arg3, arg4, arg5) * another_function()
```

### Spacing
- **Around operators**: `a = b + c`
- **After commas**: `func(a, b, c)`
- **No space before parens**: `func()` not `func ()`
- **Blank lines** between logical sections

```gdscript
✅ CORRECT:
  var x = 10
  var y = 20
  var result = x + y
  
  # Calculation section
  var velocity = direction.normalized() * speed

❌ WRONG:
  var x=10
  var y=20
  var result=x+y
  var velocity=direction.normalized()*speed
```

### Comments

**Rule**: Write comments that explain *why*, not *what*.

```gdscript
✅ GOOD:
  # Bounce angle limited to ±60° to prevent paddle from returning ball straight up
  var bounce_angle = hit_pos * 60.0

  # Defer signal to avoid frame-timing issues with state changes
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)

❌ BAD:
  # Set bounce_angle to hit_pos * 60
  var bounce_angle = hit_pos * 60.0

  # Connect the signal
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)
```

## Export Variables (@export)

**Rule**: Use `@export` for designer-tunable parameters with helpful descriptions.

**Pattern**:
```gdscript
@export var name: Type = default_value:
    get: return name
    set(value): 
        name = value
        # Optional: emit signal or validate
```

**Examples**:
```gdscript
✅ RECOMMENDED:
  @export_range(50.0, 1000.0, 10.0) var speed = 650.0:
      set(value):
          speed = value
          speed_changed.emit(speed)
  
  @export_color var player_color: Color = Color.WHITE
  
  @export var use_mouse: bool = true

❌ AVOID:
  var speed = 650.0  # Not exported, can't be tweaked in editor
  @export var _internal_value = true  # Exported private variable is confusing
```

## Signal Usage

**Rule**: Use signals for cross-component communication.

**Pattern**:
```gdscript
# Define signal
signal component_event(data: Type)

# Emit signal when state changes
func on_event() -> void:
    component_event.emit(important_data)

# Connect in another component
func _ready() -> void:
    other_component.component_event.connect(on_component_event)

func on_component_event(data: Type) -> void:
    # Handle event
    pass
```

**Best Practices**:
- Use `CONNECT_DEFERRED` for signals that change game state
- Always disconnect signals in `_exit_tree()` if needed
- Document signal parameters in comments

```gdscript
✅ GOOD:
  signal brick_destroyed(brick_position: Vector2, points: int)
  ## Fired when brick is destroyed by ball
  ## Data includes: brick world position, points earned

❌ BAD:
  signal event(data)  # Ambiguous
```

## Common Patterns

### Property with Setter/Getter
```gdscript
var speed: float = 100.0:
    set(value):
        speed = value
        speed_changed.emit(speed)
    get:
        return speed
```

### Resource Preloading
```gdscript
const BALL_SCENE = preload("uid://bx7lmlxv60bk7")
# Use UID instead of file path for better reliability

var ball = BALL_SCENE.instantiate()
```

### Scene References
```gdscript
@export var paddle_scene: PackedScene  # Set in editor
# Allows designer to change which scene to use without code changes
```

## Anti-Patterns (Avoid)

```gdscript
❌ DON'T:
  # Hardcoded paths (fragile)
  var scene = load("res://scenes/ball/ball_body.tscn")
  
  # Direct node access without caching
  func _process(delta):
      $CollisionShape2D.position = ...  # Inefficient
  
  # Magic numbers without explanation
  velocity.y = -1200  # What is this?
  
  # Unclear variable names
  var x = 10  # What is x?
  var temp = velocity  # Temporary for what?
  
  # Circular signal connections
  A connects to B signal, B connects to A signal

✅ DO:
  # Use UIDs or export for paths
  const BALL_SCENE = preload("uid://bx7lmlxv60bk7")
  
  # Cache references in _ready
  @onready var collision = $CollisionShape2D
  
  # Name constants
  const INITIAL_BOUNCE_IMPULSE = Vector2(0, -1200)
  
  # Descriptive variable names
  var initial_velocity = velocity
  
  # One-way signal flow or deferred connections
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)
```

## Linting & Formatting

**Current Status**: No automated linting configured.

**Recommendations for Future**:
- Use Godot's built-in GDScript formatter (Ctrl+Shift+I in editor)
- Consider gdlint or similar tools for CI/CD pipelines
- EditorConfig (`.editorconfig`) ensures consistent formatting across editors

## Migration Notes

### From Quickand-Dirty Prototype
The old codebase had some inconsistencies:
- ~~`globals.gd`~~ → `game_manager.gd` (clearer naming)
- ~~`ball_body.gd`~~ → `ball_physics.gd` (descriptive)
- ~~`paddle_controller.tscn`~~ → `paddle.tscn` (consistent with script name)
- ~~`MainView.gd`~~ → `main_view.gd` (snake_case)
- ~~`world_boundarys.gd`~~ → `world_border.gd` (proper spelling)

Experimental/legacy files have been archived:
- ~~`brick_claude_ai.gd`~~ → `brick_claude_ai.gd.bak`
- ~~`ball_rigid.gd`~~ → `ball_rigid.gd.bak`

## Questions?

Refer to:
- **Godot Style Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Architecture**: `docs/ARCHITECTURE.md`
- **Development**: `docs/DEVELOPMENT.md`
