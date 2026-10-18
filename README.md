# Markdown Office – Set `din5008a`

**Version:** 26.10.0 · [English](README.en.md)

> Geschäftsbriefe nach DIN 5008 Form A, geschrieben als Markdown-Notiz.

## Beschreibung

`din5008a` setzt eine Markdown-Notiz als Brief nach DIN 5008 Form A: Rücksendeangabe, Anschriftzone (6 Zeilen), Informationsblock (75 × 63 mm bei 125/32 mm, unten rechts bündig, mit vCard-QR-Code), Betreff bei 103,46 mm, Falz- und Lochmarken, Fußzeile mit Kontakt, Bankverbindung und „Seite x von y“, Folgeseitenkopf ab Seite 2, SVG-Unterschrift und Anlagen. Die Briefdaten stehen im Frontmatter der Notiz, der Absender in einer Profildatei; der Brieftext ist normales Markdown (Absätze, Listen, Tabellen, Hervorhebungen, Hinweisboxen, Aufgaben, Formeln, Mermaid-Diagramme). Schriften: die mit Markdown Office gelieferten Source Serif 4, Source Sans 3 und Source Code Pro (variabel), keine Systemschriften. Alles läuft offline, auch der QR-Code.

Das Layout stammt aus [typst-DIN5008a](https://github.com/jcmx9/typst-DIN5008a).

| Datei | Zweck |
|-------|-------|
| `din5008a.typ` | Typst-Vorlage (eigenständig; liest Frontmatter, Profil und Markdown-Text) |
| `din5008a.header.md` | Frontmatter-Vorlage mit allen üblichen Schlüsseln |
| `profiles/beispiel.yaml` | Beispielprofil (fiktive Daten) |
| `profiles/beispiel-unterschrift.svg` | Beispielunterschrift |

## Installation

Markdown Office bringt das Set mit; eine Notiz mit `template: din5008a` verwendet es ohne weitere Schritte.

Eigene Kopie (z. B. um das Set anzupassen): das Repo in den Vorlagenordner klonen, der Ordnername muss `din5008a` lauten.

```bash
git clone https://github.com/jcmx9/MarkdownOffice-set-din5008a.git \
  "$HOME/Documents/Markdown Office/Vorlagen/din5008a"
```

Ein Set im Vorlagenordner hat Vorrang vor dem mitgelieferten.

## Beispiel

```markdown
---
template: din5008a
profile: beispiel
date: 2026-10-18
lang: de
x-to:
  - Sonnenschein Verlag GmbH
  - Frau Lisa Bergmann
  - Rosenstraße 5
  - 50667 Köln
x-subject: Ihre Anfrage vom 12. Oktober
x-closing: Mit freundlichen Grüßen
x-sign: true
x-attachments: [Angebot, AGB]
embed_source: true
---

Sehr geehrte Frau Bergmann,

vielen Dank für Ihre Anfrage. Gerne unterbreiten wir Ihnen das gewünschte Angebot.

- Konzeption und Layout
- Satz und Korrektur

| Leistung | Umfang    | Preis   |
|----------|-----------|---------|
| Layout   | 12 Seiten | 1.200 € |
| Satz     | 80 Seiten | 2.400 € |

Für Rückfragen stehe ich Ihnen gerne zur Verfügung.
```

Der Text beginnt mit der Anrede. Gruß, Unterschrift, Name und Anlagen setzt die Vorlage.

## Frontmatter-Schlüssel

| Schlüssel | Bedeutung | Standard |
|-----------|-----------|----------|
| `profile` | Absenderprofil: Name (`profiles/<name>.yaml`) oder Pfad zu einer `.yaml`-Datei; **Pflicht** | – |
| `date` | Datum, `2026-10-18` oder `18.10.2026`; erscheint lang („18. Oktober 2026“), anderer Text unverändert | heute |
| `lang` | `de` oder `en` (Beschriftungen, Datum, Silbentrennung) | `de` |
| `x-to` | Anschrift als Liste von Zeilen, höchstens 6; **Pflicht** | – |
| `x-subject` | Betreff (halbfett); ohne `title:` auch PDF-Titel | kein Betreff |
| `x-closing` | Grußformel; leer: kein Gruß (dann auch kein Name, keine Unterschrift, keine Anlagen) | kein Gruß |
| `x-sign` | Unterschrift aus dem Profil einsetzen | `true` |
| `x-attachments` | Anlagen als Liste, z. B. `[Angebot, AGB]` | keine |
| `x-debug` | Rote Rahmen um alle positionierten Felder, Millimeterskala | `false` |
| `x-fold-marks` | Falz- und Lochmarken | `true` |
| `x-profile-<feld>` | Überschreibt ein Profilfeld für diesen Brief, z. B. `x-profile-phone`; `x-profile-signature` wird ignoriert | – |

Außerdem gelten die gemeinsamen Schlüssel von Markdown Office (`title`, `embed_source`, `hard_breaks`). `title` wird PDF-Titel; ohne `title` ist es der Betreff.

Fehlt `profile:`, wird das Profil nicht gefunden, fehlt `x-to` oder hat es mehr als 6 Zeilen, bricht der Export mit einer Meldung ab und schreibt kein PDF: ein falsch adressierter Brief ist schlimmer als keiner.

## Profil

Ein Profil ist eine YAML-Datei mit den Absenderdaten. Weitere Dateien (Unterschrift) liegen direkt daneben.

| Feld | Bedeutung |
|------|-----------|
| `name` | Name (Informationsblock, Rücksendeangabe, Fußzeile, unter der Unterschrift) |
| `street` | Straße und Hausnummer |
| `city` | PLZ und Ort |
| `phone` | Telefon |
| `email` | E-Mail |
| `iban` | IBAN (Fußzeile) |
| `bic` | BIC (Fußzeile) |
| `bank` | Bank (Fußzeile) |
| `qr` | `true`: vCard-QR-Code im Informationsblock |
| `signature` | Dateiname der SVG-Unterschrift direkt neben dem Profil (Buchstaben, Ziffern, `.`, `_`, `-`, Leerzeichen; Endung `.svg`; keine Ordner, kein `..`) |
| `signature-width` | Breite der Unterschrift in mm, z. B. `40mm` (andere Angaben: 40 mm) |
| `accent` | Akzentfarbe für Marken, Linien, Absender und QR-Code, in Anführungszeichen als `"#RRGGBB"`, z. B. `"#B03060"`; leer oder ungültig: `#B03060` |

Die Textfelder (`name` bis `bank`) werden als Text gesetzt; eine Liste oder Zuordnung dort bricht den Export mit einer Meldung ab. **Telefonnummern in Anführungszeichen setzen** (`phone: "+49 89 123456"`): YAML liest `+4989123456` ohne Anführungszeichen als Zahl, das Plus fällt dann weg. Ebenso `accent` immer in Anführungszeichen: ohne sie ist `#B03060` in YAML ein Kommentar, und die Standardfarbe gilt. `qr` versteht `true`/`yes`/`on`.

Ein Profilname (`a-z`, `0-9`, `_`, `-`) wird in dieser Reihenfolge gesucht, die erste vorhandene Datei gilt:

1. `profiles/<name>.yaml` im Ordner der Notiz
2. `profiles/<name>.yaml` im Vorlagenordner (`~/Documents/Markdown Office/Vorlagen/`)
3. `profiles/<name>.yaml` im Set-Ordner (Beispielprofile wie `beispiel`)

### Unterschrift

Die Unterschrift ist eine SVG-Datei direkt neben dem Profil; jeder andere Wert für `signature` bricht den Export ab, und ein Brief kann sie nicht über `x-profile-signature` austauschen. `currentColor` im SVG wird zu Eisengallustinte (Salix, `#103c78`); SVGs mit festen Farben behalten diese. Die Unterschrift wird auf `signature-width` skaliert und über den Namen gesetzt.

## Layout nach DIN 5008 Form A

```
 +----------------------------------------------+
 |  Briefkopffeld (frei gestaltbar)             | 27mm
 +--------------------+-------------------------+
 |  Rücksendeangabe   |                         |
 |  Zusatz/Vermerke   |  Informationsblock      | 32mm
 |  - - - - - - - -   |  (bottom-right aligned) |
 |  Anschriftzone     |  Name, Adresse, Tel,    |
 |  (6 Zeilen)        |  E-Mail, QR, Linie,     |
 |  85mm              |  Datum                  | 95mm
 +--------------------+  75mm x 63mm            |
 |                    +-------------------------+
 |                                              |
 |  Betreff (semibold)                          | 103.46mm
 |  Anrede + Textkörper                         |
 |  (Source Serif 4, 11pt, 150% Zeilenabstand)  |
 |                                              |
-+ Faltmarke 1                                  | 87mm
 |                                              |
-+ Lochmarke                                    | 148.5mm
 |                                              |
-+ Faltmarke 2                                  | 192mm
 |                                              |
 |----------------------------------------------| 275.3mm
 |  Footer (Source Sans 3, 9pt, zentriert)      |
 |  Kontakt . Bank . Seite x von y              | 290mm
 +----------------------------------------------+
  |<- 25mm ->|                          |<- 20mm ->|
```

## Lizenz

MIT – siehe [LICENSE](LICENSE).
