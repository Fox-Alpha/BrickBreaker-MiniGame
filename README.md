# Break-Out Prototype

Ein klassisches Breakout/Brick-Breaker Spiel, entwickelt mit Godot Engine 4.6.

## 🎮 Über das Spiel

Break-Out Prototype ist ein arcade-inspiriertes Geschicklichkeitsspiel, bei dem der Spieler ein Paddle steuert, um einen Ball abprallen zu lassen und alle Bricks auf dem Spielfeld zu zerstören. Das Projekt dient als Prototyp und Lernprojekt für Godot 4.6 und GDScript.

**Status**: 🚧 In aktiver Entwicklung (Prototype Phase)

## ✨ Features

- ✅ Paddle-Steuerung (Maus & Tastatur)
- ✅ Physik-basierte Ball-Bewegung
- ✅ Brick-Zerstörungssystem
- ✅ TileMap-basiertes Level-Layout
- ✅ Game State Management
- ⏳ Score-System (in Entwicklung)
- ⏳ Lives/Leben-System (in Entwicklung)
- ⏳ Power-ups (geplant)

## 🚀 Quick Start

### Voraussetzungen

- **Godot Engine 4.6** - [Download](https://godotengine.org)
- **Git** - Für Version Control

### Projekt öffnen

```bash
# Repository klonen
git clone <repository-url>
cd break-out-prototype

# Checkout develop branch (aktive Entwicklung)
git checkout develop
```

Dann:
1. Godot Engine 4.6 öffnen
2. "Projekt importieren" klicken
3. Zu `/path/to/break-out-prototype` navigieren
4. `project.godot` auswählen
5. "Importieren & Bearbeiten" klicken

### Spiel starten

**Im Editor**:
- `F5` drücken oder Play-Button (▶) klicken
- Spiel startet im 1920×1080 Fenster

**Steuerung**:
- `A` / `D` oder `←` / `→` - Paddle bewegen
- `Leertaste` - Ball schießen (falls implementiert)

## 📂 Projektstruktur

```
src/                    # Godot-Projektdateien (Szenen, Skripte, Ressourcen)
  scenes/              # Spielszenen nach Features organisiert
  resources/           # Godot-Ressourcen (Fonts, Themes)

assets/                # Spiel-Assets (Bilder, Audio)
docs/                  # Technische Dokumentation (Deutsch & Englisch)
.github/               # GitHub-Konfiguration
.vscode/               # VS Code LSP-Konfiguration

project.godot          # Godot-Projektkonfiguration
build_config.json      # Export-Builder-Konfiguration
export_presets.cfg     # Export-Profile (Linux, Windows)
BRANCHING.md           # Branch-Strategie & Git-Workflow
```

## 📖 Dokumentation

Die Projektdokumentation ist in **Deutsch** und **Englisch** verfügbar:

### Deutsch (Standard)
- [**ARCHITECTURE.md**](./docs/ARCHITECTURE.md) - Systemarchitektur und Datenfluss
- [**DEVELOPMENT.md**](./docs/DEVELOPMENT.md) - Entwicklungsanleitung
- [**GAME_DESIGN.md**](./docs/GAME_DESIGN.md) - Game-Design & Mechaniken
- [**STYLE_GUIDE.md**](./docs/STYLE_GUIDE.md) - Code-Konventionen & Stil

### English
- [**ARCHITECTURE_en.md**](./docs/ARCHITECTURE_en.md) - System design and data flow
- [**DEVELOPMENT_en.md**](./docs/DEVELOPMENT_en.md) - Development guide
- [**GAME_DESIGN_en.md**](./docs/GAME_DESIGN_en.md) - Game design & mechanics
- [**STYLE_GUIDE_en.md**](./docs/STYLE_GUIDE_en.md) - Coding conventions

## 🌿 Branch-Strategie

Dieses Projekt verwendet eine vereinfachte Git-Flow-Strategie:

- **`develop`** (Standard) - Aktive Entwicklung, alle neuen Features und Bugfixes
- **`main`** - Nur für stabile Releases mit Version-Tags

Siehe [BRANCHING.md](./BRANCHING.md) für Details zum Git-Workflow.

## 🛠️ Entwicklung

### VS Code mit Godot LSP

Das Projekt ist mit VS Code und der `godot-tools` Extension konfiguriert:

1. VS Code installieren
2. Extension `geequlim.godot-tools` installieren
3. Godot Editor öffnen (startet LSP-Server)
4. VS Code im Projektordner öffnen
5. Autocomplete, Go-to-Definition und Diagnostics funktionieren automatisch

Konfiguration siehe: [.vscode/settings.json](./.vscode/settings.json)

### Entwicklungs-Workflow

```bash
# Auf develop-Branch arbeiten
git checkout develop
git pull origin develop

# Änderungen machen, testen (F5 in Godot)
# ...

# Committen (siehe Commit-Konventionen)
git add .
git commit -m "Add: Feature description"
git push origin develop
```

### Commit-Konventionen

Format: `<Type>: <Kurzbeschreibung>`

**Types**:
- `Add:` - Neue Features/Dateien
- `Fix:` - Bugfixes
- `Upd:` - Updates/Änderungen
- `Docs:` - Dokumentation
- `Refactor:` - Code-Umstrukturierung

Siehe [STYLE_GUIDE.md](./docs/STYLE_GUIDE.md) für Details.

## 🏗️ Export & Build

Exportprofile für Linux und Windows sind vorkonfiguriert:

1. In Godot: **Projekt → Export**
2. Profil auswählen (Linux Desktop / Windows Desktop)
3. "Export Project" klicken
4. Zielordner auswählen

Builds werden in `.exports/` gespeichert (nicht versioniert).

## 🤝 Beitragen

Dieses Projekt ist ein persönlicher Prototyp. Feedback und Vorschläge sind willkommen!

## 📝 Lizenz

*Lizenz noch nicht festgelegt*

## 🔗 Links

- [Godot Engine](https://godotengine.org)
- [Godot Documentation](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)

---

**Entwickelt mit ❤️ und Godot Engine 4.6**
