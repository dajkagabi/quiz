// Osztály a kérdések reprezentálására a quiz alkalmazásban
//Json formátumú kérdések kezelésére szolgáló osztály, amely tartalmazza a kérdés szövegét, válaszlehetőségeket, helyes válasz indexét, témát és nehézségi szintet.

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String topic;
  final String difficulty;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.topic,
    required this.difficulty,
  });

  // JSON-ból való létrehozás és JSON-ba konvertálás metódusai a kérdések kezeléséhez.

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
    };
  }
}
