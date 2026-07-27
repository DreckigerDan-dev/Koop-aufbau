# Koop-aufbau

Koop-Kolonie-Survival-Prototyp (Godot 4.x, GDScript).

Kolonieaufbau-Survival mit Online-Koop-Layer, inspiriert von *Infection Free Zone*
(Basisaufbau/Optik) und *They Are Billions* (Horden-Bedrohung). Aktuell im
Singleplayer-Prototyp-Stadium — Multiplayer-Layer kommt erst, wenn die
Kern-Loop-Architektur steht.

## Projektstruktur

- `scenes/` – Godot-Szenen (`main/`, `map/`, `units/`, `ui/`)
- `scripts/` – GDScript-Dateien (`units/`, `systems/`, `ui/`)
- `resources/` – Godot-Resource-Dateien (z. B. Ressourcentypen, Konfiguration)

## Status

- Etappe 0 abgeschlossen: Projekt-Grundgerüst.
- Etappe 1 abgeschlossen: erster spielbarer Meilenstein.
  - Platzhalter-Karte mit zwei Gebäuden und zwei Ressourcen (Bäume)
  - Klick auf Gebäude → wird zur Basis (visuelle Markierung)
  - Klick auf Ressource → Arbeiter läuft per Pathfinding (NavigationAgent2D)
    dorthin, sammelt und der Holz-Zähler oben links zählt hoch

- Etappe 2 abgeschlossen: mehrere Arbeiter, manuelle Zuweisung, zweiter
  Ressourcentyp.
  - Zwei Arbeiter (blaue Dreiecke) statt einem
  - Arbeiter anklicken → wird hellblau markiert (ausgewählt)
  - Danach eine Ressource anklicken → nur der ausgewählte Arbeiter läuft hin
  - Zweiter Ressourcentyp "Stahl" (graue Kreise, Platzhalter für Autos)
  - Zentrale `Colony`-Zustandsklasse (`scripts/systems/colony.gd`) verwaltet
    die Ressourcenzähler statt verstreuter Einzel-Variablen

### Zum Testen

1. Projekt in Godot 4.3+ öffnen (Import → dieses Verzeichnis)
2. F5 / Play drücken (Hauptszene ist bereits gesetzt)
3. Auf ein Gebäude klicken → wird gold markiert (= Basis)
4. Auf einen Arbeiter klicken → wird hellblau markiert (= ausgewählt)
5. Auf einen Baum (grün) oder ein Auto (grau) klicken → der ausgewählte
   Arbeiter läuft per Pathfinding hin, sammelt kurz, Zähler zählt hoch,
   Ressource verschwindet
6. Zweiten Arbeiter anklicken und Schritt 5 wiederholen → beide Arbeiter
   können unabhängig zugewiesen werden

Nächster Schritt: Etappe 3 — Truppen und einfaches Plündern.
