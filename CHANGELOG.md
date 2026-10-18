# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [26.10.0] - 2026-10-18

### Added
- Initial release: DIN 5008 Form A letters for Markdown Office, layout ported from typst-DIN5008a
- Mermaid diagrams in the letter body (offline via the bundled mmdr)
- Profile values are normalised: text fields as text, `accent` validated (`#RRGGBB`, else the default), `qr` as a flag

### Security
- `signature` must be a plain `.svg` file name next to the profile; `x-profile-signature` is ignored
