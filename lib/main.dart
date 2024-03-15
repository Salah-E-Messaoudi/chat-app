import 'package:chat_app/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        // Theme Data
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF29B785),
            background: Color(0xFFF9F9F9),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF29B785),
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            centerTitle: true,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
