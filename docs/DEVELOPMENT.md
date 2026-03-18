# Break-Out Prototype - Entwicklungshandbuch

> 📘 **English version**: [DEVELOPMENT_en.md](./DEVELOPMENT_en.md)

## Schnellstart

### Voraussetzungen
- **Godot Engine 4.6** - Download von [godotengine.org](https://godotengine.org)
- **Git** - Für Versionskontrolle
- Ein Texteditor oder IDE (empfohlen: VS Code mit GDScript-Erweiterung oder Godots integrierter Editor)

### Projekt öffnen

1. Godot Engine 4.6 öffnen
2. Auf "Projekt importieren" klicken
3. Zu `/home/buckdi/Projekte/godot/projekte/break-out-prototype` navigieren
4. Auf "Importieren & bearbeiten" klicken
5. Godot importiert das Projekt (beim ersten Mal dauert es ~30 Sekunden)

### Das Spiel ausführen

**Im Editor**:
- `F5` drücken oder auf die Wiedergabe-Schaltfläche (▶) in der oberen Symbolleiste klicken
- Das Spiel startet mit 1920×1080 im Fenstermodus
- Steuerung: A/D oder Pfeiltasten zum Bewegen des Paddels, Leertaste zum Schießen (falls implementiert)

**Eigenständige Ausführungsdatei**:
- Siehe Abschnitt [Exportieren](#exportieren) unten

## Projektstruktur

```
src/                    # Quellcode des Spiels
  scenes/              # Spielszenen organisiert nach Features
    core/              # Kernsysteme (Game Manager, States)
    paddle/            # Paddle-Controller-Szene
    ball/              # Ball-Physik-Szene
    brick/             # Ziegel (zerstörbare Objekte)
    brickmap/          # TileMap für Ziegel-Layout
    world_border/      # Kollisionsgrenzen
    main_menu/         # Menü-UI
    game/              # Haupt-Gameplay-Szene
    ui/                # Spiel-HUD und UI
  resources/           # Godot-Ressourcen
    fonts/             # Schriftdateien (.otf, .ttf)
    themes/            # UI-Theme-Ressourcen

assets/                # Nicht-Code Spiel-Assets
  images/              # Texturen, Sprites, Hintergründe
  audio/               # Soundeffekte und Musik (für zukünftige Verwendung vorbereitet)

docs/                  # Technische Dokumentation
  ARCHITECTURE.md      # Systemdesign und Datenfluss
  DEVELOPMENT.md       # Diese Datei
  STYLE_GUIDE.md       # Code-Konventionen
  GAME_DESIGN.md       # Spielmechaniken und Design

project.godot          # Godot-Projektkonfiguration
build_config.json      # Export-Builder-Konfiguration
export_presets.cfg     # Export-Profile (Linux, Windows)
```

## Entwicklungsworkflow

### Neue Szene erstellen

1. Rechtsklick im FileSystem-Panel → Neue Ressource → PackedScene
2. Root-Node-Typ wählen (z.B. Node2D, CharacterBody2D, Control)
3. Kind-Nodes und Skripte hinzufügen
4. Mit beschreibendem Namen speichern (z.B. `paddle.tscn`)
5. Im entsprechenden Ordner unter `src/scenes/` ablegen

### Skript hinzufügen

1. Rechtsklick auf Node → Skript anhängen
2. Pfad sollte dem Muster folgen: `res://src/scenes/[component]/[script_name].gd`
3. Godot-Namenskonventionen befolgen (snake_case für Dateien)
4. class_name hinzufügen, wenn es sich um eine wiederverwendbare Komponente handelt: `class_name PaddleController extends CharacterBody2D`

### Änderungen testen

Nach dem Modifizieren von Code:
1. **Datei speichern** (Strg+S)
2. **Zurück zum Godot-Fenster wechseln** (Alt+Tab)
3. Godot lädt das Skript automatisch neu
4. **F5 drücken**, um das Spiel neu zu starten und zu testen

### Debugging

**In-Editor-Debugging**:
- Haltepunkte setzen durch Klicken auf Zeilennummern
- F6 drücken zum Debuggen (läuft mit angehängtem Debugger)
- Code durchgehen mit F10 (Einzelschritt) oder F11 (Hineinspringen)

**Konsolenausgabe**:
- Output-Panel am unteren Rand des Editors anzeigen
- `print()`-Anweisungen zum Loggen von Debug-Informationen verwenden
- Beispiel: `print("Ball position: ", ball.position)`

**Scene-Tree-Inspektion**:
- Während das Spiel läuft, auf den Remote-Tab klicken (neben Scene)
- Live-Node-Eigenschaften inspizieren und Werte ändern
- Nützlich zum Debuggen von Node-Positionen, Geschwindigkeiten, Signal-Verbindungen

**Physik-Visualisierung**:
- Wiedergabe-Menü → Physik-Debug umschalten → Sichtbare Kollisionsformen
- Zeigt alle Kollisionskörper, Areas und Formen in Grün/Rot an
- Rot = Kontaktpunkt; Grün = Formumriss

### Änderungen committen

Immer klare Commit-Nachrichten verwenden:

```bash
cd /home/buckdi/Projekte/godot/projekte/break-out-prototype
git add .
git commit -m "Add: Feature-Beschreibung oder Fix: Bug-Beschreibung

Detaillierte Erklärung der Änderung, Auswirkung und relevanter Kontext.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

**Branch-Verwendung**:
- `main` oder `master` – Stabile Release-Versionen
- `develop` – Integrations-Branch für Features
- `branch_*` – Feature-Branches (z.B. `branch_refactor_structure`)

### Code-Review-Checkliste

Vor dem Pushen von Commits überprüfen:
- [ ] Code folgt dem Godot-Style-Guide (siehe STYLE_GUIDE.md)
- [ ] Keine hartcodierten Pfade (verwende `res://` relative Pfade oder UIDs)
- [ ] Signale ordnungsgemäß im Skript-Header dokumentiert
- [ ] Exports haben hilfreiche Beschreibungen und Bereiche
- [ ] Keine Konsolen-Fehler oder Warnungen beim Ausführen
- [ ] Spiel kann ohne Fehler gebaut/exportiert werden

## Bauen & Exportieren

### Export-Profile

Das Projekt hat zwei integrierte Export-Profile:

**Linux** (x86_64):
- **Pfad**: `.exports/` (automatisch)
- **Features**: S3TC/BPTC-Texturkompression, Embedded PCK, Konsolenausgabe

**Windows Desktop** (x86_64):
- **Pfad**: `.exports/` (automatisch)
- **Features**: S3TC/BPTC-Texturkompression, Embedded PCK, Direct3D 12-Rendering

### Als eigenständige Ausführungsdatei exportieren

**Über den Godot-Editor**:
1. Projekt → Exportieren (Strg+Alt+E)
2. Gewünschtes Export-Profil auswählen (Linux oder Windows Desktop)
3. Auf Exportieren klicken
4. Ausgabeverzeichnis und Dateinamen wählen
5. Auf Build warten (30-60 Sekunden)

**Über die Kommandozeile**:
```bash
/usr/local/bin/godot --export-debug "Linux" ".exports/break-out-prototype_linux.x86_64"
/usr/local/bin/godot --export-debug "Windows Desktop" ".exports/break-out-prototype_windows.exe"
```

**Build-Config verwenden**:
Externe Build-Skripte können `build_config.json` nutzen, um Exports zu automatisieren:
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

### Nach dem Exportieren

Das exportierte Spiel überprüfen:
1. Zum `.exports/`-Verzeichnis navigieren
2. Die Ausführungsdatei starten
3. Grundlegendes Gameplay testen: Paddle bewegen, Ball-Physik, Ziegel-Kollision
4. Nach Fehlermeldungen suchen

## Problembehandlung

### Spiel startet nicht im Editor
- **Fehler**: "Scene not found"
- **Lösung**: Prüfen, ob `project.godot` auf die korrekte Hauptszene via UID zeigt
- **Fix**: Projekt → Projekteinstellungen → Anwendung → Ausführen → Hauptszene

### Skripte zeigen rote Wellenlinien
- **Fehler**: "Cannot find symbol" oder "Undefined class"
- **Lösung**: Godot hat die Skripte möglicherweise noch nicht indiziert
- **Fix**: 5 Sekunden warten oder Rechtsklick auf Skript → Skript erzwingen (Strg+Shift+K)

### Ball/Paddle-Positionen falsch nach Verschieben von Dateien
- **Fehler**: Komponenten spawnen außerhalb des Bildschirms
- **Lösung**: Szenen-Referenzen könnten beschädigt sein
- **Fix**: Die .tscn-Datei in einem Texteditor öffnen, überprüfen, ob Node-Referenzen korrekte UIDs sind

### Export schlägt fehl
- **Fehler**: "Export template not found"
- **Lösung**: Export-Templates müssen heruntergeladen werden
- **Fix**: Editor → Exportieren → Android/Linux/Windows-Templates installieren (je nach Zielplattform)

### Spiel stürzt beim Start ab
- **Fehler**: "Autoload scene not found"
- **Lösung**: Game-Manager-Pfad hat sich geändert
- **Fix**: Projekteinstellungen → Autoload → Prüfen, ob `Game` auf `res://src/scenes/core/game_manager.gd` zeigt

## Performance-Profiling

### Integrierter Profiler
- Debug → Monitor (oder F4)
- FPS, Speicherverbrauch, Physik-Zeit beobachten
- Wenn FPS unter 60 fällt, prüfen:
  - Anzahl aktiver Physik-Objekte
  - Anzahl der Draw-Calls (sichtbar im Profiler)
  - Script _process() oder _physics_process() Zeit

### Optimierungstipps
- Gruppen verwenden (`add_to_group()`) für Batch-Operationen statt Node-Suche
- @onready-Referenzen cachen, um wiederholte `get_node()`-Aufrufe zu vermeiden
- Physik für unsichtbare Objekte deaktivieren, wenn möglich
- `call_deferred()` für Operationen verwenden, die keine sofortige Ausführung benötigen

## Ressourcen & Weiterführendes

- **Godot-Dokumentation**: https://docs.godotengine.org/en/stable/
- **GDScript-Style-Guide**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- **Physik in Godot**: https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html
- **Signals-Tutorial**: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

## Häufige Aufgaben

### Neues Power-Up hinzufügen
1. Szene erstellen `src/scenes/powerups/[powerup_name].tscn`
2. Area2D für Pickup-Kollision verwenden
3. Auf Ziegel-Zerstörungssignal hören, um Power-Up zu spawnen
4. `overlaps_area()` mit Paddle prüfen für Einsammeln

### Score-Anzeige implementieren
1. Eigenschaft zum Game Manager hinzufügen: `var score = 0`
2. Signal bei Score-Änderung aussenden: `score_changed.emit(score)`
3. UI mit Signal verbinden: `Game.score_changed.connect(on_score_changed)`
4. Label im UI-Handler aktualisieren: `score_label.text = "Score: %d" % score`

### Soundeffekte hinzufügen
1. .ogg- oder .mp3-Dateien in `assets/audio/` ablegen
2. AudioStreamPlayer-Node in Szene erstellen
3. Audio referenzieren: `@onready var sfx = $AudioStreamPlayer`
4. Bei Event abspielen: `sfx.play()`

### Neues Level erstellen
1. Neue TileMapLayer-Szene erstellen: `src/scenes/brickmap/level_2.tscn`
2. Unterschiedliches Tile-Layout mit TileSet malen
3. Spiellogik aktualisieren, um das entsprechende Level zu laden

## Entwicklungstipps

- **Git-Branches verwenden** für experimentelle Features: `git checkout -b branch_feature_name`
- **Szenen klein halten** – Große Szenen sind langsam zu laden und zu bearbeiten
- **Zirkuläre Abhängigkeiten vermeiden** – Szene A referenziert Szene B referenziert Szene A
- **Komplexe Logik kommentieren** – Das zukünftige Ich wird dem aktuellen Ich danken
- **Edge Cases testen** – Ball trifft Ecke, Paddle am Bildschirmrand, etc.
