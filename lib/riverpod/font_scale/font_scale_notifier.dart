import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

part 'font_scale_notifier.g.dart';

/// Default text-scale code used when the user has not chosen one.
const String fontScaleNormal = 'normal';

/// Ordered list of the supported text-scale codes (smallest → largest), used
/// to build the font-size picker.
const List<String> fontScaleCodes = ['small', 'normal', 'large', 'xlarge'];

/// Maps each text-scale code to its [TextScaler] multiplier.
const Map<String, double> _fontScaleValues = {
  'small': 0.85,
  'normal': 1.0,
  'large': 1.15,
  'xlarge': 1.3,
};

/// Returns the numeric scale multiplier for [code] (defaults to 1.0).
double fontScaleValueOf(String code) => _fontScaleValues[code] ?? 1.0;

/// Riverpod notifier holding the user's text-size preference as a scale code.
///
/// `App` (in `main.dart`) watches this and wraps the app in a [MediaQuery]
/// whose `textScaler` uses [fontScaleValueOf], so all text honours the choice.
/// The game tiles use a `FittedBox`, so larger scales never overflow the grid.
@riverpod
class FontScaleNotifier extends _$FontScaleNotifier {
  @override
  String build() {
    return SharedPreferenceService()
            .getString(SharedPreferencesKeys.fontScale) ??
        fontScaleNormal;
  }

  /// Persists [code] and updates the active text scale.
  void setScale(String code) {
    SharedPreferenceService().setString(SharedPreferencesKeys.fontScale, code);
    state = code;
  }
}
