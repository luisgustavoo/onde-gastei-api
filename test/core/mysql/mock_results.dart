import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';

import 'mock_result_row.dart';

class MockResults extends Mock implements Results {
  MockResults([String? json, List<String>? blobFields]) {
    if (json != null) {
      final dynamic data = jsonDecode(json);
      if (data is List) {
        _rows.addAll(
          data
              .map(
                (dynamic f) =>
                    MockResultRow(f as Map<String, dynamic>, blobFields),
              )
              .toList(),
        );
      } else {
        _rows.add(MockResultRow(data as Map<String, dynamic>, blobFields));
      }
    }
  }

  final _rows = <ResultRow>[];

  @override
  Iterator<ResultRow> get iterator => _rows.iterator;

  @override
  bool get isEmpty => !iterator.moveNext();

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  Iterable<T> map<T>(
    T Function(ResultRow e) toElement,
  ) sync* {
    for (final value in this) {
      yield toElement(value);
    }
  }

  @override
  ResultRow get first {
    final it = iterator;
    if (!it.moveNext()) {
      throw Exception();
    }

    return it.current;
  }
}
