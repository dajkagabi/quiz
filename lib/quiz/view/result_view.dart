import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';

// A ResultView a kvíz eredményét jeleníti meg a játék végén.
// Ez a nézet megmutatja a játékos pontszámát,
// egy ikon segítségével ünnepli a teljesítményt,
// és egy gombot kínál az újraindításhoz.

class ResultView extends StatelessWidget {
  final int score;

  const ResultView({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    // Lekérjük a kérdések teljes számát a cubit állapotából,
    // hogy dinamikusan számoljunk
    final totalQuestions = context.select(
      (QuizCubit cubit) => cubit.state.questions.length,
    );

    // Százalékos arány kiszámítása
    // (biztonsági ellenőrzéssel, hogy ne osszunk nullával)
    final percentage = totalQuestions > 0
        ? (score / totalQuestions * 100).round()
        : 0;

    // Játékos rangjának és a hozzá tartozó színes ikonnak
    // a meghatározása a teljesítmény alapján
    String rankTitle;
    String rankDescription;
    IconData rankIcon;
    Color rankColor;

    if (percentage >= 90) {
      rankTitle = 'Rocklegenda! ';
      rankDescription =
          'Zseniális! Balázs Fecó, Presser Gábor és Cipő is büszke lenne rád. Mindent tudsz a magyar rockról!';
      rankIcon = Icons.bolt;
      rankColor = Colors.amber.shade800;
    } else if (percentage >= 65) {
      rankTitle = 'Koncertbérletes ';
      rankDescription =
          'Szép teljesítmény! Rendszeresen jársz koncertekre és jól ismered a klasszikus slágereket.';
      rankIcon = Icons.library_music;
      rankColor = Colors.blue.shade700;
    } else if (percentage >= 40) {
      rankTitle = 'Hobby Gitáros ';
      rankDescription =
          'Nem rossz, de érdemes még pörgetni a régi Hungaroton bakeliteket a teljes tudáshoz!';
      rankIcon = Icons.music_note;
      rankColor = Colors.orange.shade700;
    } else {
      rankTitle = 'Kezdő Rocker ';
      rankDescription =
          'Ez most egy kicsit mellément, mint egy hamis gitárszóló. Ne add fel, próbáld újra és tanulj a forrásokból!';
      rankIcon = Icons.sentiment_dissatisfied;
      rankColor = Colors.red.shade700;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 36.0,
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nagy animált-jellegű körkörös ikon a kapott rang színeivel
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    rankIcon,
                    size: 70,
                    color: rankColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Rang címe
                Text(
                  rankTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Szöveges értékelés
                Text(
                  rankDescription,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                const Divider(),
                const SizedBox(height: 16),

                // Statisztika dobozok
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(
                      'Pontszám',
                      '$score / $totalQuestions',
                      Colors.blue.shade800,
                    ),
                    _buildStatColumn(
                      'Teljesítmény',
                      '$percentage%',
                      Colors.green.shade700,
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Újraindítás gomb, ami meghívja a frissített, újrakeverős restart() metódust
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    context.read<QuizCubit>().restart();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Új játék indítása',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Segéd-widget a statisztikai oszlopok szép megjelenítéséhez
  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
