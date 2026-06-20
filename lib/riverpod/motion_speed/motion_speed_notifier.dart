import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

part 'motion_speed_notifier.g.dart';

/// Default motion-speed code used when the user has not chosen one.
const String motionSpeedNormal = 'normal';

/// Motion-speed code that effectively removes animations (used both as an
/// explicit user choice and as the value forced when the operating system
/// requests reduced motion).
const String motionSpeedReduced = 'reduced';

/// Ordered list of supported motion-speed codes (least → most motion), used to
/// build the animation-speed picker.
const List<String> motionSpeedCodes = ['reduced', 'fast', 'normal', 'slow'];

/// Maps each motion-speed code to a global `timeDilation` factor. Values below
/// 1.0 speed animations up; above 1.0 slow them down. `'reduced'` uses a tiny
/// factor so every animation snaps to its end almost instantly.
const Map<String, double> _motionDilation = {
  'reduced': 0.02,
  'fast': 0.5,
  'normal': 1.0,
  'slow': 1.8,
};

/// Returns the `timeDilation` factor for [code] (defaults to 1.0).
double motionDilationOf(String code) => _motionDilation[code] ?? 1.0;

/// Riverpod notifier holding the user's animation-speed preference.
///
/// `App` (in `main.dart`) watches this together with the system
/// "remove animations" accessibility flag and assigns the resulting factor to
/// the global `timeDilation`, so every [AnimationController]-driven animation
/// (tile flips, shakes, page transitions) is sped up, slowed down, or snapped.
@riverpod
class MotionSpeedNotifier extends _$MotionSpeedNotifier {
  @override
  String build() {
    return SharedPreferenceService()
            .getString(SharedPreferencesKeys.motionSpeed) ??
        motionSpeedNormal;
  }

  /// Persists [code] and updates the active motion speed.
  void setSpeed(String code) {
    SharedPreferenceService().setString(SharedPreferencesKeys.motionSpeed, code);
    state = code;
  }
}
