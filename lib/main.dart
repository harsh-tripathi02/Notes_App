import 'package:flutter/material.dart';
import 'services/note_service.dart';
import 'screens/home_screen.dart';
import 'themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notesService = NotesService();
  await notesService.initialize();
  runApp(MyApp(notesService: notesService));
}

class MyApp extends StatefulWidget {
  final NotesService notesService;

  const MyApp({super.key, required this.notesService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: HomeScreen(notesService: widget.notesService),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: FloatingActionButton(
              mini: true,
              onPressed: _toggleTheme,
              tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
              child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ),
        ),
      ),
    );
  }
}