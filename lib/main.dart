import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

import 'screens/counter_model.dart';

import '/providers/book_provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Ініціалізація Supabase (Фото)
  await Supabase.initialize(
    url: 'https://vkvxruvpduuvcmukcfem.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrdnhydXZwZHV1dmNtdWtjZmVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3MDUzODYsImV4cCI6MjA4MTI4MTM4Nn0.WElacr8zJgQsCDKKurwcE3O4-FZ8_Hwe3EVHkxqxA3E',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: const ReadingApp(),
    ),
  );
}

class ReadingApp extends StatelessWidget {
  const ReadingApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/login',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/login': (context) => LoginScreen(analytics: analytics),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
//
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';
//
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
//
//
// import 'package:provider/provider.dart';
// import 'screens/counter_model.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(
//       ChangeNotifierProvider(
//         create: (_) => CounterModel(),
//         child: const ReadingApp(),
//     ),
//   );
// }
//
// /*
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//
//   runApp(const ReadingApp());
// }
// */
//
// class ReadingApp extends StatelessWidget {
//   const ReadingApp({super.key});
//
//   // Створюємо інстанс Analytics
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reading Tracker',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       initialRoute: '/login',
//       navigatorObservers: [
//         FirebaseAnalyticsObserver(analytics: analytics),
//       ],
//       routes: {
//         '/login': (context) => LoginScreen(analytics: analytics),
//         '/register': (context) => RegisterScreen(/*analytics: analytics*/),
//         '/home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }





















/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Не забудь розкоментувати імпорт
import 'firebase_options.dart';
import 'screens/counter_model.dart'; // Не забудь розкоментувати імпорт
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Огортаємо додаток у Provider, інакше HomeScreen не працюватиме
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: const ReadingApp(),
    ),
  );
}

class ReadingApp extends StatelessWidget {
  const ReadingApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker', // Тут теж можна використати AppStrings.appTitle
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/login': (context) => LoginScreen(analytics: analytics),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
*/


//yulichka89@gmail.com


/*
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // обов'язково для async main
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ініціалізація Firebase
  );
  runApp(const ReadingApp());
}

class ReadingApp extends StatelessWidget {
  const ReadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
*/