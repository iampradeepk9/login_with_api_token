import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'firstpage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for input fields to handle user input
  final TextEditingController _companyCodeController = TextEditingController();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // To control the loading indicator during API call
  bool _isLoading = false;

  // Method to handle login logic
  Future<void> login() async {
    // API URL for authentication
    final String uri = 'https://api.pockethrms.com/api/account/authenticate';

    print('api ${uri}');

    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    try {
      // Sending a POST request to the API with user input
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Content-Type': 'application/json'}, // Setting headers
        body: jsonEncode({
          // JSON body with user credentials
          'companycode': _companyCodeController.text,
          'employeecode': _employeeCodeController.text,
          'password': _passwordController.text,
        }),
      );

      // Stop loading spinner
      setState(() {
        _isLoading = false;
      });

      print('response.body  ${response.body}');
      print('statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        // If login is successful, extract JWT token from response
        final String jwtToken = response.body;


        // TODO: Save token securely (e.g., SharedPreferences or Secure Storage)
        print('Token: $jwtToken'); // Print the token for debugging

        // Navigate to the next page with the token
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstPage(token: jwtToken)),
        );
      } else {
        // If login fails, show the error message from the API
        final error = jsonDecode(response.body); // Parse error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Login failed')), // Show error message
        );
      }
    } catch (e) {
      // Handle unexpected errors (e.g., network issues)
      setState(() {
        _isLoading = false; // Stop loading spinner
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')), // Show generic error
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Title of the login page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch widgets horizontally
          children: [
            // TextField for company code input
            TextField(
              controller: _companyCodeController, // Binds input to the controller
              decoration: InputDecoration(labelText: 'Company Code'), // Input label
            ),
            SizedBox(height: 16), // Add spacing between fields

            // TextField for employee code input
            TextField(
              controller: _employeeCodeController, // Binds input to the controller
              decoration: InputDecoration(labelText: 'Employee Code'), // Input label
            ),
            SizedBox(height: 16), // Add spacing between fields

            // TextField for password input
            TextField(
              controller: _passwordController, // Binds input to the controller
              decoration: InputDecoration(labelText: 'Password'), // Input label
              obscureText: true, // Mask the password for secure input
            ),
            SizedBox(height: 32), // Add spacing before the button

            // Display a loading spinner or the login button
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Show spinner when loading
                : ElevatedButton(
              onPressed: login, // Call login method on button press
              child: Text('Login'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  // Constructor to receive the JWT token
  // final String token;
  //
  // NextPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'), // Title of the next page
      ),
      body: Center(
        child: Text('Welcome !!!!'), // Display the received token
      ),
    );
  }
}