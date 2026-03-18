# Branch-Strategie

## Übersicht

Dieses Projekt verwendet eine vereinfachte Git-Flow-Strategie mit zwei Haupt-Branches:

### Branches

#### `develop` (Standard-Branch)
- **Zweck**: Laufende Entwicklung
- **Verwendung**: Alle neuen Features, Bugfixes und Verbesserungen werden hier entwickelt
- **Commits**: Direkte Commits oder Feature-Branches, die in develop gemergt werden
- **Status**: Kann instabil sein, wird kontinuierlich aktualisiert

#### `main` (Release-Branch)  
- **Zweck**: Produktionsreife Releases
- **Verwendung**: Nur für stabile, getestete Versionen
- **Merges**: Nur von develop nach main, wenn ein Release erstellt wird
- **Tags**: Releases werden mit Version-Tags markiert (z.B. `v0.1.0`, `v1.0.0`)

#### Feature-Branches (optional)
- **Naming**: `feature/feature-name` oder `branch_feature_name`
- **Basis**: Abzweigung von `develop`
- **Merge**: Zurück in `develop` nach Fertigstellung
- **Lifecycle**: Kurzlebig, werden nach Merge gelöscht

## Workflow

### Standard-Entwicklung

```bash
# Auf develop arbeiten
git checkout develop
git pull origin develop

# Änderungen machen
# ... Code editieren ...

# Committen und pushen
git add .
git commit -m "Add: Feature description"
git push origin develop
```

### Release erstellen

```bash
# Develop in main mergen
git checkout main
git pull origin main
git merge develop

# Version taggen
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main --tags

# Zurück zu develop
git checkout develop
```

### Feature-Branch (optional für größere Features)

```bash
# Feature-Branch erstellen
git checkout develop
git checkout -b feature/new-powerup

# Entwickeln und committen
git add .
git commit -m "Add: Powerup system"

# In develop mergen
git checkout develop
git merge feature/new-powerup

# Feature-Branch löschen
git branch -d feature/new-powerup
```

## Commit-Konventionen

Siehe [STYLE_GUIDE.md](./docs/STYLE_GUIDE.md) für Details zu Commit-Nachrichten.

**Format**: `<Type>: <Kurzbeschreibung>`

**Types**:
- `Add:` - Neue Dateien/Features
- `Fix:` - Bugfixes
- `Upd:` - Updates/Änderungen
- `Del:` - Löschungen
- `Docs:` - Dokumentationsänderungen
- `Refactor:` - Code-Umstrukturierung
- `Mve:` - Dateiverschiebungen

## Aktuelle Branches

- `develop` ✅ Standard für Entwicklung
- `main` - Nur für Releases
- `branch_refactor_structure` - Legacy, wird nicht mehr verwendet
- `branch_startgame_pause_ui` - Legacy, wird nicht mehr verwendet
