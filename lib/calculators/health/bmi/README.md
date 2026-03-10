# BMI Calculator Module

## Description

The BMI (Body Mass Index) Calculator is a health calculator module that allows users to calculate their BMI based on their height and weight.

## Features

- Simple and intuitive interface
- Enter height in meters
- Enter weight in kilograms
- Automatic BMI calculation
- Localized in 4 languages: English, French, Spanish, and Italian
- Responsive design for mobile and desktop

## BMI Categories

- **Underweight**: BMI < 18.5
- **Normal weight**: 18.5 ≤ BMI < 25
- **Overweight**: 25 ≤ BMI < 30
- **Obese**: BMI ≥ 30

## File Structure

```
lib/calculators/health/bmi/
├── models/
│   └── bmi_state.dart           # BMI state data model
├── controllers/
│   └── bmi_controller.dart      # BMI logic controller
├── services/
│   └── bmi_logic.dart           # BMI calculation logic
└── screens/
    └── bmi_screen.dart          # BMI user interface
```

## How to Use

1. Open the burger menu in the calculator
2. Select "BMI Calculator" (or localized equivalent)
3. Enter your height in meters (e.g., 1.75)
4. Press the "Enter" button
5. Enter your weight in kilograms (e.g., 70)
6. Press the "Enter" button
7. Your BMI is displayed with the result

## Keyboard Layout

The BMI calculator uses a simplified keyboard layout with:
- Number buttons (0-9)
- Decimal separator (locale-dependent)
- C button (clear all)
- Backspace button (⌫)
- Large Enter button on the right side

## Implementation Details

- Uses `Decimal` for precise calculations
- Follows the same theme system as the basic calculator
- Shares the same photo background and menu system
- Fully localized prompts and messages

## Navigation

Access the BMI calculator from the main calculator screen:
- Tap the burger menu (☰) in the top-left corner
- Select "BMI Calculator" from the menu
- Use the back button to return to the main calculator

## Localization Files

BMI-specific translations are marked with `@_BMI_CALCULATOR` in the `.arb` files:
- `lib/l10n/app_en.arb` - English
- `lib/l10n/app_fr.arb` - French
- `lib/l10n/app_es.arb` - Spanish
- `lib/l10n/app_it.arb` - Italian

