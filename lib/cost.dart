import 'package:flutter/material.dart';

class CostScreen extends StatefulWidget {
  const CostScreen({super.key});

  @override
  CostScreenState createState() => CostScreenState();
}

class CostScreenState extends State<CostScreen> {
  final List<String> plantTypes = [
    "Leafy Greens & Herbs",
    "Fruits & Vegetables",
    "Flowering Plants",
    "Roots & Tubers",
    "All Purpose"
  ];
  final List<String> regions = ["North", "South", "East", "West"];
  final Map<String, double> nutrients = {
    "City Greens Hydroponic Powder": 1.17,
    "WE Hydroponics Nutrients": 0.19,
    "Vegetable Special Nutrients": 0.22,
  };

  String? selectedPlantType;
  String? selectedRegion;
  String? selectedNutrient;
  double? costPerMl;
  final TextEditingController _controller = TextEditingController();
  double? totalCost;

  void calculateCost() {
    double amount = double.tryParse(_controller.text) ?? 0;
    setState(() {
      totalCost = amount * (costPerMl ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Plant Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedPlantType,
              isExpanded: true,
              hint: const Text("Choose Plant Type"),
              items: plantTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlantType = value;
                });
              },
            ),
            const SizedBox(height: 40),
            const Text("Select Region", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedRegion,
              isExpanded: true,
              hint: const Text("Choose Region"),
              items: regions.map((region) {
                return DropdownMenuItem(value: region, child: Text(region));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;
                });
              },
            ),
            const SizedBox(height: 40),
            const Text("Choose Nutrient", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedNutrient,
              isExpanded: true,
              hint: const Text("Select Nutrient"),
              items: nutrients.keys.map((nutrient) {
                return DropdownMenuItem(value: nutrient, child: Text("$nutrient - ₹${nutrients[nutrient]}/ml"));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedNutrient = value;
                  costPerMl = nutrients[value];
                });
              },
            ),
            const SizedBox(height: 40),
            const Text("Enter Required Amount (ml/mg)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _controller, keyboardType: TextInputType.number),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: calculateCost,
                child: const Text("Calculate Cost"),
              ),
            ),
            if (totalCost != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Total Cost: ₹${totalCost!.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
