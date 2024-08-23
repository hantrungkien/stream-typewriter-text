import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Animated Text that displays a [Text] element as if it is being typed one
/// character at a time. Similar to [TypeAnimatedText], but shows a cursor.
///
/// ![Typewriter example](https://raw.githubusercontent.com/aagarwal1012/Animated-Text-Kit/master/display/typewriter.gif)
class TypewriterAnimatedText extends AnimatedText {
  // The text length is padded to cause extra cursor blinking after typing.
  static const extraLengthForBlinks = 8;

  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 30 milliseconds.
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  /// Cursor text. Defaults to underscore.
  final String cursor;

  /// @author: klever - BLOKPARTi
  final int? maxLines;
  final TextOverflow overflow;
  final int lengthAlreadyShown;
  String _visibleString = '';
  final bool isHapticFeedbackEnabled;

  String get visibleString => _visibleString;

  TypewriterAnimatedText(
      String text, {
        super.textAlign,
        super.textStyle,
        this.lengthAlreadyShown = 0,
        this.speed = const Duration(milliseconds: 30),
        this.curve = Curves.linear,
        this.maxLines,
        this.overflow = TextOverflow.clip,
        this.cursor = '_',
        this.isHapticFeedbackEnabled = false,
      }) : super(
    text: text,
    duration: speed * (text.characters.length + extraLengthForBlinks),
  );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed *
          (textCharacters.length + extraLengthForBlinks - _typewriterText.value);

  var prevValue = 0.0;

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);

    _typewriterText.addListener(() {
      final currentValue = _typewriterText.value;
      if (currentValue - prevValue >= 0.035) {
        prevValue = currentValue;
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  Widget completeText(BuildContext context) => RichText(
    text: TextSpan(
      children: [
        TextSpan(text: text),
        TextSpan(
          text: cursor,
          style: const TextStyle(color: Colors.transparent),
        ),
      ],
      style: DefaultTextStyle.of(context).style.merge(textStyle),
    ),
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
  );

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final textLen = textCharacters.length;
    final typewriterValue = (_typewriterText.value.clamp(0, 1) *
        (textCharacters.length + extraLengthForBlinks))
        .round();

    var showCursor = true;
    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString =
      lengthAlreadyShown == 0 ? '' : text.substring(0, lengthAlreadyShown);
      showCursor = false;
    } else if (typewriterValue > textLen) {
      showCursor = (typewriterValue - textLen) % 2 == 0;
    } else {
      visibleString =
          textCharacters.take(typewriterValue + lengthAlreadyShown).toString();
      _visibleString = visibleString;
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: visibleString),
          TextSpan(
            text: cursor,
            style:
            showCursor ? null : const TextStyle(color: Colors.transparent),
          ),
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
