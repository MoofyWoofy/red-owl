import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyRepeatEvent, KeyUpEvent, ServicesBinding;
import 'package:red_owl/routes/game/widgets/shared.dart' show Letter, WordleRow;

class WordlePage extends ConsumerStatefulWidget {
  const WordlePage({super.key, required this.gameType});
  final String gameType;

  @override
  ConsumerState<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends ConsumerState<WordlePage> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      // print("Key down: $key");
    } else if (event is KeyUpEvent) {
      // print("Key up: $key");
    } else if (event is KeyRepeatEvent) {
      // print("Key repeat: $key");
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.gameType} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              WordleRow(),
              WordleRow(),
              WordleRow(),
              WordleRow(),
              WordleRow(),
              WordleRow(),
            ],
          ),

          // keyboard + keyboard listen for desktop

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Letter(letter: 'Q')),
                  Expanded(child: Letter(letter: 'W')),
                  Expanded(child: Letter(letter: 'E')),
                  Expanded(child: Letter(letter: 'R')),
                  Expanded(child: Letter(letter: 'T')),
                  Expanded(child: Letter(letter: 'Y')),
                  Expanded(child: Letter(letter: 'U')),
                  Expanded(child: Letter(letter: 'I')),
                  Expanded(child: Letter(letter: 'O')),
                  Expanded(child: Letter(letter: 'P')),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 1),
                  Expanded(flex: 2, child: Letter(letter: 'A')),
                  Expanded(flex: 2, child: Letter(letter: 'S')),
                  Expanded(flex: 2, child: Letter(letter: 'D')),
                  Expanded(flex: 2, child: Letter(letter: 'F')),
                  Expanded(flex: 2, child: Letter(letter: 'G')),
                  Expanded(flex: 2, child: Letter(letter: 'H')),
                  Expanded(flex: 2, child: Letter(letter: 'J')),
                  Expanded(flex: 2, child: Letter(letter: 'K')),
                  Expanded(flex: 2, child: Letter(letter: 'L')),
                  Spacer(flex: 1),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Letter(
                      letter: "ENTER",
                      icon: Icons.keyboard_return,
                    ),
                  ),
                  Expanded(child: Letter(letter: 'Z')),
                  Expanded(child: Letter(letter: 'X')),
                  Expanded(child: Letter(letter: 'C')),
                  Expanded(child: Letter(letter: 'V')),
                  Expanded(child: Letter(letter: 'B')),
                  Expanded(child: Letter(letter: 'N')),
                  Expanded(child: Letter(letter: 'M')),
                  Expanded(
                    flex: 2,
                    child: Letter(
                      icon: Icons.backspace,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
