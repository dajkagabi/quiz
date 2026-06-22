import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:quiz/quiz/models/question.dart';

// Forráskártya, UI
class SourceCard extends StatelessWidget {
  const SourceCard({required this.question, super.key});
  final Question question;

  static const Color _accentColor = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    if (question.sources == null) return const SizedBox.shrink();
    // Ha nincs forrás, akkor ne jelenjen meg a kártya
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: _accentColor.withValues(alpha: 0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _accentColor.withValues(alpha: 0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    LucideIcons.disc,
                    color: _accentColor,
                    size: 22,
                  ), // Lucide vinyl/CD ikon
                  SizedBox(width: 10),
                  Text(
                    'Tudtad? (Hiteles háttérinfó)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _accentColor,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(color: Colors.white12),
              ),
              if (question.sources?.hungaroton != null) ...[
                Text(
                  question.sources!.hungaroton!.catalogType ==
                          'recording_context'
                      ? ' Felvétel kontextus: ${question.sources!.hungaroton!.primaryPerformer ?? ""}'
                      : ' Eredeti album: ${question.sources!.hungaroton!.title}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Hivatalos kiadás, év, kiadó
                Text(
                  question.sources!.hungaroton!.catalogType ==
                          'recording_context'
                      ? ' Megjelent: A "${question.sources!.hungaroton!.title}" című lemezen (${question.sources!.hungaroton!.year})'
                      : ' Kiadó: Hungaroton ${question.sources!.hungaroton!.label} (${question.sources!.hungaroton!.year})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    height: 1.4,
                  ),
                ),
              ],
              if (question.sources?.artisjus != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Szerző(k): ${question.sources!.artisjus!.composer}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hivatalos ISWC kód: ${question.sources!.artisjus!.iswc}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
