import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_typewriter_text/stream_typewriter_text.dart';
import 'package:stream_typewriter_text_example/bubble_painter.dart';

const loremText = """
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,
""";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _streamController = BehaviorSubject<String>.seeded("...");

  bool _canTap = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Stream Typewriter Text',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                painter: const BubblePainter(color: Colors.white),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    minWidth: 96,
                    maxWidth: MediaQuery.sizeOf(context).width - 48,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: StreamBuilder(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        final text = snapshot.data ?? '';
                        return StreamTypewriterAnimatedText(
                          text: text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          isHapticFeedbackEnabled: true,
                          speed: const Duration(milliseconds: 30),
                          pause: const Duration(milliseconds: 100),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_canTap) {
                    _canTap = false;
                    _streamController.add("Thinking...");
                    await Future.delayed(const Duration(milliseconds: 1000));
                    var count = 0;
                    await Future.doWhile(() async {
                      count += 10;
                      if (count > loremText.length) {
                        return false;
                      }
                      _streamController.add(loremText.substring(0, count));
                      await Future.delayed(const Duration(milliseconds: 100));
                      return true;
                    });
                    _canTap = true;
                  }
                },
                child: const Text('Start Stream'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
