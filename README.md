<h1 align="center">Stream Typewriter Text</h1>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="https://pub.dartlang.org/packages/stream_typewriter_text">
    <img src="https://img.shields.io/pub/v/stream_typewriter_text.svg"
      alt="Pub Package" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/hantrungkien/stream-typewriter-text"
      alt="License: MIT" />
  </a>
  <br>
</p><br>

https://github.com/hantrungkien/stream-typewriter-text/assets/20286370/35f74fb9-8f26-4853-8453-ccab693ed804

# Installing

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  stream_typewriter_text: ^1.0.0
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```
$ pub get
```

with `Flutter`:

```
$ flutter pub get
```

### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:stream_typewriter_text/stream_typewriter_text.dart';
```

# Usage

`StreamTypewriterAnimatedText` is a _Stateful Widget_ that produces text animations.
Include it in your `build` method like:

```dart
              StreamBuilder(
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
                  );
                },
              )
```
