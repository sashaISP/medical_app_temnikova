import 'package:flutter/material.dart';
import 'package:medical_app_temnikova/diagnoses_page/controller_diagnoses_page.dart';
import '../database_helper.dart';
import '../symptom_page/model/model_diagnoses.dart';
import '../symptom_page/model/model_symptoms.dart';

class ViewDiagnosesPage extends StatefulWidget {
  const ViewDiagnosesPage({super.key});

  @override
  State<ViewDiagnosesPage> createState() => _ViewDiagnosesPageState();
}

class _ViewDiagnosesPageState extends State<ViewDiagnosesPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelDiagnoses>>(
      future: getDiagnosesFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final diagnoses = snapshot.data!;
          final filteredDiagnoses = filterDiagnoses(diagnoses); // Фильтруем диагнозы
          final sortedDiagnoses = sortDiagnosesByProbability(filteredDiagnoses); // Сортируем диагнозы
          return Scaffold(
            appBar: AppBar(
              title: const Text('Список диагнозов'),
            ),
            body: ListView.builder(
              itemCount: sortedDiagnoses.length,
              itemBuilder: (context, index) {
                return ControllerDiagnosesPage(index: diagnoses.indexOf(sortedDiagnoses[index]));
              },
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeSymptoms();
  }

  Future<void> _initializeSymptoms() async {
    diagnoses = await getDiagnosesFromDatabase();
  }
}

List<ModelDiagnoses> filterDiagnoses(List<ModelDiagnoses> diagnoses) {
  return diagnoses.where((diagnosis) {
    int matchedSymptoms = diagnosis.symptoms
        .where((symptom) => selectedSymptoms.contains(symptom))
        .length;
    int totalSymptoms = diagnosis.symptoms.length;
    double probability = (matchedSymptoms / totalSymptoms) * 100;
    return probability > 0;
  }).toList();

}

List<ModelDiagnoses> sortDiagnosesByProbability(List<ModelDiagnoses> diagnoses) {
  return diagnoses.toList()
    ..sort((a, b) {
      int matchedSymptomsA = a.symptoms
          .where((symptom) => selectedSymptoms.contains(symptom))
          .length;
      int totalSymptomsA = a.symptoms.length;
      double probabilityA = (matchedSymptomsA / totalSymptomsA) * 100;

      int matchedSymptomsB = b.symptoms
          .where((symptom) => selectedSymptoms.contains(symptom))
          .length;
      int totalSymptomsB = b.symptoms.length;
      double probabilityB = (matchedSymptomsB / totalSymptomsB) * 100;

      return probabilityB.compareTo(probabilityA);
    });
}

Future<List<ModelDiagnoses>> getDiagnosesFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final diagnosesList = await dbHelper.getDiagnoses();

  return diagnosesList.map((diagnosis) {
    return ModelDiagnoses(
      diagnosis['id'],
      diagnosis['name'],
      diagnosis['symptoms'].split(','),
      diagnosis['recommendationsAndPrecautions'].split(','),
      diagnosis['doctor'],
    );
  }).toList();
}
