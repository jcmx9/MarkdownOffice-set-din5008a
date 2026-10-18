// din5008a – DIN 5008 Form A letters as a Markdown Office template set.
// Layout ported from jcmx9/typst-DIN5008a (MIT). The letter data comes from the note's
// front matter (frontmatter() of the pipeline) and the sender profile (input `profile`);
// the letter text is the note's Markdown body.

#let mdo = sys.inputs.at("mdo", default: ".")
#import "@preview/cades:0.3.1": qr-code          // from the pipeline's offline package store
#import mdo + "/vendor/cmarker/lib.typ" as cmarker
#import mdo + "/vendor/mitex/lib.typ": mitex
#import mdo + "/lib/markdown.typ": preprocess, frontmatter
#let version = sys.inputs.at("version", default: "")

// Bullet character in Source Sans 3 (consistent with header/footer)
#let bullet = text(font: "SourceSans3VF", "▪")

#let din5008a(
  sender: (:),
  recipient: (),
  date: none,
  subject: none,
  title: none,
  doc-date: auto,
  closing: none,
  signature: none,
  signature-width: 40mm,
  accent: rgb("#B03060"),
  debug: false,
  attachments: (),
  fold-marks: true,
  lang: "de",
  body,
) = {
  // -- Fonts --
  let font-body = ("Source Serif 4", "Noto Emoji", "Noto Sans Symbols 2")
  let font-ui = ("SourceSans3VF", "Noto Emoji", "Noto Sans Symbols 2")
  let font-mono = ("SourceCodeVF", "Noto Emoji")
  let labels = if lang == "de" {
    (phone: "Telefon", email: "E-Mail", page: "Seite", of: "von", attachments: "Anlagen:")
  } else {
    (phone: "Phone", email: "Email", page: "Page", of: "of", attachments: "Enclosures:")
  }
  let gray = rgb(128, 128, 128)
  let dbg = if debug { 1pt + red } else { none }
  let dbg-fill = if debug { rgb(255, 0, 0, 15%) } else { none }

  // -- DIN 5008 Form A measurements (mm from page top) --
  let margin-left = 25mm              // left margin
  let margin-right = 20mm             // right margin (binding edge)
  let margin-top = 20mm               // top margin
  let has-bank = sender.at("iban", default: none) != none or sender.at("bic", default: none) != none or sender.at("bank", default: none) != none
  let footer-text-height = if has-bank { 12.7mm } else { 7.94mm }  // 3 lines: 3×9pt+2×4.5pt, 2 lines: 2×9pt+1×4.5pt
  let margin-bottom = 7mm + footer-text-height + 4mm + 0.75pt + 4mm  // page edge + text + gap + line + gap
  let return-addr-y = 40.7mm          // return address (bottom of Zusatz-/Vermerkzone)
  let addr-field-y = 44.7mm           // address zone top (27mm + 17.7mm)
  let info-block-y = 32.0mm           // information block top (DIN diagram: 32mm)
  let info-block-x = 125.0mm          // information block left edge
  let info-block-w = 75.0mm           // information block width
  let text-body-y = 103.46mm          // subject position (DIN diagram: 103,46mm)
  let fold-1 = 87mm                   // fold mark 1
  let fold-2 = 192mm                  // fold mark 2
  let punch = 148.5mm                 // punch hole mark

  // follow-up header data
  let recipient-name = if recipient.len() > 0 { recipient.at(0) } else { "" }
  let sep = [ ▪ ]

  // -- Page setup --
  set page(
    paper: "a4",
    margin: (
      top: margin-top,
      bottom: margin-bottom,
      left: margin-left,
      right: margin-right,
    ),
    header: none,
    footer: none,
    // background: all DIN elements absolutely positioned
    background: context {
      let pg = counter(page).get().first()
      // debug: vertical scale every 5mm on right edge
      if debug {
        for i in range(0, 60) {
          let y = i * 5mm
          let len = if calc.rem(i, 2) == 0 { 3mm } else { 1.5mm }
          place(top + right, dx: 0mm, dy: y,
            line(length: len, stroke: 0.5pt + red))
          if calc.rem(i, 2) == 0 {
            place(top + right, dx: len + 1mm, dy: y - 1.5mm,
              text(font: font-ui, size: 5pt, fill: red, str(i * 5)))
          }
        }
      }
      // follow-up header (page 2+)
      if pg > 1 {
        place(top + left, dx: margin-left, dy: 10mm,
          box(width: 165mm, stroke: dbg, fill: dbg-fill, {
            set text(font: font-ui, size: 9pt, fill: gray)
            align(right, {
              recipient-name
              sep
              if subject != none { subject }
              sep
              [#labels.page #pg]
            })
          }))
      }
      // fold marks (page 1 only)
      if fold-marks and pg == 1 {
        place(top + left, dx: 0mm, dy: fold-1,
          line(length: 9mm, stroke: 0.75pt + accent))
        place(top + left, dx: 0mm, dy: punch,
          line(length: 11mm, stroke: 0.75pt + accent))
        place(top + left, dx: 0mm, dy: fold-2,
          line(length: 9mm, stroke: 0.75pt + accent))
      }
      // footer: line + text bottom-aligned, 7mm from page edge
      {
        let footer-content = {
          set text(font: font-ui, size: 9pt, fill: gray)
          align(center, {
            {
              let parts = ()
              if sender.at("name", default: none) != none { parts.push(sender.name) }
              if sender.at("street", default: none) != none and sender.at("city", default: none) != none {
                parts.push(sender.street)
                parts.push(sender.city)
              }
              if sender.at("phone", default: none) != none { parts.push(labels.phone + " " + sender.phone) }
              if sender.at("email", default: none) != none { parts.push(labels.email + " " + sender.email) }
              parts.join([ ▪ ])
            }
            linebreak()
            {
              let bank-parts = ()
              if sender.at("iban", default: none) != none { bank-parts.push("IBAN " + sender.iban) }
              if sender.at("bic", default: none) != none { bank-parts.push("BIC " + sender.bic) }
              if sender.at("bank", default: none) != none { bank-parts.push(sender.bank) }
              if bank-parts.len() > 0 {
                bank-parts.join([ ▪ ])
                linebreak()
              }
            }
            {
              let pg = counter(page).get().first()
              let total = counter(page).final().first()
              [#labels.page #pg #labels.of #total]
            }
          })
        }
        let footer-height = measure(box(width: 165mm, footer-content)).height
        let footer-text-y = 297mm - 7mm - footer-height
        place(top + left, dx: margin-left, dy: footer-text-y - 4mm,
          line(length: 165mm, stroke: 0.75pt + accent))
        place(top + left, dx: margin-left, dy: footer-text-y,
          box(width: 165mm, stroke: dbg, fill: dbg-fill, footer-content))
      }
    },
  )

  // PDF metadata
  set document(
    title: if title != none and title != "" { title } else if subject != none { subject } else { "Brief" },
    author: sender.at("name", default: ""),
    date: doc-date,
    keywords: ("Markdown Office " + version, "din5008a"),
  )

  // -- Default text settings --
  set text(font: font-body, size: 11pt, lang: lang, region: if lang == "de" { "DE" } else { none })
  // all bold → semibold (headings, *strong*, etc.)
  show strong: it => text(weight: 600, it.body)
  show heading: it => block(sticky: true, text(weight: 600, size: 11pt, it.body))
  set par(justify: false, leading: 5.5pt, spacing: 16.5pt)  // 150% line height (5.5pt between lines, 16.5pt = one blank line between paragraphs)
  set list(marker: text(font: font-ui, "▪"))
  // prevent orphaned list items (min 2 together)
  show list: set block(breakable: false)
  show enum: set block(breakable: false)
  // tables: monospace 10pt, compact, header darker, zebra stripes
  show table: set text(font: font-mono, size: 10pt)
  set table(
    inset: (x: 6pt, y: 3pt),
    fill: (_, y) => {
      if y == 0 { rgb(210, 210, 210) }
      else if calc.odd(y) { white }
      else { rgb(240, 240, 240) }
    },
    stroke: 0.75pt + gray,
  )
  show table.cell.where(y: 0): set text(weight: 600)
  // code blocks: monospace with light background, min 3 lines together
  show raw.where(block: true): it => {
    set text(font: font-mono, size: 10pt)
    block(width: 100%, fill: rgb(245, 245, 245), inset: 8pt, radius: 2pt, breakable: false, it)
  }
  show raw.where(block: false): set text(font: font-mono, size: 10pt)

  // ============================================================
  // Information block — 32mm top, 125mm left, 75mm × 63mm
  // ============================================================
  place(top + left,
    dx: info-block-x - margin-left,
    dy: info-block-y - margin-top,
    box(width: info-block-w, height: 63mm, stroke: dbg, fill: dbg-fill,
      align(bottom + right, {
        set text(font: font-ui, size: 11pt, fill: accent)
        set par(spacing: 0pt, leading: 5.5pt)
        // sender details — built bottom-up, displayed top-down
        if sender.at("name", default: none) != none {
          text(sender.name)
          linebreak()
        }
        if sender.at("street", default: none) != none {
          text(sender.street)
          linebreak()
        }
        if sender.at("city", default: none) != none {
          text(sender.city)
          linebreak()
        }
        if sender.at("phone", default: none) != none {
          [#labels.phone #sender.phone]
          linebreak()
        }
        if sender.at("email", default: none) != none {
          [#labels.email #sender.email]
        }
        // QR code (optional)
        if sender.at("qr", default: false) == true {
          let vcard-parts = ("BEGIN:VCARD", "VERSION:3.0")
          if sender.at("name", default: none) != none {
            vcard-parts.push("FN:" + sender.name)
          }
          if sender.at("street", default: none) != none and sender.at("city", default: none) != none {
            vcard-parts.push("ADR:;;" + sender.street + ";" + sender.city + ";;;Germany")
          }
          if sender.at("phone", default: none) != none {
            vcard-parts.push("TEL:" + sender.phone)
          }
          if sender.at("email", default: none) != none {
            vcard-parts.push("EMAIL:" + sender.email)
          }
          vcard-parts.push("END:VCARD")
          let vcard = vcard-parts.join("\n")
          v(4mm)
          qr-code(vcard, width: 16mm, color: accent)
        }
        // separator line
        v(4mm)
        line(length: info-block-w, stroke: 0.75pt + accent)
        v(7mm)
        // date
        if date != none {
          text(font: font-body, size: 11pt, fill: black, date)
          v(1mm)
        }
      })),
  )

  // ============================================================
  // Return address — bottom of Zusatz-/Vermerkzone (filled upward)
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: return-addr-y - margin-top,
    box(width: 85mm, stroke: dbg, fill: dbg-fill, {
      set text(font: font-ui, size: 9pt, fill: accent)
      underline(offset: 1.5pt, stroke: 0.75pt + accent, {
        if sender.at("name", default: none) != none { sender.name }
        sep
        if sender.at("street", default: none) != none { sender.street }
        sep
        if sender.at("city", default: none) != none { sender.city }
      })
    }),
  )

  // ============================================================
  // Address zone — 44.7mm from top
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: addr-field-y - margin-top,
    box(width: 85mm, height: 27.3mm, stroke: dbg, fill: dbg-fill, {
      set text(font: font-body, size: 11pt, fill: black)
      for (i, addr-line) in recipient.enumerate() {
        text(addr-line)
        if i < recipient.len() - 1 {
          linebreak()
        }
      }
    }),
  )

  // ============================================================
  // Subject — 103.46mm from top (DIN 5008 Form A)
  // ============================================================
  v(text-body-y - margin-top)

  if subject != none {
    text(font: font-body, size: 11pt, weight: 600, subject)
    v(6mm)
  }

  // body
  body

  // closing, signature, sender name — 3 blank lines between closing and name (DIN 5008)
  // signature: SVG string (from read()) — currentColor is replaced with Salix (#103c78)
  let salix = "#103c78"
  // resolve signature: string (SVG data) → image with Salix color
  let sig-img = if type(signature) == str {
    image(bytes(signature.replace("currentColor", salix)), width: signature-width)
  } else {
    signature
  }
  if closing != none {
    let name = sender.at("name", default: "")
    // parbreak() forces new paragraph = blank line before closing
    parbreak()
    // single paragraph: closing + 3 blank lines + name (all with same leading)
    closing

    // 3 blank lines between closing and name (DIN 5008)
    linebreak()
    hide[.]
    linebreak()
    hide[.]
    linebreak()
    hide[.]

    // name in own block — signature overlays blank lines above
    parbreak()
    block({
      if sig-img != none {
        context {
          let sig-h = measure(sig-img).height
          place(dx: -2mm, dy: -(sig-h + 2mm),
            box(stroke: dbg, fill: dbg-fill, sig-img))
        }
      }
      name
    })

    // attachments after name
    if attachments.len() > 0 {
      parbreak()
      text(weight: 600, labels.attachments)
      linebreak()
      for att in attachments {
        text(font: font-ui, "▪")
        [ #att]
        linebreak()
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Markdown Office adapter: front matter + profile -> din5008a(…), Markdown body via cmarker.
// ---------------------------------------------------------------------------
#let inp(key, default: "") = sys.inputs.at(key, default: default)
#let source = inp("source", default: none)
#let src-text = if source == none { "" } else { read(source) }
#let fm = frontmatter(src-text)
#let lang = inp("lang", default: "de")
#let probe = inp("probe", default: "false") == "true"

// Sender: the profile file the pipeline found, each field overridable as x-profile-<field>.
#let profile-path = inp("profile")
#let profile = if profile-path == "" { (:) } else { yaml(profile-path) }
#let profile-dir = profile-path.split("/").slice(0, -1).join("/")
#let sender = {
  let s = profile
  for (k, v) in fm.pairs() {
    if k.starts-with("x-profile-") { s.insert(k.slice("x-profile-".len()), v) }
  }
  s
}

// Hard stops: a letter without sender or address must not be produced (the probe run
// only collects images and may run with an incomplete note).
#let recipient = fm.at("x-to", default: ())
#if not probe {
  assert(profile-path != "", message: "din5008a: profile: fehlt (Absender-Profil, z. B. profile: beispiel)")
  assert(type(recipient) == array and recipient.len() > 0,
    message: "din5008a: x-to: fehlt (Anschrift als Liste von Zeilen)")
  assert(recipient.len() <= 6, message: "din5008a: x-to: höchstens 6 Zeilen (DIN 5008 Anschriftzone)")
}

// Date: ISO or German in the front matter, shown long and localised; empty -> today
// (SOURCE_DATE_EPOCH from the pipeline keeps it reproducible).
#let months-de = ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August",
  "September", "Oktober", "November", "Dezember")
#let parse-date(s) = {
  let s = s.trim()
  let p = if s.match(regex("^\d{4}-\d{1,2}-\d{1,2}$")) != none { s.split("-").map(int) }
    else if s.match(regex("^\d{1,2}\.\d{1,2}\.\d{4}$")) != none { s.split(".").map(int).rev() }
    else { return none }
  if p.at(1) < 1 or p.at(1) > 12 or p.at(2) < 1 or p.at(2) > 31 { return none }
  datetime(year: p.at(0), month: p.at(1), day: p.at(2))
}
#let date-raw = inp("date")
#let date-val = if date-raw.trim() == "" { datetime.today() } else { parse-date(date-raw) }
#let date-text = if date-val == none { date-raw } else if lang == "de" {
  str(date-val.day()) + ". " + months-de.at(date-val.month() - 1) + " " + str(date-val.year())
} else { date-val.display("[month repr:long] [day padding:none], [year]") }

// Images: same probe/images contract as memo (see TEMPLATES.md, section 5.1).
#let image-map = if inp("images") == "" { none } else { json(inp("images")) }
#let docdir = inp("docdir")
#let safe-image(src, alt: none, ..args) = {
  if type(src) != str { return image(src, alt: alt, ..args) }
  if src.starts-with("http://") or src.starts-with("https://") or src.starts-with("//") or src.starts-with("data:") {
    return [#metadata(src)<mdo-remote-skip>]
  }
  if probe { return [#metadata(src)<mdo-image>] }
  let path = if image-map != none { image-map.at(src, default: "") }
    else if src.starts-with("/") or docdir == "" { src } else { docdir + "/" + src }
  if path == "" { emph[\[#if lang == "de" [Bild fehlt] else [missing image]: #src\]] }
  else { image(path, alt: alt, ..args) }
}

// Elements produced by lib/markdown.typ's preprocess, in the letter's quiet style.
#let mdo-alert(attrs, body) = block(width: 100%, inset: (left: 8pt, y: 4pt),
  stroke: (left: 1.5pt + luma(60%)), body)
#let mdo-task(attrs, body) = metadata((done: attrs.at("done", default: "false") == "true",
  owner: attrs.at("owner", default: ""), due: attrs.at("due", default: ""), body: body))
#let mdo-tasks(attrs, body) = {
  let kids = if body.func() == metadata { (body,) } else if body.has("children") { body.children } else { () }
  let tasks = kids.filter(c => c.func() == metadata).map(c => c.value)
  list(..tasks.map(t => [#if t.done [☑] else [☐] #t.body#if t.owner != "" [ (#t.owner)]#if t.due != "" [ – #t.due]]))
}
#let mdo-keep(attrs, body) = block(sticky: true, body)

#let attach = inp("attach")
#if attach != "" {
  pdf.attach("/" + attach.split("/").last(), read(attach, encoding: none),
    relationship: "source", mime-type: "text/markdown", description: "Markdown source")
}

#let flag(key, default) = {
  let v = fm.at(key, default: default)
  if type(v) == bool { v } else { str(v).trim().lower() in ("true", "yes", "on") }
}
#let signature = if flag("x-sign", true) and sender.at("signature", default: none) != none and profile-dir != "" {
  read(profile-dir + "/" + sender.signature)
} else { none }
#let atts = fm.at("x-attachments", default: ())
// Empty or missing text keys (the header template writes `x-subject: ""`) mean "not set".
#let opt-text(key) = {
  let v = fm.at(key, default: none)
  if v == none or str(v).trim() == "" { none } else { str(v) }
}

#show: din5008a.with(
  sender: sender,
  recipient: if type(recipient) == array { recipient.map(str) } else { () },
  date: date-text,
  doc-date: if date-val == none { auto } else { date-val },
  subject: opt-text("x-subject"),
  title: inp("doctitle"),
  closing: opt-text("x-closing"),
  signature: signature,
  // Only "<number>mm" is accepted (never eval() profile data); anything else -> 40mm.
  signature-width: {
    let w = str(sender.at("signature-width", default: "40mm")).trim()
    let m = w.match(regex("^(\d+(?:\.\d+)?)mm$"))
    if m == none { 40mm } else { float(m.captures.at(0)) * 1mm }
  },
  accent: rgb(sender.at("accent", default: "#B03060")),
  attachments: if atts == none { () } else if type(atts) == array { atts.map(str) } else { (str(atts),) },
  debug: flag("x-debug", false),
  fold-marks: flag("x-fold-marks", true),
  lang: lang,
)

#cmarker.render(
  preprocess(src-text, hard-breaks: inp("hard_breaks", default: "true") != "false", lang: lang),
  h1-level: 1,
  set-document-title: false,
  smart-punctuation: false,
  math: mitex,
  html: (mdo-alert: mdo-alert, mdo-tasks: mdo-tasks, mdo-task: mdo-task, mdo-keep: mdo-keep),
  scope: (image: safe-image, terms: (..pairs) => terms(..pairs.pos().map(p => terms.item(..p)))),
)
