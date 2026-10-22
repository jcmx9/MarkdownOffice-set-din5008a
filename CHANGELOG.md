# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [26.10.3] - 2026-10-22

### Added
- `din5008a.css`: the editor preview takes the letter's typesetting from the PDF (Source Serif 4 11pt, ragged right, 165 mm measure, 12.87pt lines, paragraph and heading gaps, 10pt mono tables and code), needs Markdown Office with set previews (TEMPLATES.md section 8)
- `din5008a.preview.yaml`: preview head (return line, address, date, subject) and foot (closing, signature over the blank lines, signer, enclosures) from the front matter and the profile

## [26.10.2] - 2026-10-21

### Added
- `din5008a.schema.yaml`: key types and allowed values for Markdown Office's YAML check („YAML prüfen …“, `markdown-office validate`)

### Fixed
- `lang:` with a region (`de-AT`) no longer stops the export with "expected two or three letter language code": the region is split off and passed to `text(region:)`; `de-AT` gets the German labels and date

## [26.10.1] - 2026-10-19

### Added
- Profile keys `zip` (postcode) and `country` (vCard only, default `Germany`); the printed sender line stays "<zip> <city>" on one line
- An unquoted German `zip` that YAML read as an integer (`01067` -> 1067) is padded back to 5 digits

### Changed
- vCard QR code: `ADR` carries locality, postal code and country in their own components (`ADR:;;<street>;<city>;;<zip>;<country>`); without `zip` a leading 4-5 digit postcode is split off `city`, so existing profiles print the same text and get a proper vCard
- vCard values escape `\`, `,` and `;`
- Example profile `beispiel` uses `zip` + `city`; README lists the per-set profile folder `Vorlagen/din5008a/profiles/`

## [26.10.0] - 2026-10-18

### Added
- Initial release: DIN 5008 Form A letters for Markdown Office, layout ported from typst-DIN5008a
- Mermaid diagrams in the letter body (offline via the bundled mmdr)
- Profile values are normalised: text fields as text, `accent` validated (`#RRGGBB`, else the default), `qr` as a flag

### Security
- `signature` must be a plain `.svg` file name next to the profile; `x-profile-signature` is ignored
