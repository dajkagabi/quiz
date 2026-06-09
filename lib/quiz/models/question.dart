// Osztály a kérdések reprezentálására a quiz alkalmazásban
//Json formátumú kérdések kezelésére szolgáló osztály,
// amely tartalmazza a kérdés szövegét, válaszlehetőségeket,
// helyes válasz indexét, témát és nehézségi szintet.

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String topic;
  final String difficulty;
  final QuizSources? sources;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.topic,
    required this.difficulty,
    this.sources,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctIndex: json['correctIndex'] as int,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
      sources: json['sources'] != null
          ? QuizSources.fromJson(json['sources'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'topic': topic,
      'difficulty': difficulty,
      'sources': sources?.toJson(),
    };
  }
}

// Összefogó osztály az Artisjus és Hungaroton forrásoknak
class QuizSources {
  final ArtisjusSource? artisjus;
  final HungarotonSource? hungaroton;

  const QuizSources({
    this.artisjus,
    this.hungaroton,
  });

  factory QuizSources.fromJson(Map<String, dynamic> json) {
    return QuizSources(
      artisjus: json['artisjus'] != null
          ? ArtisjusSource.fromJson(json['artisjus'] as Map<String, dynamic>)
          : null,
      hungaroton: json['hungaroton'] != null
          ? HungarotonSource.fromJson(
              json['hungaroton'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artisjus': artisjus?.toJson(),
      'hungaroton': hungaroton?.toJson(),
    };
  }
}

// Artisjus specifikus modell
class ArtisjusSource {
  final String iswc;
  final String composer;

  const ArtisjusSource({
    required this.iswc,
    required this.composer,
  });

  factory ArtisjusSource.fromJson(Map<String, dynamic> json) {
    return ArtisjusSource(
      iswc: json['iswc'] as String,
      composer: json['composer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iswc': iswc,
      'composer': composer,
    };
  }
}

// Hungaroton specifikus modell
class HungarotonSource {
  final String catalogType;
  final String title;
  final int year;
  final String label;
  final String?
  // Csak a q3-nál használjuk, a többinél null lesz
  primaryPerformer;

  const HungarotonSource({
    required this.catalogType,
    required this.title,
    required this.year,
    required this.label,
    this.primaryPerformer,
  });

  factory HungarotonSource.fromJson(Map<String, dynamic> json) {
    return HungarotonSource(
      catalogType: json['catalog_type'] as String,
      title: json['title'] as String,
      year: json['year'] as int,
      label: json['label'] as String,
      primaryPerformer: json['primary_performer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catalog_type': catalogType,
      'title': title,
      'year': year,
      'label': label,
      'primary_performer': primaryPerformer,
    };
  }
}
