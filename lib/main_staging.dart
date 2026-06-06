import 'package:quiz/app/app.dart';
import 'package:quiz/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
