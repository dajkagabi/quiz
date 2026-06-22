import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  // Kezdőlap
  const WelcomeScreen({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Spacer(),

          Container(
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.amber.withOpacity(.12),

              border: Border.all(
                color: Colors.amber.withOpacity(.25),
                width: 2,
              ),
            ),

            child: const Icon(
              Icons.graphic_eq,
              size: 80,
              color: Colors.amber,
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            'Magyar Rock Kvíz',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Teszteld a tudásod a magyar rock legendáiról.',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 60,

            child: ElevatedButton(
              onPressed: onStart,

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              child: const Text(
                'Kvíz indítása',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
