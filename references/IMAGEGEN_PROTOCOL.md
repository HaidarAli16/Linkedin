# ImageGen protocol

Every prompt must state:

- post type and slide role;
- exact target dimensions and aspect ratio;
- exact visible copy, capitalization, punctuation, numerals, and approved line breaks from the copy manifest;
- attached-image roles: style reference, exact identity source, product screenshot, or continuity master;
- the layout hierarchy, safe margins, and allowed visual changes;
- rejection rules: no typos, invented logos, platform UI, foreign handle, distorted type, face drift, or unrelated visual theme.

For portrait use this invariant: "Preserve the supplied person’s face exactly: same facial geometry and proportions, natural skin texture and tone, hairline and hairstyle, beard shape, age, eyes and spacing, eyebrows, nose, mouth, jaw, gaze, and expression. This is identity-preserving image editing, not a reinterpretation. Do not beautify, smooth, reshape, age, stylize, or substitute a similar person. Keep the face unobstructed, tack-sharp, naturally lit, and clearly readable."

At full size, compare each draft against the copy manifest. Regenerate on any typo, missing or unexpected word, altered punctuation, foreign handle, warped text, low contrast, or text outside safe margins. Preview generated images, reject errors, and finalize only selected raw files through the delivery script.
