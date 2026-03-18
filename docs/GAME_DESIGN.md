# Break-Out Prototype - Game Design Dokument

## Kernkonzept

**Break-Out Prototype** ist ein klassisches Arcade-Spiel im Brick-Breaker-Stil. Der Spieler steuert ein Paddle, um einen Ball nach oben zu schlagen und dabei Steine zu zerstören, die in einem Raster angeordnet sind. Das Ziel ist es, alle Steine zu zerstören, ohne dass der Ball vom unteren Bildschirmrand fällt.

## Spielziele

### Primäre Gewinnbedingung
- **Alle Steine zerstören** im Level, ohne alle Leben zu verlieren
- Zum nächsten Level vorrücken (falls implementiert)

### Verlustbedingung
- Ball fällt vom unteren Bildschirmrand (Death Plane)
- Leben erreichen null (0 verbleibende Leben)

## Kern-Gameplay-Schleife

```
1. Ball erscheint über dem Paddle und fällt nach unten
2. Spieler bewegt Paddle links/rechts, um Ball im Spiel zu halten
3. Ball prallt vom Paddle, Wänden und Steinen ab
4. Steine werden bei Ballkollision zerstört
5. Wenn alle Steine zerstört → Level abgeschlossen
6. Wenn Ball vom unteren Rand fällt → Ein Leben verlieren
7. Wenn Leben verbleiben → Ball zurücksetzen und fortfahren
8. Wenn keine Leben → Game Over
```

## Spielmechaniken

### Ball-Physik
- **Bewegung**: Physik-basiert mit RigidBody2D
- **Geschwindigkeit**: Beeinflusst durch Paddle-Kollision und Wandabpraller
- **Abprallen**: Winkel variiert basierend auf Treffposition am Paddle
  - Treffer nahe der Mitte → Ball prallt direkt nach oben
  - Treffer nahe der Ränder → Ball wird mit bis zu ±60° Winkel abgelenkt
- **Geschwindigkeit**: Konstante Größenordnung (für Spielbarkeit)

### Paddle-Steuerung
- **Bewegung**: Nur horizontal (links/rechts)
- **Steuerungsmodi**:
  - **Maus**: Paddle folgt der Cursor-Position sanft
  - **Tastatur**: A/D oder Pfeiltasten mit Frame-basierter Beschleunigung
- **Kollision**: Erkennt Ballkontakt über Area2D-Überlappung
- **Abprall-Logik**: Gibt Ball mit neuer Geschwindigkeit basierend auf Treffposition zurück

### Stein-System
- **Layout**: Angeordnet in 2D-Raster über TileMapLayer
- **Zerstörung**: Bei erster Ballkollision zerstört
- **Punkte**: Vergeben Punkte an Spieler bei Zerstörung (Design-Detail: Betrag noch festzulegen)
- **Varianten** (zukünftig):
  - Normale Steine (1 Treffer)
  - Harte Steine (mehrere Treffer)
  - Power-Up-Steine (lassen Items bei Zerstörung fallen)

### Weltgrenzen
- **Linke/Rechte Wände**: Ball prallt ab; Paddle auf Spielbereich beschränkt
- **Obere Wand**: Ball prallt ab
- **Untere/Death Plane**: Ball wird zerstört; Spieler verliert ein Leben
- **Spielbereich**: 1920×1080 Viewport (konfigurierbar in Projekteinstellungen)

## Spielzustände

Das Spiel verwendet eine State Machine mit folgenden primären Zuständen:

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

**Wichtige Zustände**:
- `NOTDEFINED` – Initial/nicht initialisiert
- `STARTUP/INITIALIZING` – Spiel lädt Ressourcen
- `MAIN` / `GAMEMAINMENU` – Hauptmenü-Bildschirm
- `RUNNING` – Aktives Gameplay
- `PAUSED` / `GAMEPAUSEMENU` – Pause-Menü
- `WAITING` – Zwischen Ball-Respawns
- `ENDED` / `GAMEOVER` – Spiel/Level abgeschlossen

## Leben & Respawning

**Leben-System**:
- Spieler startet mit **3 Leben** (konfigurierbar)
- Ein Leben verloren pro Ball, der vom unteren Rand fällt
- Ball erscheint nach kurzer Verzögerung in der Bildschirmmitte über dem Paddle neu
- Game Over wenn Leben 0 erreichen

**Zukünftige Verbesserung**: Pause/Resume während des Ball-Respawn-Countdowns hinzufügen

## Punktesystem

