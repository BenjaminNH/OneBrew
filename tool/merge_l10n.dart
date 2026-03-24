import 'dart:convert';
import 'dart:io';

const _fragmentsDir = 'lib/l10n/fragments';
const _outputDir = 'lib/l10n';

const Map<String, String> _localeFileNames = {
  'en': 'app_en.arb',
  'zh_Hans': 'app_zh_Hans.arb',
};

void main() {
  final fragmentsDirectory = Directory(_fragmentsDir);
  if (!fragmentsDirectory.existsSync()) {
    stderr.writeln('Missing fragments directory: $_fragmentsDir');
    exitCode = 1;
    return;
  }

  final mergedByLocale = <String, Map<String, Object?>>{};
  for (final locale in _localeFileNames.keys) {
    mergedByLocale[locale] = <String, Object?>{'@@locale': locale};
  }

  final files = fragmentsDirectory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final locale = _localeFileNames.keys.firstWhere(
      (candidate) => name.endsWith('_$candidate.json'),
      orElse: () => '',
    );
    if (locale.isEmpty) {
      stderr.writeln('Skipping unsupported fragment file: $name');
      continue;
    }

    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      stderr.writeln('Fragment must be a JSON object: $name');
      exitCode = 1;
      return;
    }

    final target = mergedByLocale[locale]!;
    for (final entry in decoded.entries) {
      if (target.containsKey(entry.key)) {
        stderr.writeln('Duplicate l10n key "${entry.key}" in $name');
        exitCode = 1;
        return;
      }
      target[entry.key] = entry.value;
    }
  }

  final encoder = const JsonEncoder.withIndent('  ');
  for (final entry in mergedByLocale.entries) {
    final outputPath = '$_outputDir/${_localeFileNames[entry.key]!}';
    final ordered = _ordered(entry.value);
    File(outputPath).writeAsStringSync('${encoder.convert(ordered)}\n');
    stdout.writeln('Wrote $outputPath');
  }

  final zhHans = mergedByLocale['zh_Hans'];
  if (zhHans != null) {
    final zhFallback = Map<String, Object?>.from(zhHans);
    zhFallback['@@locale'] = 'zh';
    final outputPath = '$_outputDir/app_zh.arb';
    File(outputPath).writeAsStringSync(
      '${encoder.convert(_ordered(zhFallback))}\n',
    );
    stdout.writeln('Wrote $outputPath');
  }
}

Map<String, Object?> _ordered(Map<String, Object?> source) {
  final ordered = <String, Object?>{'@@locale': source['@@locale']};

  final valueKeys = source.keys
      .where((key) => key != '@@locale' && !key.startsWith('@'))
      .toList()
    ..sort();

  for (final key in valueKeys) {
    ordered[key] = source[key];
    final metadataKey = '@$key';
    final metadata = source[metadataKey];
    if (metadata != null) {
      ordered[metadataKey] = metadata;
    }
  }

  final extraMetadataKeys = source.keys
      .where((key) => key.startsWith('@') && key != '@@locale')
      .where((key) => !ordered.containsKey(key))
      .toList()
    ..sort();

  for (final key in extraMetadataKeys) {
    ordered[key] = source[key];
  }

  return ordered;
}
