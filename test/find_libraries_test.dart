library source_gen.test.find_libraries;

import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:path/path.dart' as p;
import 'package:unittest/unittest.dart';
import 'package:source_gen/src/utils.dart';

import 'test_utils.dart';

void main() {
  group('check source files against expected libraries', () {
    AnalysisContext context;

    setUp(() async {
      if (context == null) {
        context = await getAnalysisContextForProjectPath(getPackagePath(),
            librarySearchPaths: [
          p.join(getPackagePath(), 'test', 'test_files')
        ]);
      }
    });

    _testFileMap.forEach((inputPath, expectedLibPath) {
      test(inputPath, () {
        var fullInputPath = _testFilePath(inputPath);

        var libElement = getLibraryElementForSourceFile(context, fullInputPath);

        var libSource = libElement.source as FileBasedSource;

        var fullLibPath = _testFilePath(expectedLibPath);

        expect(p.fromUri(libSource.uri), fullLibPath);
      });
    });
  });
}

String _testFilePath(String name) =>
    p.join(getPackagePath(), 'test', 'test_files', name);

const _testFileMap = const {
  'annotated_classes.dart': 'annotated_classes.dart',
  'annotated_classes_part.dart': 'annotated_classes.dart',
  'annotations.dart': 'annotations.dart',
  'annotation_part.dart': 'annotations.dart',
};