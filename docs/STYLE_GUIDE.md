# Break-Out Prototype - Style Guide & Konventionen

Diese Anleitung dokumentiert die Code-Konventionen und Style-Regeln für das Break-Out Prototype Projekt. Wir folgen dem **Godot GDScript Style Guide** mit projektspezifischen Erweiterungen.

## Referenzen

- **Godot GDScript Style Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Projektstruktur**: Siehe docs/DEVELOPMENT.md für die Ordnerorganisation

## Namenskonventionen

### Dateien & Ordner

**Regel**: Verwende `snake_case` für alle Datei- und Ordnernamen.

**Beispiele**:
```
✅ RICHTIG:
  src/scenes/paddle/paddle_controller.gd
  src/scenes/ball/ball_physics.gd
  src/scenes/main_menu/main_view.gd
  src/resources/themes/game_theme.tres

❌ FALSCH:
  src/scenes/paddle/PaddleController.gd
  src/scenes/ball/BallPhysics.gd
  src/scenes/main_menu/MainView.gd
```

**Ordnerorganisation**:
- Feature-Ordner nach Komponenten: `src/scenes/[component_name]/`
- Gemeinsame Asset-Ordner nach Typ: `src/resources/[type]/`, `assets/[type]/`
- Dokumentation in `docs/`

### Klassennamen

**Regel**: Verwende `PascalCase` für Klassennamen (nutze die `class_name` Direktive).

**Muster**: `class_name [ComponentName]Controller extends [NodeType]`

**Beispiele**:
```gdscript
✅ RICHTIG:
  class_name PaddleController extends CharacterBody2D
  class_name BallPhysics extends RigidBody2D
  class_name BrickBase extends StaticBody2D

❌ FALSCH:
  class_name paddleController extends CharacterBody2D
  class_name ball_physics extends RigidBody2D
```

**Wann class_name verwenden**:
- Immer, bei wiederverwendbaren Komponenten
- Ermöglicht Type Hints und bessere IDE-Unterstützung
- Erlaubt `@onready` und `@export` korrekt zu funktionieren

### Variablen

**Regel**: Verwende `snake_case` für alle Variablen.

**Scope-Präfixe** (optional, aber empfohlen):
- Private Variablen: `_variable` (Unterstrich-Präfix)
- Konstanten: `CONSTANT_NAME` (komplett Großbuchstaben)

**Beispiele**:
```gdscript
✅ RICHTIG:
  var player_speed = 100.0
  var _internal_state = false
  const MAX_VELOCITY = 500.0
  var is_moving: bool = false

❌ FALSCH:
  var playerSpeed = 100.0           # camelCase
  var player_Speed = 100.0          # gemischte Groß-/Kleinschreibung
  var PLAYER_SPEED = 100.0          # öffentlicher Konstanten-Stil
```

### Funktionen & Methoden

**Regel**: Verwende `snake_case` für Funktionsnamen.

**Callback-Muster**: `_on_[signal_source]_[signal_name]`
- Beispiel: `func _on_timer_timeout() -> void:`
- Beispiel: `func _on_paddle_collision_entered(body: Node2D) -> void:`

**Beispiele**:
```gdscript
✅ RICHTIG:
  func calculate_bounce_angle(hit_pos: float) -> float:
  func _ready() -> void:
  func _on_brick_area_body_entered(body: Node2D) -> void:
  func get_paddle_size() -> Vector2i:

❌ FALSCH:
  func CalculateBounceAngle(hit_pos: float) -> float:
  func onBrickAreaBodyEntered(body: Node2D) -> void:
  func getPaddleSize() -> Vector2i:
```

### Konstanten

**Regel**: Verwende `SCREAMING_SNAKE_CASE` für alle Konstanten.

**Scope**: Definiere am Anfang des Skripts nach den Imports.

**Beispiele**:
```gdscript
✅ RICHTIG:
  const BALL_SPEED = 100.0
  const MAX_BOUNCE_ANGLE = 60.0
  const INITIAL_IMPULSE = Vector2(0, -1200)
  const PLAYER_COLORS = ["red", "blue", "green"]

❌ FALSCH:
  const ball_speed = 100.0
  const BallSpeed = 100.0
```

### Signale

**Regel**: Verwende `snake_case` für Signalnamen.

**Benennungsmuster**:
- Lokale Signale: beschreibende Verb-Phrasen
- Globale Signale: Präfix mit Systemnamen (z.B. `GL_` für Game Manager global)

**Beispiele**:
```gdscript
✅ RICHTIG:
  signal brick_destroyed(brick_id: int)
  signal player_scored(points: int)
  signal GL_GAMESTATE_CHANGE(state: GameStates)
  signal GS_GAME_PAUSED
  signal NoMoreBrickInMap

❌ FALSCH:
  signal BrickDestroyed
  signal brick_Destroyed
```

## Type Hints

