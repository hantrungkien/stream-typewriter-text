import 'package:flutter/material.dart';
import 'package:stream_typewriter_text/src/animated_text_kit/animated_text.dart';
import 'package:stream_typewriter_text/src/animated_text_kit/typewriter.dart';

class StreamTypewriterAnimatedText extends StatefulWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final Duration pause;
  final Duration speed;
  final Curve curve;
  final String cursor;
  final bool isRepeatingAnimation;
  final bool repeatForever;
  final int totalRepeatCount;
  final bool isHapticFeedbackEnabled;
  final VoidCallback? onFinished;

  const StreamTypewriterAnimatedText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.speed = const Duration(milliseconds: 30),
    this.pause = const Duration(milliseconds: 1000),
    this.curve = Curves.linear,
    this.cursor = '_',
    this.isRepeatingAnimation = false,
    this.totalRepeatCount = 3,
    this.repeatForever = false,
    this.isHapticFeedbackEnabled = false,
    this.onFinished,
  });

  @override
  State<StreamTypewriterAnimatedText> createState() =>
      StreamTypewriterAnimatedTextState();
}

class StreamTypewriterAnimatedTextState
    extends State<StreamTypewriterAnimatedText> {
  Widget? _child;
  TypewriterAnimatedText? _typewriterAnimatedText;
  int _lengthAlreadyShown = 0;
  bool _didExceedMaxLines = false;

  @override
  void didUpdateWidget(covariant StreamTypewriterAnimatedText oldWidget) {
    final typewriterAnimatedText = _typewriterAnimatedText;
    if (widget.text != oldWidget.text) {
      final startsWithOldText = widget.text.startsWith(oldWidget.text);
      if (_didExceedMaxLines && !startsWithOldText) {
        _didExceedMaxLines = false;
      }
      _lengthAlreadyShown = typewriterAnimatedText != null && startsWithOldText
          ? typewriterAnimatedText.visibleString.length
          : 0;
    }
    if (widget.style != oldWidget.style) {
      _didExceedMaxLines = false;
      _lengthAlreadyShown = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maxLines != null) {
      if (_didExceedMaxLines && _child != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.onFinished?.call();
          }
        });
        return _child!;
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          assert(constraints.hasBoundedWidth);
          final maxWidth = constraints.maxWidth;
          final textPainter = TextPainter(
            text: TextSpan(text: widget.text, style: widget.style),
            textAlign: widget.textAlign,
            textDirection: Directionality.of(context),
            maxLines: widget.maxLines,
            ellipsis: widget.overflow == TextOverflow.ellipsis ? '...' : null,
            locale: Localizations.maybeLocaleOf(context),
          );
          textPainter.layout(
            minWidth: constraints.minWidth,
            maxWidth: maxWidth,
          );
          _didExceedMaxLines = textPainter.didExceedMaxLines;
          if (_didExceedMaxLines) {
            final textSize = textPainter.size;
            final pos = textPainter.getPositionForOffset(
              textSize.bottomRight(Offset.zero),
            );
            _createNewWidget(widget.text.substring(0, pos.offset));
          } else {
            _createNewWidget(widget.text);
          }
          textPainter.dispose();
          return _child!;
        },
      );
    } else {
      _createNewWidget(widget.text);
      return _child!;
    }
  }

  _createNewWidget(String text) {
    _typewriterAnimatedText = TypewriterAnimatedText(
      text,
      textAlign: widget.textAlign,
      textStyle: widget.style,
      lengthAlreadyShown: _lengthAlreadyShown,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      cursor: widget.cursor,
      curve: widget.curve,
      speed: widget.speed,
      isHapticFeedbackEnabled: widget.isHapticFeedbackEnabled,
    );
    final valueKey = ValueKey(text.hashCode + widget.style.hashCode);
    if (_child != null && _child!.key == valueKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onFinished?.call();
        }
      });
    }
    _child = AnimatedTextKit(
      key: valueKey,
      pause: widget.pause,
      isRepeatingAnimation: widget.isRepeatingAnimation,
      animatedTexts: [_typewriterAnimatedText!],
      repeatForever: widget.repeatForever,
      totalRepeatCount: widget.totalRepeatCount,
      onFinished: widget.onFinished,
    );
  }
}
