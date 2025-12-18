import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/book_provider.dart'; // Перевір шлях

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Отримуємо доступ до книг через Consumer
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        final books = provider.books;

        // 2. Рахуємо кількість книг кожного статусу
        final int planned = books.where((b) => b.status == 'Plan').length;
        final int reading = books.where((b) => b.status == 'Reading').length;
        final int finished = books.where((b) => b.status == 'Done').length;
        final int total = books.length;

        // Якщо книг немає, показуємо заглушку, щоб не ділити на нуль
        if (total == 0) {
          return const Center(child: Text("Додайте книги, щоб побачити статистику"));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Статистика читання',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F92FF),
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Малюємо діаграму з реальними даними
                CustomPaint(
                  size: const Size(200, 200),
                  painter: PieChartPainter(
                    data: {
                      'Планую': planned / total,
                      'Читаю': reading / total,
                      'Прочитав': finished / total,
                    },
                  ),
                ),
                const SizedBox(height: 40),

                // 4. Легенда з реальними цифрами
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LegendItem(color: Colors.orangeAccent, text: 'Планую: $planned'),
                    LegendItem(color: Colors.amber, text: 'Читаю: $reading'),
                    LegendItem(color: Colors.lightGreen, text: 'Прочитав: $finished'),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Загалом книжок: $total',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ... Класи PieChartPainter та LegendItem залишаються без змін ...
// (Я їх тут не дублюю, бо вони у тебе вже є в файлі, просто залиш їх внизу)
class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors = [
    Colors.orangeAccent,
    Colors.amber,
    Colors.lightGreen,
  ];

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    double startRadian = -pi / 2;
    int colorIndex = 0;

    data.forEach((_, value) {
      final sweepRadian = value * 2 * pi;
      if (sweepRadian > 0) { // Малюємо тільки якщо є дані
        paint.color = colors[colorIndex % colors.length];
        canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
            startRadian, sweepRadian, true, paint);
        startRadian += sweepRadian;
      }
      colorIndex++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16, height: 16,
          margin: const EdgeInsets.only(right: 8, bottom: 6),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'dart:math';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Підставні значення
    final int planned = 5;
    final int reading = 3;
    final int finished = 7;
    final int total = planned + reading + finished;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Статистика читання',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F92FF),
              ),
            ),
            const SizedBox(height: 40),
            // Малюємо кругову діаграму вручну
            CustomPaint(
              size: const Size(200, 200),
              painter: PieChartPainter(
                data: {
                  'Планую': planned / total,
                  'Читаю': reading / total,
                  'Прочитав': finished / total,
                },
              ),
            ),
            const SizedBox(height: 40),
            // Підписи з легендою
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LegendItem(color: Colors.orangeAccent, text: 'Планую: $planned'),
                LegendItem(color: Colors.amber, text: 'Читаю: $reading'),
                LegendItem(color: Colors.lightGreen, text: 'Прочитав: $finished'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Загалом книжок: $total',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors = [
    Colors.orangeAccent,
    Colors.amber,
    Colors.lightGreen,
  ];

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    double startRadian = -pi / 2; // починаємо зверху
    int colorIndex = 0;

    data.forEach((_, value) {
      final sweepRadian = value * 2 * pi;
      paint.color = colors[colorIndex % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        true,
        paint,
      );
      startRadian += sweepRadian;
      colorIndex++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 8, bottom: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}

*/



/*
import 'package:flutter/material.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика читання',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F92FF),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.bar_chart, size: 80, color: Color(0xFF4F92FF)),
                    SizedBox(height: 20),
                    Text(
                      'Ваша статистика поки порожня',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Додайте книги, щоб побачити прогрес 📚',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/