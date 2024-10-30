import 'package:flutter/material.dart';
import 'package:medical_app_temnikova/symptom_page/controller/controller_alert_dialog_no_symptoms.dart';
import 'package:medical_app_temnikova/symptom_page/controller/controller_list_tile_symptoms.dart';
import '../database_helper.dart';
import '../diagnoses_page/view_diagnoses_page.dart';
import 'model/model_symptoms.dart';

class ViewSymptomPage extends StatefulWidget {
  const ViewSymptomPage({super.key});

  @override
  State<ViewSymptomPage> createState() => _ViewSymptomPageState();
}

class _ViewSymptomPageState extends State<ViewSymptomPage> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<List<String>> filteredSymptomsNotifier =
      ValueNotifier<List<String>>([]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getSymptomsFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final symptoms = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Выберите симптомы'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Поиск симптомов',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      filterSymptoms(value, symptoms);
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: filteredSymptomsNotifier,
                    builder: (context, filteredSymptoms, _) {
                      return ListView.builder(
                        itemCount: filteredSymptoms.length,
                        itemBuilder: (context, index) {
                          final symptomIndex =
                              symptoms.indexOf(filteredSymptoms[index]);
                          if (symptomIndex != -1) {
                            return ControllerSymptomPage(index: symptomIndex);
                          } else {
                            return Container(); // Возвращаем пустой контейнер, если симптом не найден
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (selectedSymptoms.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ControllerAlertDialogNoSymptoms();
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewDiagnosesPage(),
                    ),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
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
    symptoms = await getSymptomsFromDatabase();
    filteredSymptomsNotifier.value = symptoms;
  }

  void filterSymptoms(String query, List<String> symptoms) {
    filteredSymptomsNotifier.value = symptoms
        .where((symptom) => symptom.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

Future<List<String>> getSymptomsFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final symptomsList = await dbHelper.getSymptoms();

  return symptomsList.map((symptom) => symptom['name'] as String).toList();
}
