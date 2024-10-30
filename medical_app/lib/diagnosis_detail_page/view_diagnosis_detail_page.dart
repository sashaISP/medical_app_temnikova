import 'package:flutter/material.dart';
import 'package:medical_app_temnikova/component/get_diagnosis_probability.dart';
import 'package:medical_app_temnikova/symptom_page/model/model_diagnoses.dart';

class ViewDiagnosisDetailPage extends StatelessWidget {
  final int id;

  const ViewDiagnosisDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diagnoses[id].name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getDiagnosisProbability(id),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Врач, который занимается лечением: ${diagnoses[id].doctor}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Рекомендации и предосторожности:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                  itemCount: diagnoses[id].recommendationsAndPrecautions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          diagnoses[id].recommendationsAndPrecautions[index]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