**Regel**: Füge immer Type Hints für Funktionsparameter und Rückgabewerte hinzu.

**Muster**:
```gdscript
func function_name(param: Type) -> ReturnType:
    var local_var: Type = value
    return result
```

**Beispiele**:
```gdscript
✅ RICHTIG:
  func calculate_velocity(direction: Vector2, speed: float) -> Vector2:
      return direction * speed
  
  func _on_brick_hit(body: Node2D) -> void:
      var position: Vector2 = body.global_position
      print("Hit at: ", position)

❌ FALSCH:
  func calculate_velocity(direction, speed):
      return direction * speed
  
  func _on_brick_hit(body):
      print("Hit at: ", body.global_position)
```

**Häufige Type-Annotationen**:
- `void` – Kein Rückgabewert
- `int`, `float`, `bool`, `String` – Primitive Typen
- `Vector2`, `Vector2i`, `Vector3` – Geometrie
- `Node`, `Node2D`, `Control` – Node-Typen
- `Array[Type]`, `Dictionary[KeyType, ValueType]` – Collections
- `PackedScene`, `Resource` – Spielobjekte
- Eigene Klassen via `class_name`

## Code-Organisation

### Dateistruktur

Organisiere Skripte in dieser Reihenfolge:

```gdscript
# 1. Klassendefinition
class_name MyComponent extends Node2D

# 2. Imports/Abhängigkeiten
extends Node2D

# 3. Konstanten
const SPEED = 100.0

# 4. Enums
enum State { IDLE, MOVING, JUMPING }

# 5. Signale
signal speed_changed(new_speed: float)

# 6. Exportierte Variablen (@export)
@export var is_active: bool = true
@export_range(0.0, 100.0) var acceleration = 50.0

# 7. Öffentliche Variablen
var velocity: Vector2 = Vector2.ZERO

# 8. Private Variablen
var _internal_state: int = 0
var _cached_size: Vector2

# 9. @onready Variablen
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

# 10. Lifecycle-Methoden (_ready, _process, _physics_process)
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

# 11. Öffentliche Methoden
func take_damage(amount: int) -> void:
    pass

# 12. Private Methoden
func _calculate_velocity() -> Vector2:
    pass

# 13. Signal-Handler
func _on_timer_timeout() -> void:
    pass
```

### Code-Regionen

Verwende `#region` und `#endregion` Kommentare, um verwandten Code zu gruppieren:

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

## Code-Stil

### Einrückung
- **Verwende Tabs** für Einrückung (Godot Standard)
- **4 Leerzeichen** falls Tabs nicht verfügbar
- **Konsistenz** – Nutze EditorConfig oder Godots Formatter

### Zeilenlänge
- **Soft Limit**: 80 Zeichen
- **Hard Limit**: 120 Zeichen
- Breche lange Zeilen für bessere Lesbarkeit um

**Beispiel**:
```gdscript
✅ RICHTIG (Lesbarkeit):
  velocity = direction.normalized() * speed

  signal_name.connect(
      callback_function,
      CONNECT_DEFERRED
  )

❌ FALSCH (schwer zu lesen):
  very_long_variable_name = some_function_call(arg1, arg2, arg3, arg4, arg5) * another_function()
```

### Leerzeichen
- **Um Operatoren herum**: `a = b + c`
- **Nach Kommas**: `func(a, b, c)`
- **Kein Leerzeichen vor Klammern**: `func()` nicht `func ()`
- **Leerzeilen** zwischen logischen Abschnitten

```gdscript
✅ RICHTIG:
  var x = 10
  var y = 20
  var result = x + y
  
  # Berechnungsabschnitt
  var velocity = direction.normalized() * speed

❌ FALSCH:
  var x=10
  var y=20
  var result=x+y
  var velocity=direction.normalized()*speed
```

### Kommentare

**Regel**: Schreibe Kommentare, die erklären *warum*, nicht *was*.

```gdscript
✅ GUT:
  # Bounce-Winkel auf ±60° begrenzt, um zu verhindern, dass der Paddle den Ball direkt nach oben zurückwirft
  var bounce_angle = hit_pos * 60.0

  # Signal verzögern, um Frame-Timing-Probleme bei Statusänderungen zu vermeiden
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)

❌ SCHLECHT:
  # Setze bounce_angle auf hit_pos * 60
  var bounce_angle = hit_pos * 60.0

  # Verbinde das Signal
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)
```

## Export-Variablen (@export)

**Regel**: Verwende `@export` für Designer-anpassbare Parameter mit hilfreichen Beschreibungen.

**Muster**:
```gdscript
@export var name: Type = default_value:
    get: return name
    set(value): 
        name = value
        # Optional: emit signal oder validieren
```

