---
name: haidar-linkedin-posts
description: "Create ImageGen-first LinkedIn single-image posts and document carousels for Haidar Ali, with exact platform sizing and final delivery validation. Use for professional LinkedIn visual content; not Instagram-only creator carousels, ordinary posters, or UI design."
---

# Haidar LinkedIn Posts

Create polished, professional LinkedIn visual posts for Haidar Ali. A request can be a **single-image post** or a **document carousel**; never assume it is a carousel.

> **STOP — mandatory delivery contract:** Every ImageGen result is a draft preview, never a final. A post or carousel is complete only after `scripts/finalize_linkedin_images.ps1` returns JSON with `"status": "ok"`. Deliver only files from its output folder.

## Intake

Ask only for what is missing:

1. Post type: single image or document carousel. Do not assume either.
2. Topic/source, audience, and desired action.
3. Exact copy or permission to write it.
4. Format: ask the user to choose **Portrait 1080×1350**, **Square 1080×1080**, **Square 1200×1200**, or **Landscape 1200×627**. Portrait is recommended for mobile engagement, but never selected by default.
5. Brand/portrait/screenshots, when relevant.
6. A catalogue style code after the catalogue has been installed. The current selectable codes are in [LINKEDIN_CATALOG.md](assets/reference-catalog/LINKEDIN_CATALOG.md). Until then, ask for a visual reference rather than inventing a fixed style.

For a carousel, write/confirm complete slide-by-slide copy before generating. For a single image, write/confirm the headline, support line, CTA, and any credibility proof before generating. Keep copy concise, specific, and readable at mobile size.

## Required Haidar Ali footer

Every delivered LinkedIn visual—single image or every carousel slide—must include the supplied small Haidar portrait and the exact name **Haidar Ali** in a discreet, consistent footer. This is a fixed brand element, not something inherited from a reference. Read [BRAND_FOOTER.md](references/BRAND_FOOTER.md) before planning the layout. Include `Haidar Ali` in every slide's copy manifest and visually verify the name plus portrait before finalization.

## Text integrity gate

Create a copy manifest before ImageGen: the exact visible text, capitalization, numerals, punctuation, and approved line breaks for every post or slide. Use [COPY_MANIFEST.md](references/COPY_MANIFEST.md). That manifest is the text authority.

Use ImageGen to render the text, but do not let it improvise copy. If the copy is too dense, shorten or restructure it before generation; never solve density by using tiny type. Inspect every generated draft at full size against the manifest. Reject and regenerate a draft with a typo, missing word, changed punctuation, warped/illegible letters, unexpected text, text outside safe margins, or a foreign handle. After finalization, state `Copy QA: PASS` only if every final image was compared against its manifest.

Read `references/FORMAT_AND_DELIVERY.md` whenever choosing a format or packaging final assets. Read `references/IMAGEGEN_PROTOCOL.md` for every generation. Read `references/BRAND_FOOTER.md` before planning every layout. Read `references/COPY_MANIFEST.md` before every generation batch and finalization. Read `references/QA_AND_ORIGINALITY.md` before approving finals. Read `references/CATALOG_INTAKE.md` only when a reference catalogue is supplied.

## Visual system

Use ImageGen for the entire final composition and all visible text. Never use HTML, SVG, CSS, Canvas, Pillow, or another code renderer to place, replace, or repair visible text.

## ImageGen workflow routing

Before every generation or edit, load and use the built-in `$imagegen` skill. Choose the **primary ImageGen use case** from the post's communication job, not from a reference's appearance, and include that exact `Use case:` in every ImageGen prompt.

| Post need | Primary ImageGen use case |
| --- | --- |
| Framework, checklist, comparison, process, operational/business insight, or structured product thinking | `productivity-visual` |
| Explainer with a labelled model, anatomy, flow, map, cause/effect relationship, or data-led concept | `infographic-diagram` |
| Product launch, offer, campaign, conversion CTA, or positioning announcement | `ads-marketing` |
| Real-world professional scene, editorial story, or candid lifestyle-led post | `photorealistic-natural` |
| UI or product screen used as the main visual proof | `ui-mockup` |
| Style-led abstract concept where the idea cannot be better communicated as a diagram or business visual | `stylized-concept` |

When a supplied portrait must appear, add the `identity-preserve` edit constraints: preserve exact face geometry, skin texture, hairline, hairstyle, beard, age, gaze, and expression. When a portrait, product screenshot, or supporting image must be placed into a new scene, use `compositing` constraints as well. For revisions that change only visible text while preserving the composition, use `text-localization` constraints.

For a carousel, choose one primary use case for the campaign system. A slide can use a different one only when its communication job genuinely changes; retain the same brand system and explain the reason in the creative plan. Never choose a mode merely to imitate a catalogue reference.

For a single image, create one decisive visual idea with a clear headline, useful proof/object, and restrained CTA. For a carousel, establish a cover, one approved content master, and a closing CTA master; use the actual approved master as a reference on subsequent slides where continuity is requested. Do not produce an unrelated poster series.

Use a supplied portrait as an exact identity source, not loose inspiration. Preserve face geometry, natural skin tone and texture, hairline, hairstyle, beard, age, gaze, and expression. Avoid repeating the same source image in a carousel unless the user explicitly requests a bookend repeat.

### Reference originality contract

References are visual vocabulary, never templates to reproduce. Before every generation, state what each reference may teach (for example hierarchy, contrast, material, density, or image treatment) and explicitly forbid its identifying literals: original wording, logos, handles, page counts, platform chrome, recurring objects, exact layout, or distinctive diagram.

Build a new visual concept from the actual post idea. For a carousel, maintain one campaign system but vary the composition, evidence object, and focal balance by slide; do not duplicate the cover or make near-identical slides. Reject a result that reads as a trace, clone, or reskin of a supplied reference.

## Required finalization

State the exact target dimensions in every ImageGen prompt. Collect only the selected raw finals into one folder, then run:

```powershell
scripts/finalize_linkedin_images.ps1 -InputDirectory <raw-folder> -OutputDirectory <empty-delivery-folder> -Format Portrait -ManifestPath <copy-manifest.json>
```

The manifest must list the selected format, each expected output filename, and its exact approved copy. Mark `copy_qa.status` as `pass` only after full-size visual comparison. Use `Square1080`, `Square1200`, or `Landscape` only when selected. The script rejects a non-matching raw aspect ratio, a missing/extra file, a manifest mismatch, an unreviewed copy manifest, wrong dimensions, or a file over 5 MB; it writes `delivery-report.json` only on success. A non-zero exit is a delivery blocker: regenerate the failed image, then rerun the full batch. Never pad a wrong aspect ratio into a plausible-looking post.

When finished, report the post type, user-selected format, final folder, passing validation report, and `Copy QA: PASS`. Do not call draft previews final.

## Evals

Use `evals/evals.json` for regression prompts. The first implementation focuses on objective delivery assertions: correct dimensions, matching aspect ratio, file size at or below 5 MB, and all requested slides present. Add human visual review after each real campaign.
