import 'package:flutter/material.dart';
import '../component/get_diagnosis_probability.dart';
import '../diagnosis_detail_page/view_diagnosis_detail_page.dart';
import '../symptom_page/model/model_diagnoses.dart';

class ControllerDiagnosesPage extends StatelessWidget {
  final int index;

  const ControllerDiagnosesPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(diagnoses[index].name),
      subtitle: Text(getDiagnosisProbability(index)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDiagnosisDetailPage(id: index),
          ),
        );
      },
    );
  }
}
