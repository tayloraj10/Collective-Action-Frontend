// ignore_for_file: avoid_print
// Run from project root: dart run scripts/version.dart [generate|bump patch|bump build|bump minor|bump major]

import 'dart:io';

void main(List<String> args) {
  final projectRoot = _findProjectRoot();
  if (projectRoot == null) {
    print(
      'Error: Could not find project root (pubspec.yaml). Run from project root.',
    );
    exit(1);
  }

  final pubspec = File('${projectRoot.path}/pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    exit(1);
  }

  final action = args.isEmpty ? 'generate' : args[0].toLowerCase();
  final bumpType = args.length > 1 ? args[1].toLowerCase() : null;

  if (action == 'generate') {
    _generate(projectRoot, pubspec);
    return;
  }

  if (action == 'bump') {
    if (bumpType == null ||
        !['patch', 'build', 'minor', 'major'].contains(bumpType)) {
      print(
        'Usage: dart run scripts/version.dart bump <patch|build|minor|major>',
      );
      exit(1);
    }
    _bump(projectRoot, pubspec, bumpType);
    return;
  }

  print('Usage: dart run scripts/version.dart [generate]');
  print('       dart run scripts/version.dart bump <patch|build|minor|major>');
  exit(1);
}

Directory? _findProjectRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 5; i++) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
    dir = dir.parent;
  }
  return null;
}

final _versionRegex = RegExp(
  r'^version:\s*(\d+)\.(\d+)\.(\d+)(?:\+(\d+))?\s*$',
  multiLine: true,
);

({String semver, int major, int minor, int patch, int build}) _parseVersion(
  File pubspec,
) {
  final lines = pubspec.readAsStringSync().split('\n');
  for (final line in lines) {
    final match = _versionRegex.firstMatch(line);
    if (match != null) {
      final major = int.parse(match[1]!);
      final minor = int.parse(match[2]!);
      final patch = int.parse(match[3]!);
      final build = match[4] != null ? int.parse(match[4]!) : 1;
      return (
        semver: '$major.$minor.$patch',
        major: major,
        minor: minor,
        patch: patch,
        build: build,
      );
    }
  }
  throw StateError('Could not find version: line in pubspec.yaml');
}

void _generate(Directory projectRoot, File pubspec) {
  final v = _parseVersion(pubspec);
  final outPath = '${projectRoot.path}/lib/app/version.g.dart';
  final content =
      '''// GENERATED from pubspec.yaml - do not edit.
// Regenerate with: dart run scripts/version.dart generate

const String appVersion = '${v.semver}';
''';
  File(outPath).writeAsStringSync(content);
  print('Wrote $outPath with version ${v.semver}');
}

void _bump(Directory projectRoot, File pubspec, String bumpType) {
  final v = _parseVersion(pubspec);
  var major = v.major, minor = v.minor, patch = v.patch, build = v.build;

  switch (bumpType) {
    case 'major':
      major++;
      minor = 0;
      patch = 0;
      break;
    case 'minor':
      minor++;
      patch = 0;
      break;
    case 'patch':
      patch++;
      break;
    case 'build':
      build++;
      break;
  }

  final newVersion = '$major.$minor.$patch+$build';
  final content = pubspec.readAsStringSync();
  final newContent = content.replaceFirst(
    _versionRegex,
    'version: $newVersion\n',
  );
  if (newContent == content) {
    print('Error: Could not replace version line in pubspec.yaml');
    exit(1);
  }
  pubspec.writeAsStringSync(newContent);
  print('Bumped pubspec.yaml to $newVersion');
  _generate(projectRoot, pubspec);
}
