# LinkedIn format and delivery

Ask Haidar to choose a format from the post's job; do not assume a default.

- **Portrait** — `1080×1350`, 4:5. Recommend it for mobile-first feed presence.
- **Square 1080** — `1080×1080`, 1:1. Use when symmetry or a compact graphic matters.
- **Square 1200** — `1200×1200`, 1:1. Use only when the user requests the 1200-pixel square deliverable.
- **Landscape** — `1200×627`, 1.91:1. Use only when the user explicitly requests landscape or the message needs a broad editorial/comparison composition.

Every individual final file must be 5 MB or smaller. All slides in one carousel must share one user-selected format.

Only `scripts/finalize_linkedin_images.ps1` may produce the delivery folder. It first rejects raw images that have the wrong aspect ratio, then resamples a valid raw to the exact selected dimensions and verifies each exported PNG is at or below 5 MB.
