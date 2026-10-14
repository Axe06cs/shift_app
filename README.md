# Shift Converter

Flutter translation of the provided C program. Two text fields: type or
paste in the top box, converted text appears live in the bottom box.

Logic, unchanged from the C source:
- Each character is swapped through a fixed table (5<->a, 4<->b, 3<->c,
  2<->d, 1<->e, 0<->f, 7<->8, 9<->6); anything else passes through.
- If the input starts with `fh_`, that prefix is dropped and `wlan` is
  written in its place before the rest of the string is converted.

## Push to GitHub

From an empty repo cloned locally, copy all files from this folder in
(including the hidden `.github/` folder), then:

```
git add -A
git commit -m "initial"
git push
```

## Get the APK

Open the repo's Actions tab, wait for the "Build APK" run to finish
(a few minutes), open the run, and download the `shift-converter-apk`
artifact from the Artifacts section at the bottom. It is a zip
containing `app-release.apk`.

This APK is unsigned for release (debug-signable via Flutter's default
tooling) and fine for installing on your own device via "allow
installs from unknown sources." It is not suitable for Play Store
submission as-is.

If the Action fails, copy the full error log and send it back for a fix.
