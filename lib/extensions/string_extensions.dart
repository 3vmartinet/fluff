import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

extension StringExtensions on String {
  Widget typewriter({
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration speed = const Duration(milliseconds: 40),
    Curve curve = Curves.linear,
    int repeatCount = 0,
  }) {
    return AnimatedTextKit(
      isRepeatingAnimation: repeatCount > 0,
      totalRepeatCount: repeatCount,
      animatedTexts: [
        TyperAnimatedText(
          this,
          curve: curve,
          speed: speed,
          textAlign: textAlign,
          textStyle: textStyle,
        ),
      ],
    );
  }
}
