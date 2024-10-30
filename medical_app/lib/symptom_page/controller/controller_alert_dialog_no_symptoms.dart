import 'package:flutter/material.dart';

class ControllerAlertDialogNoSymptoms extends StatelessWidget {
  const ControllerAlertDialogNoSymptoms({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Нет выбранных симптомов'),
      content: const Text(
          'Пожалуйста, выберите хотя бы один симптом для определения диагноза.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
