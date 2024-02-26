import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:terra_defender/terra_defender.dart';

class Typewriter extends TextComponent with HasGameRef<TerraDefender> {
  late double countdownTime; // The duration of the countdown in seconds.
  late Duration typingSpeed = const Duration(milliseconds: 100);
  late String textToType;
  late String currentText = "";
  bool destroyOnTypeCompleted;

  Typewriter(
      {this.textToType = "Alphabetical",
      position,
      this.destroyOnTypeCompleted = false})
      : super(
          text: "Muahahahahahaha",
          textRenderer: TextPaint(
              style: const TextStyle(
                  fontSize: 48.0, color: Color.fromARGB(255, 251, 0, 184))),
          position: position, // Position where the countdown will be displayed.
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    text = currentText;

    //  countdown(dt);

    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(200);

    typeText(textToType, typingSpeed);

    return super.onLoad();
  }

  Future<void> typeText(String newtext, Duration delay) async {
    for (int i = 0; i < newtext.length; i++) {
      currentText += newtext[i];

      await Future.delayed(delay);

      // game.logger.d(currentText);
    }

    if (destroyOnTypeCompleted) {
      
      await Future.delayed(const Duration(seconds: 2));

      removeFromParent();
    }
  }

  void countdown(dt) {
    if (countdownTime > 0) {
      countdownTime -= dt;
      text = countdownTime.toInt().toString();
    } else {
      text = 'Go!'; // Display 'Go!' when the countdown finishes.
    }
  }
}
