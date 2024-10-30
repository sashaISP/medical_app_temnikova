import 'package:flutter/material.dart';
import '../model/model_symptoms.dart';

class ControllerSymptomPage extends StatefulWidget {
  final int index;

  const ControllerSymptomPage({super.key, required this.index});

  @override
  State<ControllerSymptomPage> createState() => _ControllerSymptomPageState();
}

class _ControllerSymptomPageState extends State<ControllerSymptomPage> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(symptoms[widget.index]),
      onTap: () => setState(() {
        if (selectedSymptoms.contains(symptoms[widget.index])) {
          selectedSymptoms.remove(symptoms[widget.index]);
        } else {
          selectedSymptoms.add(symptoms[widget.index]);
        }
      }),
      trailing: selectedSymptoms.contains(symptoms[widget.index])
          ? const Icon(Icons.check)
          : null,
    );
  }
}
