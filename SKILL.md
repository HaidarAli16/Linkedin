---
name: haidar-linkedin-posts
description: "Create LinkedIn single-image posts and document carousels for Haidar Ali with ImageGen, using only the exact final text he supplies, with exact sizing and delivery validation. Use for professional LinkedIn visuals; not Instagram-only carousels, posters or UI design."
---

# Haidar LinkedIn Posts

## Hard rules (always)
1. **ImageGen only.** Load and use the built-in `$imagegen` skill for every generation and edit. Never place or fix text with HTML, SVG, Canvas, Pillow or any other code.
2. **Final text only.** Use the supplied text exactly, word for word: same capitalisation, punctuation, numbers and line breaks. Never paraphrase, shorten, expand, translate or add words, labels or taglines. If it doesn't fit, stop and report it. Don't rewrite it.
3. **Footer on every image:** the supplied small portrait `assets/identity/haidar-footer-portrait.jpg` + `Haidar Ali` + `AI-First Product Designer / Builder` at bottom left, and a small `Repost ↗` at bottom right. No handle. See [BRAND_FOOTER.md](references/BRAND_FOOTER.md).
4. **Real face only.** Use `identity-preserve` for any portrait. Never a different or "similar" person.
5. **References are vocabulary, not templates.** Never copy their text, logos, handles, layouts, page counters or distinctive diagrams.
6. **Nothing is final until** `scripts/finalize_linkedin_images.ps1` returns `"status": "ok"`.

## Job mode (default)
When given a design queue file (`Haidar Ali/05_Design_Queue/*.md`):
1. Read the file. Do exactly what it lists and nothing else. Ask no questions.
2. For each post, use its format, style codes, portrait placement, ImageGen use case and the text in its `copy-manifest.json`.
3. Generate → check every image at full size against the manifest (every word, the footer, the face) → regenerate any failure.
4. Finalize each post into its QA inbox folder listed in the queue file (it must be empty):
   `scripts/finalize_linkedin_images.ps1 -InputDirectory <raw> -OutputDirectory <qa_inbox/HA-###> -Format <Format> -ManifestPath <manifest>`
5. Report per post: `HA-### done` or `HA-### failed: <reason>`. (Claude marks the matching row in `Haidar Ali/TRACKER.md` — nothing to do here.)

## Manual mode (no queue file)
Ask only what's missing: single or carousel, format (Portrait 1080×1350 recommended, Square1080, Square1200, Landscape 1200×627), final text, style code. Then follow the same hard rules.

## Design baseline
Credible, editorial and calm. Neutral palette, one accent at most. No neon, glossy 3D, glow or AI-slop effects. A clear grid, proportionate headline and readable body; never tiny type. A carousel is one system: cover, content master, closing slide. Vary composition across slides without cloning.

## ImageGen use case (put it in every prompt)
Framework, checklist or comparison → `productivity-visual` · labelled model or flow → `infographic-diagram` · launch or offer → `ads-marketing` · real scene → `photorealistic-natural` · UI proof → `ui-mockup` · abstract concept → `stylized-concept`. Add `identity-preserve` for the portrait and `compositing` when placing supplied images.

## Load only when needed
[IMAGEGEN_PROTOCOL.md](references/IMAGEGEN_PROTOCOL.md) (every prompt) · [COPY_MANIFEST.md](references/COPY_MANIFEST.md) · [FORMAT_AND_DELIVERY.md](references/FORMAT_AND_DELIVERY.md) · [QA_AND_ORIGINALITY.md](references/QA_AND_ORIGINALITY.md) · [LINKEDIN_CATALOG.md](assets/reference-catalog/LINKEDIN_CATALOG.md) (style codes L01–L19) · [CATALOG_INTAKE.md](references/CATALOG_INTAKE.md) (adding new references)
