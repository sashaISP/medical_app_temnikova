import 'package:medical_app_temnikova/symptom_page/model/model_diagnoses.dart';
import 'package:medical_app_temnikova/symptom_page/model/model_symptoms.dart';

String getDiagnosisProbability(int index) {
  int matchedSymptoms = diagnoses[index]
      .symptoms
      .where((symptom) => selectedSymptoms.contains(symptom))
      .length;
  int totalSymptoms = diagnoses[index].symptoms.length;
  double probability = (matchedSymptoms / totalSymptoms) * 100;
  if (probability < 33.334) {
    return 'Вероятность: ниже среднего.';
  } else if (probability < 66) {
    return 'Вероятность: средняя.';
  } else {
    return 'Вероятность: выше среднего.';
  }
}