**Vergebene Punkte** (Platzhalter):
- Normaler Stein zerstört: +10 Punkte
- Harter Stein zerstört: +50 Punkte (falls implementiert)
- Power-Up gesammelt: Variiert nach Power-Up-Typ (zukünftig)

**Punkteanzeige**:
- HUD zeigt aktuelle Punkte oben links oder oben mittig
- (Optional) Highscore-Tracking und Persistierung implementieren

## Level-Design

### Aktuelle Implementierung
- Einzelnes Level mit 8×8-Raster von Steinen (konfigurierbar über TileMap)
- Alle Steine sind normale (1-Treffer) Variante
- Statisches Layout (keine Muster-/prozedurale Generierung geplant)

### Level-Progression (Zukünftig)
- Mehrere hartcodierte Level mit steigendem Schwierigkeitsgrad:
  - Mehr Steine
  - Härtere Steintypen
  - Engerer Abstand
- Nächstes Level laden wenn alle Steine zerstört

### Level-Editor (Zukünftig)
- TileMap-basierter visueller Level-Editor in Godot
- Level-Layouts exportieren/importieren
- Eigene Level ohne Code-Änderungen erstellen

## Eingabesteuerung

| Aktion | Eingabe | Funktion |
|--------|---------|----------|
| Nach Links | A oder ← | Paddle nach links bewegen |
| Nach Rechts | D oder → | Paddle nach rechts bewegen |
| Shoot | Leertaste | Reserviert; aktuell nicht verwendet |
| Pause | TBD | Spiel pausieren/fortsetzen |
| Menü | TBD | Zurück zum Hauptmenü |
| Beenden | Alt+F4 oder ESC | Spiel schließen |

**Hinweis**: Paddle-Bewegung wird automatisch auf Spielbereich beschränkt.

## UI/UX-Elemente

### Hauptmenü
- Titel: "Break-Out Prototype"
- Buttons: Spielen, Einstellungen, Beenden
- (Optional) Highscore-Anzeige

### HUD (Während des Spiels)
- **Punkte**: Oben links, große Schrift
- **Leben**: Oben rechts, visuelle Indikatoren (3 Herzen oder Text)
- **Level**: Oben mittig, falls mehrere Level
- (Optional) Ball-/Stein-Anzahl, Combo-Multiplikator

### Pause-Menü
- Pause-Overlay mit semi-transparentem Hintergrund
- Optionen: Fortsetzen, Einstellungen, Zurück zum Menü
- Spiel bleibt im Hintergrund gerendert (unpausierter Zustand sichtbar)

### Game Over / Gewinn-Bildschirm
- Große "GAME OVER" oder "LEVEL ABGESCHLOSSEN" Nachricht
- Endpunktestand-Anzeige
- Buttons: Nochmal Spielen, Zurück zum Menü
- (Optional) Benötigte Zeit, zerstörte Steine, etc.

## Schwierigkeitsgrad & Balance

**Aktueller Schwierigkeitsgrad**: Mittel
- Paddle-Breite: ~100 Pixel (bei 1920×1080)
- Ball-Geschwindigkeit: Mittel (initialer Impuls ~1200)
- Stein-Dichte: 8×8-Raster (64 Steine)

**Tuning-Parameter**:
```gdscript
const PADDLE_SPEED = 650.0        # Pixel pro Sekunde
const BALL_INITIAL_IMPULSE = Vector2(0, -1200)
const MAX_BOUNCE_ANGLE = 60.0     # Grad
const BOUNCE_ANGLE_SCALE = 60.0   # Winkel pro Paddle-Breite
```

**Balance-Überlegungen**:
- Paddle zu klein → frustrierend, Ball im Spiel zu halten
- Paddle zu groß → Spiel zu einfach
- Ball zu schnell → unvorhersehbare Abpraller
- Ball zu langsam → langweiliges Gameplay
- Abprallwinkel zu extrem → schwierig, Richtung zu kontrollieren

**Testing**: Spieltests mit Zielgruppe; Paddle-Breite, Ball-Geschwindigkeit und Abprall-Mechaniken basierend auf Feedback anpassen.

## Zukünftige Features & Erweiterungen

### Phase 1 (Geplant)
- [ ] Pause/Resume-Funktionalität
- [ ] Leben- und Respawn-System
- [ ] Punktesystem mit Persistierung (Highscore)
- [ ] Soundeffekte (Paddle-Treffer, Stein-Zerstörung, Level abgeschlossen)
- [ ] Visuelles Feedback (Screen Shake, Partikeleffekte)

