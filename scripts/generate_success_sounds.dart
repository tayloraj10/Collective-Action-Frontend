// ignore_for_file: avoid_print
// Run from project root: dart run scripts/generate_success_sounds.dart
// Run this after adding new .mp3 files to assets/sounds/ so they are included as success sounds.

import 'dart:io';

void main() {
  final soundsDir = Directory('assets/sounds');
  if (!soundsDir.existsSync()) {
    print('assets/sounds/ not found. Run from project root.');
    exit(1);
  }

  final paths = soundsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.mp3'))
      .map((f) => 'assets/sounds/${f.uri.pathSegments.last}')
      .toList()
    ..sort();

  if (paths.isEmpty) {
    print('No .mp3 files found in assets/sounds/');
    exit(1);
  }

  final outPath = 'lib/app/success_sounds.g.dart';
  final content = '''// GENERATED - do not edit.
// Run: dart run scripts/generate_success_sounds.dart (after adding sounds to assets/sounds/)

const List<String> successSoundPaths = <String>[
${paths.map((p) => "  '$p',").join('\n')}
];
''';

  File(outPath).writeAsStringSync(content);
  print('Wrote ${paths.length} success sound paths to $outPath');
}
