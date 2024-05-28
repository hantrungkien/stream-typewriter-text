import 'package:flutter/material.dart';
import 'package:stream_typewriter_text/src/animated_text_kit/animated_text.dart';
import 'package:stream_typewriter_text/src/animated_text_kit/typewriter.dart';

class StreamTypewriterAnimatedText extends StatefulWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final Duration speed;
  final Curve curve;
  final String cursor;
  final bool isRepeatingAnimation;
  final bool repeatForever;
  final int totalRepeatCount;
  final VoidCallback? onFinished;

  const StreamTypewriterAnimatedText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.cursor = '_',
    this.isRepeatingAnimation = false,
    this.totalRepeatCount = 3,
    this.repeatForever = false,
    this.onFinished,
  });

  @override
  State<StreamTypewriterAnimatedText> createState() =>
      _StreamTypewriterAnimatedTextState();
}

class _StreamTypewriterAnimatedTextState
    extends State<StreamTypewriterAnimatedText> {
  Widget? _child;
  MMTypewriterAnimatedText? _typewriterAnimatedText;
  int _lengthAlreadyShown = 0;
  bool _didExceedMaxLines = false;

  @override
  void didUpdateWidget(covariant StreamTypewriterAnimatedText oldWidget) {
    final typewriterAnimatedText = _typewriterAnimatedText;
    if (widget.text != oldWidget.text) {
      _didExceedMaxLines = false;
      _lengthAlreadyShown = typewriterAnimatedText != null &&
              widget.text.startsWith(oldWidget.text)
          ? typewriterAnimatedText.visibleString.length
          : 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maxLines != null) {
      if (_didExceedMaxLines && _child != null) {
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
          textPainter.layout(minWidth: 0, maxWidth: maxWidth);
          _didExceedMaxLines = textPainter.didExceedMaxLines;
          _createNewWidget();
          return _child!;
        },
      );
    } else {
      _createNewWidget();
      return _child!;
    }
  }

  _createNewWidget() {
    _typewriterAnimatedText = MMTypewriterAnimatedText(
      widget.text,
      textAlign: widget.textAlign,
      textStyle: widget.style,
      lengthAlreadyShown: _lengthAlreadyShown,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      speed: widget.speed,
      curve: widget.curve,
      cursor: widget.cursor,
    );
    _child = AnimatedTextKit(
      key: ValueKey(widget.text.hashCode),
      isRepeatingAnimation: widget.isRepeatingAnimation,
      totalRepeatCount: widget.totalRepeatCount,
      repeatForever: widget.repeatForever,
      onFinished: widget.onFinished,
      animatedTexts: [_typewriterAnimatedText!],
    );
  }
}
