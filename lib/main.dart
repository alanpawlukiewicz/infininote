import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infininote/utils/theme.dart';
import 'package:infininote/providers/theme_provider.dart';
import 'package:infininote/screens/notes.dart';
import 'package:infininote/notifications/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.checkForNotificationLaunch();
  tz.initializeTimeZones();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    ProviderScope(child: const App()),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> theme = ref.watch(themeProvider);
    final appTheme = AppTheme(theme: theme);

    return MaterialApp(
      title: 'Notes App',
      themeMode: appTheme.themeMode,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      home: const NotesScreen(),
    );
  }
}
