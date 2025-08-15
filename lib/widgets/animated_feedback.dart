import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AnimatedFeedback extends StatefulWidget {
  final bool trigger;

  const AnimatedFeedback({super.key, required this.trigger});

  @override
  State<AnimatedFeedback> createState() => _AnimatedFeedbackState();
}

class _AnimatedFeedbackState extends State<AnimatedFeedback> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void didUpdateWidget(covariant AnimatedFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger == true && widget.trigger != oldWidget.trigger) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _controller,
      blastDirectionality: BlastDirectionality.explosive,
      emissionFrequency: 0.2,
      numberOfParticles: 25,
      maxBlastForce: 20,
      minBlastForce: 5,
      gravity: 0.4,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.pink
      ],
      createParticlePath: (size) {
        // Fun star shape particles
        final path = Path();
        final starPoints = 5;
        final outerRadius = size.width / 2;
        final innerRadius = outerRadius / 2.5;
        final step = pi / starPoints;
        double rotation = pi / 2 * 3;

        path.moveTo(size.width / 2, size.height / 2 - outerRadius);

        for (int i = 0; i < starPoints; i++) {
          path.lineTo(size.width / 2 + cos(rotation) * outerRadius,
              size.height / 2 + sin(rotation) * outerRadius);
          rotation += step;

          path.lineTo(size.width / 2 + cos(rotation) * innerRadius,
              size.height / 2 + sin(rotation) * innerRadius);
          rotation += step;
        }
        path.close();
        return path;
      },
    );
  }
}
