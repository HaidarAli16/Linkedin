# Copy manifest contract

`copy-manifest.json` holds the exact final text for every image. It's the only text source, and it's never paraphrased or extended. In job mode Claude writes it; ChatGPT only reads it.

```json
{
  "post_type": "carousel",
  "format": "Portrait",
  "slides": [
    {
      "file": "slide_01_4x5.png",
      "copy": ["The headline", "A concise supporting line", "Haidar Ali", "AI-First Product Designer / Builder", "Repost ↗"]
    },
    {
      "file": "slide_02_4x5.png",
      "copy": ["One useful point", "A short explanation", "Haidar Ali", "AI-First Product Designer / Builder", "Repost ↗"]
    }
  ],
  "copy_qa": {
    "status": "pending",
    "reviewer": "",
    "method": ""
  }
}
```

- **File names:** `slide_NN_4x5.png` for carousels, `linkedin_4x5.png` for single images (use `_1x1` or `_landscape` for other formats). A raw `.jpg` becomes `.png`.
- `copy` lists every visible text element, including the footer.
- Set `copy_qa.status` to `pass` only after comparing every full-size image against this manifest. The finalizer rejects `pending`, missing or extra files, and a format mismatch.
