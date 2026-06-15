import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quiz/quiz/models/question.dart';

//Ez a repository osztály felelős a kérdések betöltéséért a JSON fájlból.
class QuizRepository {
  Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/questions.json',
    );

    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    // A JSON-ból betöltött adatokból Question objektumokat hozunk létre
    return jsonList
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
