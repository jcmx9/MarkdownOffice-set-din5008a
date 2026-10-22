# Markdown Office – Set `din5008a`

**Version:** 26.10.3 · [Deutsch](README.md)

> Business letters after DIN 5008 Form A, written as a Markdown note.

## Description

`din5008a` sets a Markdown note as a letter after DIN 5008 Form A: return address, address zone (6 lines), information block (75 × 63 mm at 125/32 mm, aligned bottom right, with a vCard QR code), subject at 103.46 mm, fold and punch marks, footer with contact, bank details and "Page x of y", follow-up header from page 2, SVG signature and enclosures. The letter data lives in the note's front matter, the sender in a profile file; the letter text is normal Markdown (paragraphs, lists, tables, emphasis, alerts, tasks, math, Mermaid diagrams). Fonts: Source Serif 4, Source Sans 3 and Source Code Pro (variable) as bundled with Markdown Office, no system fonts. Everything works offline, including the QR code.

The layout comes from [typst-DIN5008a](https://github.com/jcmx9/typst-DIN5008a).

| File | Purpose |
|------|---------|
| `din5008a.typ` | Typst template (self-contained; reads front matter, profile and Markdown text) |
| `din5008a.header.md` | Front matter template with all common keys |
| `din5008a.css` | Editor preview: font, sizes, measure and spacing as in the PDF (no effect on the PDF) |
| `din5008a.preview.yaml` | Editor preview: letter head (return line, address, date, subject) and letter end (closing, signature, name, enclosures) from front matter and profile |
| `profiles/beispiel.yaml` | Example profile (fictional data) |
| `profiles/beispiel-unterschrift.svg` | Example signature |

The preview and Present mode of Markdown Office show a note with `template: din5008a` in the letter's typesetting: Source Serif 4 at 11 pt, ragged right, 165 mm measure, line and paragraph spacing as in the PDF; letter head and letter end appear when the YAML header is hidden. Page layout, information block, footer and fold marks exist only in the PDF.

## Installation

Markdown Office bundles the set; a note with `template: din5008a` uses it without further steps.

Own copy (e.g. to adapt the set): clone the repo into the templates folder; the folder must be named `din5008a`.

```bash
git clone https://github.com/jcmx9/MarkdownOffice-set-din5008a.git \
  "$HOME/Documents/Markdown Office/Vorlagen/din5008a"
```

A set in the templates folder takes precedence over the bundled one.

## Example

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

The text starts with the salutation. The template sets closing, signature, name and enclosures.

## Front matter keys

| Key | Meaning | Default |
|-----|---------|---------|
| `profile` | Sender profile: a name (`profiles/<name>.yaml`) or a path to a `.yaml` file; **required** | – |
| `date` | Date, `2026-10-18` or `18.10.2026`; shown long ("18. Oktober 2026"), other text unchanged | today |
| `lang` | `de` or `en` (labels, date, hyphenation) | `de` |
| `x-to` | Address as a list of lines, at most 6; **required** | – |
| `x-subject` | Subject (semibold); also the PDF title without `title:` | no subject |
| `x-closing` | Closing phrase; empty: no closing (then also no name, no signature, no enclosures) | no closing |
| `x-sign` | Insert the profile's signature | `true` |
| `x-attachments` | Enclosures as a list, e.g. `[Angebot, AGB]` | none |
| `x-debug` | Red outlines around all positioned fields, millimetre scale | `false` |
| `x-fold-marks` | Fold and punch marks | `true` |
| `x-profile-<field>` | Overrides a profile field for this letter, e.g. `x-profile-phone`; `x-profile-signature` is ignored | – |

The shared Markdown Office keys (`title`, `embed_source`, `hard_breaks`) apply as well. `title` becomes the PDF title; without `title` it is the subject.

If `profile:` is missing, the profile is not found, `x-to` is missing or has more than 6 lines, the export stops with a message and writes no PDF: a wrongly addressed letter is worse than none.

The file [`din5008a.schema.yaml`](din5008a.schema.yaml) describes the set's keys (types, allowed values, limits). Markdown Office uses it to check a note via „YAML prüfen …“ (Edit menu) and `markdown-office validate`; extra keys remain allowed.

## Profile

A profile is a YAML file with the sender data. Further files (signature) sit directly next to it.

| Field | Meaning |
|-------|---------|
| `name` | Name (information block, return address, footer, below the signature) |
| `street` | Street and number |
| `zip` | Postcode, quoted, e.g. `"01067"`; printed as "postcode city" on one line |
| `city` | City; without `zip` as before "postcode city" in one field (the vCard QR code then splits off a leading 4 to 5 digit postcode itself) |
| `country` | Country for the vCard QR code (not printed); empty: `Germany` |
| `phone` | Phone |
| `email` | Email |
| `iban` | IBAN (footer) |
| `bic` | BIC (footer) |
| `bank` | Bank (footer) |
| `qr` | `true`: vCard QR code in the information block |
| `signature` | File name of the SVG signature directly next to the profile (letters, digits, `.`, `_`, `-`, spaces; extension `.svg`; no folders, no `..`) |
| `signature-width` | Width of the signature in mm, e.g. `40mm` (anything else: 40 mm) |
| `accent` | Accent colour for marks, lines, sender and QR code, quoted as `"#RRGGBB"`, e.g. `"#B03060"`; empty or invalid: `#B03060` |

The text fields (`name`, `street`, `zip`, `city`, `country`, `phone`, `email`, `iban`, `bic`, `bank`) are set as text; a list or map there stops the export with a message. **Put phone numbers in quotes** (`phone: "+49 89 123456"`): YAML reads an unquoted `+4989123456` as a number and the plus is lost. **Quote `zip` as well** (`zip: "01067"`): unquoted, YAML reads `01067` as the number 1067; for German addresses (`country` empty, `Germany` or `Deutschland`) the template pads it back to five digits, for other countries it does not. Likewise always quote `accent`: unquoted, `#B03060` is a YAML comment and the default colour applies. `qr` accepts `true`/`yes`/`on`.

A profile name (`a-z`, `0-9`, `_`, `-`) is looked up in this order; the first existing file wins:

1. `profiles/<name>.yaml` in the note's folder
2. `din5008a/profiles/<name>.yaml` in the templates folder (`~/Documents/Markdown Office/Vorlagen/`; "Profil anlegen …" stores profiles there)
3. `profiles/<name>.yaml` in the templates folder (shared by all sets)
4. `profiles/<name>.yaml` in the set folder (example profiles such as `beispiel`)

### Signature

The signature is an SVG file directly next to the profile; any other value for `signature` stops the export, and a letter cannot swap it via `x-profile-signature`. `currentColor` in the SVG becomes iron-gall ink (Salix, `#103c78`); SVGs with fixed colours keep them. The signature is scaled to `signature-width` and placed above the name.

## DIN 5008 Form A layout

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

## License

MIT – see [LICENSE](LICENSE).
