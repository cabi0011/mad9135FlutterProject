import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import 'movie_selection_screen.dart';
import 'package:flutter_app_project/utils/app_state.dart';
import 'package:provider/provider.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final url = Uri.parse('https://movie-night-api.onrender.com/start-session?device_id=$deviceId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final sessionId = responseData['session_id'];

      Provider.of<AppState>(context, listen: false).setSessionId(sessionId);
    } else {
      _showErrorDialog('Failed to start session');
    }
  }

  Future<void> _submitCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final code = _codeController.text;
    final url = Uri.parse('https://movie-night-api.onrender.com/join-session');
    final response = await http.post(
      url,
      body: json.encode({'code': code}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final sessionId = responseData['session_id'];

      Provider.of<AppState>(context, listen: false).setSessionId(sessionId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MovieSelectionScreen()),
      );
    } else {
      final errorMessage = json.decode(response.body)['error'];
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Enter Code'),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a code';
                  }
                  if (value.length != 4) {
                    return 'Code must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCode,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovieSelectionScreen(),
                    ),
                  );
                },
                child: const Text('Go to Movie Selection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}