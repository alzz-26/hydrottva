import 'package:flutter/material.dart';
import 'plant.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> plants;
  final Function(List<Map<String, dynamic>>) onUpdatePlants;

  const HomeScreen({super.key, required this.plants, required this.onUpdatePlants});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  final List<String> imageLink = [
    'assets/wave.gif',
    'assets/bee.gif'
  ];
  final List<String> mainText = [
    'Water Remainder',
    'Plant Health Check'
  ];
  final List<String> subText = [
    'Time: 4:00 PM',
    'Time: 3:00 PM'
  ];

  void _addPlant() {
    TextEditingController plantNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Plant'),
          content: TextField(
            controller: plantNameController,
            decoration: const InputDecoration(hintText: 'Enter plant name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (plantNameController.text.isNotEmpty) {
                  setState(() {
                    widget.plants.add({
                      'name': plantNameController.text,
                      'image': Icons.local_florist,
                      'lastUpdate': 'Never'
                    });
                  });
                  widget.onUpdatePlants(widget.plants);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updatePlant(int index) {
    setState(() {
      widget.plants[index]['lastUpdate'] = DateTime.now().toLocal().toString().split('.')[0];
    });
    widget.onUpdatePlants(widget.plants);
  }

  void _deletePlant(int index) {
    setState(() {
      widget.plants.removeAt(index);
    });
    widget.onUpdatePlants(widget.plants);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          height: 300,
          //width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              opacity: 0.6 ,
              image: AssetImage('assets/bg1.jpg'), // Replace with actual image path
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Hello, User!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Plants', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add), onPressed: _addPlant),
          ],
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.plants.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xFF779ECB),
                child: ListTile(
                  splashColor: Colors.lightBlue[100],
                  leading: Icon(widget.plants[index]['image']),
                  title: Text(widget.plants[index]['name']),
                  subtitle: Text('Last Update: ${widget.plants[index]['lastUpdate']}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlantScreen(
                        name: widget.plants[index]['name'],
                        onUpdate: () => _updatePlant(index),
                        onDelete: () {
                          _deletePlant(index);
                          Navigator.pop(context);
                        },
                      )),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text('Reminders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2, // Example count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    // GIF Background
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        imageLink[index], // Place your GIF in assets folder
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ).animate().fade(duration: 500.ms), // Smooth animation
                    ),
          
                    // Card Content (Overlaid on GIF)
                    Container(
                      width: double.infinity,
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), // Dark overlay for readability
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainText[index],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            subText[index],
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}