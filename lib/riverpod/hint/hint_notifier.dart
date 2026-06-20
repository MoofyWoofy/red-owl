import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, dateToString;

part 'hint_notifier.g.dart';

/// Tracks whether today's once-per-day hint is still available.
///
/// The daily game offers a single hint per puzzle. Usage is recorded as the
/// current date in [SharedPreferencesKeys.hintUsedDate]; the hint becomes
/// available again automatically once the date rolls over to a new day.
@riverpod
class HintNotifier extends _$HintNotifier {
  @override
  bool build() {
    final usedDate =
        SharedPreferenceService().getString(SharedPreferencesKeys.hintUsedDate);
    // Available when no hint has been used today.
    return usedDate != dateToString(DateTime.now());
  }

  /// Marks today's hint as consumed so it can't be used again until tomorrow.
  void useHint() {
    SharedPreferenceService().setString(
        SharedPreferencesKeys.hintUsedDate, dateToString(DateTime.now()));
    state = false;
  }
}
