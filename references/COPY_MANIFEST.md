# Copy manifest contract

Create `copy-manifest.json` alongside the raw ImageGen images. It records the exact visible copy the user approved and binds the batch to its selected LinkedIn format.

```json
{
  "post_type": "carousel",
  "format": "Portrait",
  "slides": [
    {
      "file": "01-cover.png",
      "copy": ["THE HEADLINE", "A concise supporting line", "@haidarali.hq"]
    },
    {
      "file": "02-insight.png",
      "copy": ["One useful point", "A short explanation", "@haidarali.hq"]
    }
  ],
  "copy_qa": {
    "status": "pass",
    "reviewer": "agent",
    "method": "Compared every full-size raw slide visually against this manifest before finalization."
  }
}
```

- `slides[].file` must exactly match the final output name. A raw `01-cover.jpg` becomes `01-cover.png`.
- `slides[].copy` includes every intentional visible text element, including the mandatory `Haidar Ali` footer name, CTA, labels, and punctuation.
- Write the manifest before generation, but set `copy_qa.status` to `pass` only after reviewing every raw slide at full size.
- The finalizer rejects missing or extra slides, a format mismatch, duplicate file names, and an unreviewed manifest.
