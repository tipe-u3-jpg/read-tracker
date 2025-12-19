import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoginScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  const LoginScreen({super.key, required this.analytics});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // ключ для форми
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String error = '';
  bool isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return; // перевірка форми

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Лог події успішного входу
      await widget.analytics.logEvent(
        name: 'login',
        parameters: {'method': 'email'},
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e, s) {
      // Лог неуспішного входу
      await widget.analytics.logEvent(
        name: 'login_failed',
        parameters: {'error': e.toString()},
      );

      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Firebase Auth login error');

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Користувача з таким email не знайдено';
          break;
        case 'wrong-password':
          message = 'Невірний пароль';
          break;
        case 'invalid-email':
          message = 'Невірний формат email';
          break;
        default:
          message = 'Сталася помилка: ${e.message}';
      }
      setState(() {
        error = message;
      });
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Unknown login error');
      setState(() {
        error = 'Сталася помилка: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Library.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4F92FF), Color(0xFF8EC5FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey, // підключаємо форму
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Read Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F92FF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле email обовʼязкове';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Невірний формат email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле пароля обовʼязкове';
                        }
                        if (value.length < 6) {
                          return 'Пароль має бути не менше 6 символів';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    if (error.isNotEmpty)
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: isLoading ? 'Завантаження...' : 'Увійти',
                      onPressed: () {
                        if (!isLoading && _formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      buttonColor: const Color(0xFF4F92FF),
                      textColor: Colors.white,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'Реєстрація',
                        style: TextStyle(color: Color(0xFF4F92FF)),
                      ),
                    ),
                    // 🔥 ТЕСТОВА КНОПКА ДЛЯ КРАШУ

                    TextButton(
                      onPressed: () async {
                        await widget.analytics.logEvent(
                          name: 'test_crash_triggered',
                          parameters: {
                            'screen': 'login_screen',
                            'action': 'manual_test_crash'
                          },
                        );

                        throw Exception("Test Crash: Штучна помилка для перевірки Crashlytics");
                      },
                      child: const Text(
                        "Test Crash",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}








/*
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String validEmail = 'qwerty@email.com';
  final String validPassword = 'qwerty';

  String error = '';

  void login() {
    if (emailController.text == validEmail &&
        passwordController.text == validPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        error = 'Невірний email або пароль';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Library.jpg',
              fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F92FF), Color(0xFF8EC5FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Назва додатку
                  const Text(
                    'Read Tracker',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F92FF),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Увійти',
                    onPressed: login,
                    buttonColor: const Color(0xFF4F92FF),
                    textColor: Colors.white,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Реєстрація',
                      style: TextStyle(color: Color(0xFF4F92FF)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/