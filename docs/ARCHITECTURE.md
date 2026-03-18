# Break-Out Prototype - Architektur

## Übersicht

Break-Out Prototype ist ein Godot 4.6 2D-Spiel, das das klassische Breakout/Brick-Breaker Genre implementiert. Die Codebasis folgt einem **hybriden Organisationsansatz**: Komponenten sind nach Features gruppiert (Paddle, Ball, Brick), während gemeinsame Systeme zentral über das Game-Singleton verwaltet werden.

## Kernsysteme

### Game State Machine (Singleton)

**Datei**: `src/scenes/core/game_manager.gd` (Autoload: `Game`)

Das Game-Singleton bietet zentralisiertes Zustandsmanagement und globale Signal-Koordination.

**Hauptfunktionen**:
- **GameStates Enum**: 60+ Zustandsdefinitionen für:
  - Initialisierungszustände (NOTDEFINED, STARTUP, INITIALIZING, INITIALIZED)
  - Gameplay-Zustände (ACTIVE, RUNNING, PAUSED)
  - UI/Menü-Zustände (MENU, PAUSE, SETTINGS, SCORE)
  - Session-Zustände (GAME_SESSION_INITIALIZED, GAMESESSIONRUNNING, etc.)

- **Zustandsänderungen**: Verwendung des Property-Setter-Patterns für automatische Signal-Emission:
  ```gdscript
  Game.GameState = Game.GameStates.RUNNING  # Löst GL_GAMESTATE_CHANGE Signal aus
  ```

- **Globale Signale**:
  - `GL_GAMESTATE_CHANGE(state: GameStates)` – Wird nach Zustandsänderung emittiert
  - `GL_CHANGE_GAMESTATE(state: GameStates)` – Zustandsänderung anfordern
  - `Game_Window_Size_Changed` – Wird bei Viewport-Größenänderung emittiert

- **RNG**: Globaler Zufallszahlengenerator mit festem Seed (19771202) für reproduzierbare Zufälligkeit

### Game Scene (Haupt-Gameplay-Controller)

**Datei**: `src/scenes/game/game.gd` / `game.tscn`

Die Game-Szene ist das Root-Node2D für aktives Gameplay und instanziiert sowie verwaltet zentrale Gameplay-Objekte.

**Verantwortlichkeiten**:
- Dynamische Instanziierung von Paddle und Ball beim Spielstart (via `startgame()`)
- Verwaltung von Referenzen auf Tilemap, Kamera und Canvas Layer
- Koordination zwischen Spielobjekten durch Signale

**Wichtige Signale**:
- `NoMoreBrickInMap` – Wird ausgelöst, wenn alle Bricks zerstört sind
- `GS_GAME_PAUSED` / `GS_GAME_UNPAUSED` – Gameplay-Pause-Zustandsänderungen
- `Reset_Game`, `Player_Score` – Score- und Reset-Events

**Design-Hinweis**: Game instanziiert den Ball dynamisch über eine vorgeladene Szene (`uid://bx7lmlxv60bk7`) und das Paddle aus einer exportierten PackedScene-Property. Dies ermöglicht Flexibilität beim Austausch von Szenen ohne Code-Änderungen.

## Komponenten-Architektur

### Paddle-System

**Datei**: `src/scenes/paddle/paddle.tscn` + `paddle_controller.gd`

**Typ**: CharacterBody2D

**Features**:
- Zwei Steuerungsmodi (umschaltbar via `@export var use_mouse`):
  - **Maussteuerung**: Position folgt sanft dem Cursor via Lerp
  - **Tastatursteuerung**: A/D oder Pfeiltasten mit frame-basierter Beschleunigung
- Farbanpassung über `@export_color playercolor`
- Geschwindigkeitsanpassung: `@export_range(100.0, 1000.0, 10.0) SPEED`
- **Kollision**: Erkennt Ball-Kollisionen via `Area2D` und lenkt Ball basierend auf Trefferposition ab
  - Abprallwinkel-Berechnung: bis zu ±60° Ablenkung basierend auf Trefferposition relativ zur Paddle-Mitte

**Wichtige Methoden**:
- `getPaddleSize() -> Vector2i` – Gibt Kollisionsform-Dimensionen zurück
- `_mouse_move()` – Aktualisiert Position basierend auf Cursor
- `_move_with_keyboard(delta)` – Verarbeitet Tastatureingaben
- `_on_area_2d_body_entered(body)` – Kollisions-Callback; lenkt Ball ab

### Ball-System

**Datei**: `src/scenes/ball/ball.tscn` + `ball_physics.gd`

**Typ**: RigidBody2D

**Features**:
- Physik-basierte Bewegung über `linear_velocity`
- Initialer Impuls: `apply_central_impulse(Vector2(0, -1200))`
- Kollision wird von Godots Physics-Engine verarbeitet (kein manuelles move_and_collide)
- Setzt sich bei `reset()`-Aufruf auf Viewport-Zentrum zurück

**Design-Hinweis**: Der Ball nutzt RigidBody2D für automatische Physiksimulation. Geschwindigkeitsänderungen beim Abprallen werden von der Kollisionsantwort der Physics-Engine verarbeitet. Das Paddle modifiziert `linear_velocity` direkt bei Kollision.

### Brick-System

**Dateien**:
- `src/scenes/brick/brick.tscn` – Haupt-Brick-Szene
- `brick.gd` – Aktuelle Implementierung
- `brick_base.gd` – Basisklasse (optional)
- `brick_claude_ai.gd.bak` – Legacy-Alternative (archiviert)

**Typ**: StaticBody2D

