import 'package:flutter/material.dart';
import 'dart:math';

class PlantScreen extends StatelessWidget {
  final String name;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  PlantScreen({required this.name, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green[600],
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Temperature: ${Random().nextInt(20) + 10}°C', style: TextStyle(fontSize: 18))),
            SizedBox(height: 40,),
            Center(child: Text('Nutrients: ${Random().nextInt(10) + 1}', style: TextStyle(fontSize: 18))),
            SizedBox(height: 40,),
            Center(child: Text('Water Level: ${Random().nextInt(100)}%', style: TextStyle(fontSize: 18))),
            SizedBox(height: 60),
            Center(child: ElevatedButton(onPressed: onUpdate, child: Text('UPDATE'))),
          ],
        ),
      ),
    );
  }
}