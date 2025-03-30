import 'dart:async';
import 'predict.dart';
import 'cost.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'home.dart';
import 'account.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null, // Default icon
    [
      NotificationChannel(
        channelKey: 'water_reminder',
        channelName: 'Water Reminder',
        channelDescription: 'Reminds you to water your plants',
        defaultColor: Colors.green,
        importance: NotificationImportance.High,
        ledColor: Colors.white,
      )
    ],
  );
  runApp(const Hydrottva());
}

class Hydrottva extends StatelessWidget {
  const Hydrottva({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hydrottva',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HydroponicsApp())),
    );
    scheduleWateringReminder();
  }

  void scheduleWateringReminder() {
    for (int i = 1; i <= 6; i++) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'water_reminder',
          title: 'Plant Care Reminder',
          body: 'Time to water your plants!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationInterval(
          interval: i * 4 * 60 * 60, // Every 4 hours
          preciseAlarm: true,
          timeZone: 'UTC',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/logo.jpg',
                    height: 350,
                    width: 350,
                    fit: BoxFit.cover,
                  )
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Welcome to your Hydroponic Garden', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
            ],
          ),
        )
    );
  }
}

class HydroponicsApp extends StatefulWidget {
  const HydroponicsApp({super.key});

  @override
  HydroponicsAppState createState() => HydroponicsAppState();
}

class HydroponicsAppState extends State<HydroponicsApp> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> plants = [];

  final List<Widget> _screens = [];

  final List<String> _title = ['Home', 'Yield Prediction', 'Cost Calculator', 'My Account'];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(plants: plants, onUpdatePlants: (updatedPlants) {
        setState(() {
          plants = updatedPlants;
        });
      }),
      PredictScreen(),
      const CostScreen(),
      MyAccountScreen()
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(_title[_selectedIndex] , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          backgroundColor: Color(0xFF80471C),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME', backgroundColor: Color.fromARGB(255, 188, 188, 130),),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'PREDICT'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'COST'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'ACCOUNT'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green[900],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}