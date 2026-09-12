# Fork notes

This is a fork of [maplibre/flutter-maplibre-gl](https://github.com/maplibre/flutter-maplibre-gl),
branch `custom-attribution-0.26.2`, based on tag `v0.26.2`.

## Why

[FieldSketch](https://github.com/tmatsumoto-conn-with) (a disaster-response field app)
renders map attributions in its own accessible widget, so that the attribution text is
readable with screen readers, sized for field use, and consistent across the Web console
and the mobile app. The upstream SDK always shows its built-in attribution button on
Android and iOS, which would duplicate the notice.

## What changed

* `MapLibreMap(attributionButtonEnabled: bool = true)` — when `false`, the built-in
  attribution button is not shown. This mirrors `attributionControl: false` in
  MapLibre GL JS.
* `MapLibreMapController.getAttributions()` — the attribution strings of every source
  in the current style (style order, deduplicated), regardless of layer visibility.
  New platform-channel method `style#getAttributions`.

The button is hidden but the attribution **data stays exposed**; an app that disables the
button MUST display the attributions itself, as required by the data licences
(e.g. ODbL for OpenStreetMap). This is custom attribution rendering, not a way to hide
the licence notice.

## Intended for upstreaming

The change is kept minimal and follows the existing option/channel patterns so it can be
proposed to upstream as-is. Until then, depend on it with:

```yaml
dependencies:
  maplibre_gl:
    git:
      url: https://github.com/tmatsumoto-conn-with/flutter-maplibre-gl.git
      ref: <commit sha>
      path: maplibre_gl
```

## Licence

The upstream BSD-2-Clause licence (`LICENSE`) is preserved unchanged; the fork is
distributed under the same terms.
