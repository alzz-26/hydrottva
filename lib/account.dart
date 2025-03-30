import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  MyAccountScreenState createState() => MyAccountScreenState();
}

class MyAccountScreenState extends State<MyAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add functionality for updating, saving, or using the entered data here if needed
                print("Name: ${_nameController.text}");
                print("Email: ${_emailController.text}");
                print("Password: ${_passwordController.text}");
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
