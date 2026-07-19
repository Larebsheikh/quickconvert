# Multi-Unit Converter (Flutter)
<img width="400" height="617" alt="image" src="https://github.com/user-attachments/assets/610ab665-9f29-402a-beee-d37355893e0b" />


Converts values across 8 categories: Length, Mass, Temperature, Volume, Area,
Time, Speed, and Digital Storage. Pure Dart logic, zero backend, zero
third-party packages beyond Flutter itself — everything runs on-device.

## About the video you linked

Heads up: [that video](https://www.youtube.com/watch?v=CzRQ9mnmh44) isn't a
dedicated "Multi-Unit Converter" tutorial — it's Rivaan Ranawat's 20-hour
**"Complete Dart & Flutter Developer Course,"** which teaches Dart/Flutter
fundamentals by building a Currency Converter, a Weather app, and a Shop app.

This project follows the same beginner-friendly patterns that course uses,
so if you watch it, the code here should look familiar:

| Concept from the course | Where it's used here |
|---|---|
| `StatefulWidget` + `setState` (~11:51:47, ~12:27:11) | `ConverterScreen` — no external state management package |
| `TextField` (~10:06:49) | Value input |
| `Card` / `Container` + `BoxDecoration` (~13:34:22, ~10:53:12) | `ResultCard`, `UnitDropdown` |
| `Chip` widget (~17:14:16) | `CategoryChipBar` — category selector |
| Splitting & extracting widgets (~09:29:09) | Everything under `lib/widgets/` |
| `Row` / `Padding` / layout widgets (~13:58:14, ~10:53:12) | Unit selector row with swap button |

If you actually want the app built by literally following the video's own
project (the Currency Converter, ~09:42:47–13:09:53), let me know and I can
build that specific one instead — it's narrower in scope (just currency, and
typically needs a live exchange-rate API) than this multi-category version.

## Project structure

```
multi-unit-converter/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── theme.dart
    ├── models/
    │   └── conversion_category.dart   # linear + temperature conversion logic
    ├── data/
    │   └── unit_data.dart             # all 8 categories and their unit factors
    ├── screens/
    │   └── converter_screen.dart      # main UI + state
    └── widgets/
        ├── category_chip_bar.dart
        ├── unit_dropdown.dart
        ├── swap_button.dart
        └── result_card.dart
```

## Setup

```bash
cd multi-unit-converter
flutter create --org com.yourcompany --project-name multi_unit_converter .
# if prompted to overwrite pubspec.yaml, say no
flutter pub get
flutter run
```

No permissions, no API keys, no backend — it should run immediately on any
simulator, emulator, or physical device. It'll also run on Flutter Web
(`flutter run -d chrome`) since nothing here is platform-specific.

## How the conversion math works

- **Linear categories** (Length, Mass, Volume, Area, Time, Speed, Digital
  Storage): every unit stores a factor relative to one base unit (e.g.
  meters for Length). Converting is `value * fromFactor / toFactor`.
- **Temperature** is handled separately with the actual Celsius/Fahrenheit/
  Kelvin formulas, since it's not a simple multiplier.

All factors are in `lib/data/unit_data.dart` — add a new unit to an existing
category by adding one line, or add a whole new category by adding another
`ConversionCategory` to the list.

## Extending it

- **More categories**: pressure, energy, fuel economy — same pattern as the
  existing linear categories.
- **Persist last-used category/units**: add `shared_preferences` and save on
  change, restore in `initState`.
- **Copy/share result**: add a `Clipboard.setData` call on the result card.
- **History**: keep a rolling list of past conversions in state (or persist
  it) and show it below the result.
