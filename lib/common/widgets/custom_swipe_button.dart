import 'package:flutter/material.dart';

class SwipeButton extends StatefulWidget {
  final VoidCallback onAccept;
  final String text;

  const SwipeButton({
    super.key,
    required this.onAccept,
    required this.text
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double dragPosition = 0.0;
  final double circleSize = 50; // Размер белой области (круга)
  final double padding = 5; // Отступы сверху и снизу внутри зелёной области

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Ширина экрана
    final double maxDrag = screenWidth - 2 * padding - circleSize - 32; // Максимальная длина свайпа внутри зелёной области

    // Вычисляем текущий цвет фона
    final double colorTween = dragPosition / maxDrag;
    final Color currentColor = Color.lerp(Colors.green, Colors.white, colorTween)!;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          dragPosition += details.delta.dx;
          if (dragPosition < 0) dragPosition = 0; // Ограничение влево
          if (dragPosition > maxDrag) dragPosition = maxDrag; // Ограничение вправо
        });
      },
      onHorizontalDragEnd: (details) {
        if (dragPosition >= maxDrag) {
          // Завершено свайп-действие
          widget.onAccept(); // Вызываем колбэк для принятия задачи
        } else {
          // Возврат в начальную позицию, если свайп не завершён
          setState(() {
            dragPosition = 0;
          });
        }
      },
      child: Container(
        width: screenWidth, // Кнопка на всю ширину экрана
        padding: EdgeInsets.symmetric(horizontal: padding), // Отступы внутри зелёной области
        decoration: BoxDecoration(
          color: currentColor, // Текущий цвет фона
          borderRadius: BorderRadius.circular(50), // Закруглённые углы
        ),
        height: circleSize + (padding * 2), // Высота кнопки с учётом вертикальных отступов
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Зеленая кнопка (фон)
            Positioned.fill(
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Белая движущаяся часть (свайп-область)
            Positioned(
              left: dragPosition, // Расположение белого круга
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}