import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Google Sign-In
  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  late Future<String?> tokenFuture;

  @override
  void initState() {
    super.initState();

    // Check saved login token
     tokenFuture = storage.read(key: 'access_token');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,

          home: FutureBuilder<String?>(
            future: tokenFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return HomeScreen(
                  userName: 'User',
                  mythemeNotifier: themeNotifier,
                );
              }

              return const WelcomeScreen();
            },
          ),
        );
      },
    );
  }
}

