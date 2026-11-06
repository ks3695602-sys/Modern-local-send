import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'ui/navigation/main_shell.dart';

class ModernLocalSendApp extends StatefulWidget {
  const ModernLocalSendApp({super.key});

  @override
  State<ModernLocalSendApp> createState() => _ModernLocalSendAppState();
}

class _ModernLocalSendAppState extends State<ModernLocalSendApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      notifier: _appState,
      child: MaterialApp(
        title: 'Modern LocalSend',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          fontFamily: '.SF Pro Text',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF007AFF),
            secondary: Color(0xFF5856D6),
            surface: Color(0xFF1C1C1E),
          ),
        ),
        // Required for liquid_glass_widgets under MaterialApp to prevent yellow underline debug artifacts
        builder: (context, child) => Material(
          type: MaterialType.transparency,
          child: child!,
        ),
        home: const MainShell(),
      ),
    );
  }
}