**Beispiele**:
```gdscript
✅ EMPFOHLEN:
  @export_range(50.0, 1000.0, 10.0) var speed = 650.0:
      set(value):
          speed = value
          speed_changed.emit(speed)
  
  @export_color var player_color: Color = Color.WHITE
  
  @export var use_mouse: bool = true

❌ VERMEIDEN:
  var speed = 650.0  # Nicht exportiert, kann im Editor nicht angepasst werden
  @export var _internal_value = true  # Exportierte private Variable ist verwirrend
```

## Signal-Verwendung

**Regel**: Verwende Signale für Komponenten-übergreifende Kommunikation.

**Muster**:
```gdscript
# Signal definieren
signal component_event(data: Type)

# Signal auslösen bei Statusänderung
func on_event() -> void:
    component_event.emit(important_data)

# In anderer Komponente verbinden
func _ready() -> void:
    other_component.component_event.connect(on_component_event)

func on_component_event(data: Type) -> void:
    # Event behandeln
    pass
```

**Best Practices**:
- Verwende `CONNECT_DEFERRED` für Signale, die den Spielstatus ändern
- Trenne Signale immer in `_exit_tree()` ab, falls notwendig
- Dokumentiere Signal-Parameter in Kommentaren

```gdscript
✅ GUT:
  signal brick_destroyed(brick_position: Vector2, points: int)
  ## Wird ausgelöst, wenn ein Brick vom Ball zerstört wird
  ## Daten beinhalten: Brick-Weltposition, verdiente Punkte

❌ SCHLECHT:
  signal event(data)  # Mehrdeutig
```

## Häufige Muster

### Property mit Setter/Getter
```gdscript
var speed: float = 100.0:
    set(value):
        speed = value
        speed_changed.emit(speed)
    get:
        return speed
```

### Ressourcen-Preloading
```gdscript
const BALL_SCENE = preload("uid://bx7lmlxv60bk7")
# Verwende UID statt Dateipfad für bessere Zuverlässigkeit

var ball = BALL_SCENE.instantiate()
```

### Szenen-Referenzen
```gdscript
@export var paddle_scene: PackedScene  # Im Editor setzen
# Erlaubt dem Designer, die zu verwendende Szene ohne Code-Änderungen zu ändern
```

## Anti-Muster (Vermeiden)

```gdscript
❌ NICHT TUN:
  # Hardcodierte Pfade (fragil)
  var scene = load("res://scenes/ball/ball_body.tscn")
  
  # Direkter Node-Zugriff ohne Caching
  func _process(delta):
      $CollisionShape2D.position = ...  # Ineffizient
  
  # Magische Zahlen ohne Erklärung
  velocity.y = -1200  # Was ist das?
  
  # Unklare Variablennamen
  var x = 10  # Was ist x?
  var temp = velocity  # Temporär wofür?
  
  # Zirkuläre Signal-Verbindungen
  A verbindet sich mit B Signal, B verbindet sich mit A Signal

✅ TUN:
  # Verwende UIDs oder export für Pfade
  const BALL_SCENE = preload("uid://bx7lmlxv60bk7")
  
  # Cache Referenzen in _ready
  @onready var collision = $CollisionShape2D
  
  # Benenne Konstanten
  const INITIAL_BOUNCE_IMPULSE = Vector2(0, -1200)
  
  # Beschreibende Variablennamen
  var initial_velocity = velocity
  
  # Einweg-Signal-Fluss oder verzögerte Verbindungen
  Game.GL_GAMESTATE_CHANGE.connect(on_state_changed, CONNECT_DEFERRED)
```

## Linting & Formatierung

**Aktueller Status**: Keine automatisierte Linting-Konfiguration vorhanden.

**Empfehlungen für die Zukunft**:
- Verwende Godots eingebauten GDScript-Formatter (Strg+Shift+I im Editor)
- Erwäge gdlint oder ähnliche Tools für CI/CD-Pipelines
- EditorConfig (`.editorconfig`) sorgt für konsistente Formatierung über Editoren hinweg

## Migrations-Hinweise

### Vom Quick-and-Dirty Prototyp
Die alte Codebasis hatte einige Inkonsistenzen:
- ~~`globals.gd`~~ → `game_manager.gd` (klarere Benennung)
- ~~`ball_body.gd`~~ → `ball_physics.gd` (beschreibend)
- ~~`paddle_controller.tscn`~~ → `paddle.tscn` (konsistent mit Skriptname)
- ~~`MainView.gd`~~ → `main_view.gd` (snake_case)
- ~~`world_boundarys.gd`~~ → `world_border.gd` (korrekte Rechtschreibung)

Experimentelle/Legacy-Dateien wurden archiviert:
- ~~`brick_claude_ai.gd`~~ → `brick_claude_ai.gd.bak`
- ~~`ball_rigid.gd`~~ → `ball_rigid.gd.bak`

## Fragen?

Siehe:
- **Godot Style Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Architektur**: `docs/ARCHITECTURE.md`
- **Entwicklung**: `docs/DEVELOPMENT.md`
