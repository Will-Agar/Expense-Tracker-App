import 'package:expense_tracker/styles/theme.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
  //   (fn) {
  //     runApp(
  //       const AppContainer(),
  //     );
  //   },
  // );

  runApp(
    const AppContainer(),
  );
}

class AppContainer extends StatelessWidget {
  const AppContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: theme,
      home: const Expenses(),
      themeMode: ThemeMode.system,
    );
  }
}
