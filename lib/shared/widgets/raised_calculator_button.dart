// lib/shared/widgets/raised_calculator_button.dart

import 'package:flutter/material.dart';
import 'package:calculators/shared/theme/theme_manager.dart';

/// Physical-looking calculator key with bevel + soft body shadow.
class RaisedCalculatorButton extends StatefulWidget {
  const RaisedCalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.themeManager,
    required this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    this.borderRadius = 10,
    this.fontSize = 20,
    this.enabled = true,
    this.compact = false,
    this.maxLines = 1,
    this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final ThemeManager themeManager;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final bool enabled;
  final bool compact;
  final int maxLines;
  final Widget? child;

  @override
  State<RaisedCalculatorButton> createState() => _RaisedCalculatorButtonState();
}

class _RaisedCalculatorButtonState extends State<RaisedCalculatorButton> {
  bool _pressed = false;

  bool get _isThreeD => widget.themeManager.isThreeDButtonStyle;
  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_isEnabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final Color base = widget.backgroundColor;
    final Color textColor = widget.themeManager.buttonTextColor;
    final double radius = widget.borderRadius;
    final double lift = _isThreeD ? (widget.compact ? 2.5 : 3.5) : 0;
    final double pressedOffset = _pressed ? lift : 0;

    final Color faceTop = _isThreeD ? Color.alphaBlend(Colors.white.withAlpha(58), base) : base;
    final Color faceMid = base;
    final Color faceBottom = _isThreeD ? Color.alphaBlend(Colors.black.withAlpha(28), base) : base;

    final Color rimTop = Color.alphaBlend(Colors.white.withAlpha(95), base);
    final Color rimBottom = Color.alphaBlend(Colors.black.withAlpha(95), base);
    final Color rimSide = Color.alphaBlend(Colors.black.withAlpha(35), base);

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.label,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) {
              _setPressed(false);
              if (_isEnabled) widget.onPressed?.call();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 70),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, pressedOffset, 0),
              child: Stack(
                children: [
                  // Drop shadow / pedestal
                  if (_isThreeD)
                    Positioned(
                      left: 1.2,
                      right: 1.2,
                      top: lift + 0.5,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          color: Colors.black.withAlpha(_pressed ? 70 : 120),
                        ),
                      ),
                    ),

                  // Bevel rim (light top / dark bottom)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: lift,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        gradient: _isThreeD
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [rimTop, rimSide, rimBottom],
                                stops: const [0.0, 0.55, 1.0],
                              )
                            : null,
                        color: _isThreeD ? null : Colors.grey[300],
                        boxShadow: _isThreeD
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                      ),
                    ),
                  ),

                  // Inner face
                  Positioned(
                    left: _isThreeD ? 1.6 : 1,
                    right: _isThreeD ? 1.6 : 1,
                    top: _isThreeD ? 1.4 : 1,
                    bottom: lift + (_isThreeD ? 1.8 : 1),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius - 1.2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _pressed
                              ? [
                                  Color.alphaBlend(Colors.black.withAlpha(18), faceMid),
                                  Color.alphaBlend(Colors.black.withAlpha(28), faceBottom),
                                ]
                              : [faceTop, faceMid, faceBottom],
                          stops: _pressed ? const [0.0, 1.0] : const [0.0, 0.48, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: widget.padding,
                        child: Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(
                                                    color: textColor.withAlpha(_isEnabled ? 255 : 140),
                                                    fontSize: widget.fontSize,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.0,
                                                  ),
                                                  child: IconTheme(
                                                    data: IconThemeData(
                                                      color: textColor.withAlpha(_isEnabled ? 255 : 140),
                                                      size: widget.fontSize + 2,
                                                    ),
                                                    child: widget.child ??
                                                        FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            widget.label,
                                                            maxLines: widget.maxLines,
                                                            softWrap: false,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: textColor.withAlpha(_isEnabled ? 255 : 140),
                                                              fontSize: widget.fontSize,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1.0,
                                                              shadows: _isThreeD
                                                                  ? [
                                                                      Shadow(
                                                                        color: Colors.black.withAlpha(40),
                                                                        offset: const Offset(0, 0.8),
                                                                        blurRadius: 0.4,
                                                                      ),
                                                                    ]
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
