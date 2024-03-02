import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:terra_defender/terra_defender.dart';

class Typewriter extends TextComponent with HasGameRef<TerraDefender> {
  late double countdownTime; // The duration of the countdown in seconds.
  late Duration typingSpeed;
  late Duration destroyAfterDuration;
  late String textToType;
  late String currentText = "";
  bool destroyOnTypeCompleted;

  Typewriter(
      {this.textToType = "Alphabetical",
      position,
      this.typingSpeed = const Duration(milliseconds: 100),
      this.destroyAfterDuration = const Duration(seconds: 2),
      this.destroyOnTypeCompleted = false,})
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
  void render(Canvas canvas) {
  // Define the dimensions of the dialog
  final rect = Rect.fromLTWH(-15, -15, size.x + 30, size.y + 35);
  
  // Define the paint for the background (black)
  final backgroundPaint = Paint()..color = Colors.brown;
  
  // Define the paint for the outline (brown)
  final outlinePaint = Paint()..color = Colors.brown;
  
  // Define the paint for the blue center
  final bluePaint = Paint()..color = Colors.blue;
  
  // Draw the background
  canvas.drawRect(rect, backgroundPaint);
  
  // Calculate dimensions for the inner rectangle (blue center)
  final innerRect = Rect.fromLTWH(rect.left + 10, rect.top + 10, rect.width - 20, rect.height - 20);
  
  // Draw the outline (brown)
  canvas.drawRect(innerRect, outlinePaint);
  
  // Draw the blue center
  canvas.drawRect(innerRect, bluePaint);
    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(200);

    priority = 11;

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
      
      await Future.delayed(destroyAfterDuration);

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
