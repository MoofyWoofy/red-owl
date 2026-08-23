// Unit tests for normalizeCounters, the shared guard for the persisted
// statsData / guessDistribution arrays.
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/util/misc.dart';

void main() {
  group('normalizeCounters', () {
    test('pads a short array to the expected length', () {
      expect(normalizeCounters(['3', '2'], statsDataLength),
          ['3', '2', '0', '0']);
    });

    test('truncates a long array', () {
      expect(normalizeCounters(['1', '2', '3', '4', '5'], statsDataLength),
          ['1', '2', '3', '4']);
    });

    test('replaces null with all zeros', () {
      expect(normalizeCounters(null, statsDataLength), ['0', '0', '0', '0']);
      expect(normalizeCounters(null, guessDistributionLength),
          ['0', '0', '0', '0', '0', '0']);
    });

    test('replaces non-numeric and negative entries with zero', () {
      expect(normalizeCounters(['abc', '-4', '7', ''], statsDataLength),
          ['0', '0', '7', '0']);
    });

    test('leaves a well-formed array untouched', () {
      expect(normalizeCounters(['10', '7', '3', '5'], statsDataLength),
          ['10', '7', '3', '5']);
    });
  });
}
