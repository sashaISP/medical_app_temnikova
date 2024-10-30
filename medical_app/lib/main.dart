import 'package:flutter/material.dart';
import 'package:medical_app_temnikova/symptom_page/view_symptom_page.dart';
import 'symptom_page/model/model_diagnoses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  saveDataToDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Symptom Checker',
      home: ViewSymptomPage(),
    );
  }
}
