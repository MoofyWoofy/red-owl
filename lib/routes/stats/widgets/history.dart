import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show BoolFamilyProviderIDs, SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart' show boolFamilyNotifierProvider;
import 'package:red_owl/util/shared.dart' show dateToString;

class History extends ConsumerWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(boolFamilyNotifierProvider(
      id: BoolFamilyProviderIDs.isDarkMode,
      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
    ));

    return ListView.separated(
      itemCount: 25,
      separatorBuilder: (BuildContext context, int index) =>
          // const Divider(indent: 40, endIndent: 40),
          const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              //* Testing colors
              color: index % 2 == 1
                  ? (isDarkMode
                      ? const Color.fromRGBO(0, 76, 48, 1)
                      : const Color.fromRGBO(72, 199, 142, 1))
                  : (isDarkMode
                      ? const Color.fromRGBO(101, 10, 30, 1)
                      : const Color.fromRGBO(255, 82, 113, 1)),
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateToString(DateTime.now()),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'item $index',
                style: const TextStyle(
                  fontSize: 20,
                  // color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
