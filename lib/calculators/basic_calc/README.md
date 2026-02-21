# Basic Calculator - Architecture

## File Structure

```
lib/calculators/basic_calc/
├── controllers/
│   └── calculator_controller.dart    # Calculator logic
├── models/
│   └── calculator_state.dart         # Calculator state
├── screens/
│   ├── calculator_screen.dart        # Main UI (simplified)
│   ├── menu_drawer.dart              # Burger menu (Themes, Who am I, Donate)
│   └── theme/
│       ├── theme_manager.dart        # Theme state management
│       └── theme_dialog.dart         # Theme selection dialog
└── services/
    └── calculator_logic.dart         # Calculation logic

```

## Separation of Concerns

### 1. **calculator_screen.dart** (~150 lines)
- **Single responsibility**: Display the main interface
- Very simple and easy to maintain
- Delegates logic to controllers and managers

### 2. **theme_manager.dart**
- **Responsibility**: Manage theme state (background and button colors)
- Uses `ChangeNotifier` to notify changes
- Reusable across other calculators

### 3. **theme_dialog.dart**
- **Responsibility**: Display the theme selection dialog
- Encapsulated `_ColorOption` and `_ButtonGroupColorOption` widgets
- Easy to test and modify

### 4. **menu_drawer.dart**
- **Responsibility**: Burger menu with options (Themes, Who am I, Donate)
- Handles all dialog displays
- Can be easily extended with new options

## Architecture Benefits

✅ **Maintainability**: Each file has a clear responsibility  
✅ **Reusability**: ThemeManager can be shared across calculators  
✅ **Testability**: Each component can be tested in isolation  
✅ **Readability**: Shorter and easier to understand code  
✅ **Extensibility**: Easy to add new features

## Usage

### Changing themes programmatically

```dart
final themeManager = ThemeManager();

// Change background color
themeManager.setBackgroundColor(Colors.grey[900]!);

// Change button color
themeManager.setButtonGroupColor(Colors.blue[800]!);

// Listen to changes
themeManager.addListener(() {
  print('Theme changed!');
});
```

### Adding a new menu option

Edit `menu_drawer.dart`:

```dart
const PopupMenuItem<String>(
  value: 'new_option',
  child: Text('New Option'),
),
```

Then handle the callback:

```dart
else if (value == 'new_option') {
  _showNewOptionDialog(context);
}
```

