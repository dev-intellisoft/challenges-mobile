import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/viewmodels/task_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        title: 'Taski',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Urbanist',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0066FF),
            primary: const Color(0xFF0066FF),
            secondary: const Color(0xFF0066FF),
            surface: Colors.white,
            background: Colors.white,
            error: const Color(0xFFFF3B30),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1B1F),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF49454F),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF49454F),
            ),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFFF4F4F4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}