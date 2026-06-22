import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quiz/quiz/cubit/quiz_cubit.dart';
import 'package:quiz/quiz/models/question.dart';

// Válaszlehetőségek listája, UI
class OptionsList extends StatelessWidget {
  const OptionsList({
    required this.question,
    required this.isAnswered,
    required this.selectedOptionIndex,
    super.key,
  });
  final Question question;

  final bool isAnswered;

  final int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        question.options.length,
        (optionIndex) {
          final option = question.options[optionIndex];
          //Színtaxis, változtatások,
          // Ha a kérdésre már válaszoltak, akkor a helyes válasz zöld, a rossz válasz piros lesz
          Color buttonColor = const Color(0xFF1F2332);

          Color textColor = Colors.white;

          Color borderColor = const Color(0xFF2A2F41);

          if (isAnswered) {
            if (optionIndex == question.correctIndex) {
              buttonColor = Colors.green.shade900.withValues(alpha: .4);

              textColor = Colors.green.shade200;

              borderColor = Colors.green;
            } else if (optionIndex == selectedOptionIndex) {
              buttonColor = Colors.red.shade900.withValues(alpha: .4);

              textColor = Colors.red.shade200;

              borderColor = Colors.red;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),

            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(
                milliseconds: 200,
              ),

              decoration: BoxDecoration(
                color: buttonColor,

                borderRadius: BorderRadius.circular(16),

                border: Border.all(
                  color: borderColor,

                  width: isAnswered ? 2 : 1,
                ),
              ),

              // InkWell a gombnyomás érzékelésére
              // Ha a kérdésre már válaszoltak, akkor a gombok inaktívak lesznek
              child: InkWell(
                borderRadius: BorderRadius.circular(16),

                onTap: isAnswered
                    ? null
                    : () {
                        context.read<QuizCubit>().revealAnswerWithDelay(
                          optionIndex == question.correctIndex,

                          optionIndex,
                        );
                      },

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),

                  child: Text(
                    option,

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.w600,

                      color: isAnswered ? textColor : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
