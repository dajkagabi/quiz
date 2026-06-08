import 'package:flutter/material.dart';
import 'package:quiz/l10n/l10n.dart';
//itt meg kell hívni a quiz_page-t,
import 'package:quiz/quiz/view/quiz_page.dart';

// Az App osztály a Flutter alkalmazás gyökerét jelenti, ahol a MaterialApp konfigurálva van.
// Ez az osztály beállítja a témát, a lokalizációt, és meghívja a QuizPage-t,
// amely a kvíz alkalmazás fő oldala
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const QuizPage(),
    );
  }
}
