import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart'; // Generated localization

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter i18n + Theme Demo',
      locale: _locale,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(onLocaleChange: _setLocale, onToggleTheme: _toggleTheme),
    );
  }
}

class HomePage extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.onLocaleChange,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.title),
        leading: PopupMenuButton<Locale>(
          icon: const Icon(Icons.language),
          onSelected: onLocaleChange,
          itemBuilder: (context) => [
            const PopupMenuItem(value: Locale('en'), child: Text('English')),
            const PopupMenuItem(value: Locale('zh'), child: Text('中文')),
            const PopupMenuItem(
              value: Locale('zh', 'HK'),
              child: Text('中文（香港）'),
            ),
            const PopupMenuItem(value: Locale('fr'), child: Text('Français')),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Center(child: Text(loc.switch_language)),
    );
  }
}
