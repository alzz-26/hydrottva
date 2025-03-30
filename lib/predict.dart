import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final TextEditingController pHController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();

  String predictionResult = "";

  Future<void> predictYield() async {
    final url = Uri.parse('http://<YOUR LOCAL IP>:5000/predict');

    final Map<String, dynamic> requestData = {
      "Ideal pH": double.tryParse(pHController.text) ?? 0.0,
      "Average Temperature": double.tryParse(tempController.text) ?? 0.0,
      "Nitrogen": double.tryParse(nitrogenController.text) ?? 0.0,
      "Phosphorus": double.tryParse(phosphorusController.text) ?? 0.0,
      "Potassium": double.tryParse(potassiumController.text) ?? 0.0,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          predictionResult = "Predicted Yield: ${data['yield_percentage']}%";
        });
      } else {
        setState(() {
          predictionResult = "Error: Unable to get prediction";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: pHController,
              decoration: InputDecoration(labelText: "Ideal pH"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tempController,
              decoration: InputDecoration(labelText: "Average Temperature"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nitrogenController,
              decoration: InputDecoration(labelText: "Nitrogen"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: phosphorusController,
              decoration: InputDecoration(labelText: "Phosphorus"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: potassiumController,
              decoration: InputDecoration(labelText: "Potassium"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictYield,
              child: Text("Predict Yield"),
            ),
            SizedBox(height: 20),
            Text(
              predictionResult,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