### Phase 2 (Backlog)
- [ ] Mehrere Level mit Progression
- [ ] Power-Ups (größeres Paddle, Multi-Ball, Slow-Mo, etc.)
- [ ] Harte/zerstörbare Steintypen
- [ ] Combo-System (aufeinanderfolgende Steine ohne Paddle-Verfehlen)
- [ ] Schwierigkeitseinstellungen (leicht/normal/schwer)
- [ ] Hauptmenü-Hintergrundmusik

### Phase 3 (Nice-to-Have)
- [ ] Bestenliste (lokal oder online)
- [ ] Achievements/Herausforderungen
- [ ] Paddle-Power-Ups (Paddle-Größe, Klebrigkeit, etc.)
- [ ] Prozedural generierte Stein-Layouts
- [ ] Endlos-Modus (unendliche Level mit steigendem Schwierigkeitsgrad)
- [ ] Mobile-Touch-Steuerung
- [ ] Web-Export (HTML5)

## Bekannte Einschränkungen & Workarounds

| Problem | Status | Hinweise |
|---------|--------|----------|
| Ball-Geschwindigkeit steigt unbegrenzt | Auskommentierter Code | Geschwindigkeitsbegrenzungs-Logik existiert, aber deaktiviert; aktivieren, falls Geschwindigkeit problematisch wird |
| Pause nicht vollständig implementiert | Teilweise | UI existiert; muss mit State Machine verbunden werden |
| Kein Sound-System | Nicht implementiert | Platzhalter AudioStreamPlayer-Nodes bereit |
| Nur ein Level | Hartcodiert | Zukünftig: Level aus Dateien laden |
| Keine Schwierigkeitsauswahl | Nicht implementiert | Alle Spiele starten mit festem Schwierigkeitsgrad |

## Kunst- & Audio-Stil

### Visueller Stil
- **Thema**: Klassische Arcade / Retro
- **Farbpalette**: Helle Primärfarben (Rot, Blau, Gelb)
- **UI-Schriftart**: Sauber, lesbare Sans-Serif
- **Animationen**: Minimal; Fokus auf responsive Physik

### Audio-Stil
- **Soundeffekte**: Retro-Arcade Bleeps/Bloops
- **Musik**: Schwungvoller Chiptune-Stil Hintergrund-Track
- **Lautstärke**: Stummschaltbar über Einstellungsmenü

**Aktuelle Assets**:
- Hintergrundbild: `assets/images/bg.jpg`
- Theme-Farben: `src/resources/themes/game_theme.tres`
- Schriftarten: `src/resources/fonts/` (bereit für .otf/.ttf-Dateien)

## Testing-Checkliste

- [ ] Ball prallt korrekt von Wänden ab
- [ ] Ball prallt korrekt vom Paddle ab (verschiedene Trefferpositionen)
- [ ] Ball prallt korrekt von Steinen ab
- [ ] Paddle auf Spielbereich beschränkt
- [ ] Stein bei Ballkollision zerstört
- [ ] Steine regenerieren für neues Level/Spiel
- [ ] Ball erscheint nach Fall vom unteren Rand neu
- [ ] Leben dekrementieren korrekt
- [ ] Game Over wird bei Leben = 0 ausgelöst
- [ ] Level abgeschlossen wird ausgelöst, wenn alle Steine zerstört
- [ ] Punktestand erhöht sich bei Stein-Zerstörung
- [ ] UI-Updates reflektieren Spielzustand
- [ ] Keine grafischen Glitches oder Überlappungen

## Design-Notizen

### Architektur-Entscheidungen
- **RigidBody2D für Ball**: Nutzt Godots Physik-Engine; einfacher als eigene Bewegung
- **CharacterBody2D für Paddle**: Erlaubt Tastatureingabe bei Beibehaltung der Kollision; einfacher als Area2D
- **Signals für Kommunikation**: Entkoppelt Komponenten; einfach Listener hinzuzufügen (z.B. Punkte-UI)
- **TileMap für Steine**: Effizientes Raster-basiertes Layout; leicht erweiterbar auf mehrere Level

### Warum dieser Ansatz?
- **Physik-basiert**: Fühlt sich responsiv und befriedigend an
- **Minimalistisch**: Klares Gameplay ohne übermäßige visuelle Effekte
- **Erweiterbar**: Einfach Power-Ups, Level und Features hinzuzufügen
- **Retro-Appeal**: Klassisches Gameplay mit modernen Werkzeugen

## Referenzen

- Classic Breakout (Atari, 1976) – Original-Inspiration
- Arkanoid (1986) – Spielmechanik-Referenz
- Godot Physics: https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html