**Features**:
- Emittiert `HitByBall` Signal bei Ball-Kollision
- Fügt sich automatisch zur "Brick"-Gruppe beim Tree-Entry hinzu
- Dynamische Benennung über Instance-ID: `Brick_{instance_id}`
- Selbstzerstörung bei Treffer via `queue_free()`

**Signal-Fluss**:
```
Ball kollidiert → _on_brick_area_body_shape_entered() wird ausgelöst
→ HitByBall Signal emittiert
→ _On_Hit_by_ball() Handler ausgeführt
→ Brick für Löschung vorgemerkt
→ BrickMap erkennt Brick-Anzahl-Änderung
```

### Brick Map System

**Dateien**: `src/scenes/brickmap/brick_map.tscn` + `brick_map.gd`

**Typ**: TileMapLayer

**Verantwortlichkeiten**:
- Verwaltet 2D-Gitter von Brick-Instanzen
- Verfolgt Gesamt-Brick-Anzahl
- Emittiert `NoMoreBrickInMap` Signal, wenn alle Bricks zerstört sind
- Kann Tile-Metadaten oder visuellen Zustand pro Brick aktualisieren

### World Boundaries

**Dateien**: `src/scenes/world_border/world_border.tscn` + `world_border.gd`

**Zweck**:
- Erstellt Kollisionsgrenzen (Wände, Boden)
- Verhindert, dass Ball/Paddle den Spielbereich verlassen
- Verarbeitet "Death Plane"-Erkennung (Ball fällt unten herunter)

**Implementierung**: Verwendet Collision Bodies (StaticBody2D oder CollisionShape2D), die an Viewport-Rändern positioniert sind.

### UI-System

**Dateien**: `src/scenes/ui/game_ui.tscn` + `game_ui.gd`

**Typ**: CanvasLayer

**Verantwortlichkeiten**:
- Score-Anzeige und Updates
- Leben-Zähler
- Spielstatus-Nachrichten
- HUD-Elemente (Pause-Indikator, Level-Info)

**Verbindung**: Game-Szene übergibt Ball-Referenz an canvas_layer: `canvas_layer.ball = ball`

### Hauptmenü-System

**Dateien**:
- `src/scenes/main_menu/main_menu.tscn` – Container-Szene
- `main_view.tscn` / `main_view.gd` – View-Inhalt und Logik

**Typ**: Control-basierte UI

**Features**:
- Hauptmenü-Einstiegspunkt
- Navigation zwischen Views (Spielen, Einstellungen, Beenden)
- Übergang zum Gameplay bei "Spielen"-Auswahl

## Signal-Fluss-Diagramm

```
┌─────────────────────────────────────────────┐
│ Game Manager (Singleton)                     │
│  - GameState Maschine                        │
│  - Globale Signale: GL_GAMESTATE_CHANGE     │
│  - Window Events                             │
└─────────────────────────────────────────────┘
                    ↑
                    │ GL_GAMESTATE_CHANGE
                    │
┌─────────────────────────────────────────────┐
│ Game Scene (Main Game Root)                  │
│  - Instanziiert Paddle & Ball                │
│  - Verwaltet Szenen-Level Signale            │
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
    │ - Kollisionen (Paddle, Wände, etc)  │
    │ - Geschwindigkeitsberechnungen      │
    └────────────────────────────────────┘
```

## Datenfluss-Beispiel: Brick-Zerstörung

1. **Ball kollidiert mit Brick** → Physik-Kollision erkannt
2. **Brick._on_brick_area_body_shape_entered()** wird ausgeführt
3. **HitByBall Signal emittiert**
4. **Brick._On_Hit_by_ball()** merkt Brick für Löschung vor
5. **BrickMap erkennt Änderung** im nächsten Frame
6. **Falls alle Bricks weg**: BrickMap emittiert `NoMoreBrickInMap`
7. **Game lauscht** auf NoMoreBrickInMap Signal
8. **Game kann übergehen** zu Win-State oder nächstem Level

## Konventionen & Patterns

### State Management Pattern
```gdscript
# Setter-basierter Zustandswechsel mit Signal-Emission
var GameState : GameStates = GameStates.NOTDEFINED :
    set(value):
        GameState = value
        GL_GAMESTATE_CHANGE.emit(GameState)
```

### Signal-basierte Kommunikation
Komponenten kommunizieren über Signale statt direkter Methodenaufrufe. Dies entkoppelt Systeme und ermöglicht flexible Event-Subscriptions.

### Szenen-basierte Organisation
Jedes Feature (Paddle, Ball, Brick) ist ein in sich geschlossener Szenen-Ordner mit:
- `.tscn`-Datei (Szenendefinition)
- Primäre `.gd`-Datei (Controller/Logik)
- Optional unterstützende Skripte (Basisklassen, Utilities)
- Kollisionsformen und visuelle Nodes

## Performance-Überlegungen

- **Physik-Framerate**: Godots Standard-Physics-Tick (typischerweise 60 Hz)
- **Ball-Geschwindigkeits-Begrenzung**: Aktuell auskommentiert; kann reaktiviert werden, falls Ball zu schnell wird
- **Brick-Count-Tracking**: Effizient durch Zählen von queue_free()-Aufrufen oder Wartung eines Counters

## Zukünftige Erweiterbarkeit

Die Architektur unterstützt einfaches Hinzufügen von:
- **Power-ups**: Können bei Brick-Zerstörung gespawnt und via Area2D erkannt werden
- **Multiple Balls**: Ball-System kann mehrfach instanziiert werden
- **Level-Progression**: BrickMap kann mit verschiedenen Tile-Layouts ausgetauscht werden
- **Score-System**: Game Manager hat bereits Infrastruktur für Score-Management
- **Soundeffekte**: Canvas Layer kann Signale emittieren, die Audio-Wiedergabe auslösen
