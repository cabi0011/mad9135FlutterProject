

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_project/utils/app_state.dart';
import 'package:flutter_app_project/utils/http_helper.dart';
import 'package:flutter_app_project/screens/movie_selection_screen.dart';

class CreateCodeScreen extends StatefulWidget {
  const CreateCodeScreen({super.key});

  @override
  _CreateCodeScreenState createState() => _CreateCodeScreenState();
}

class _CreateCodeScreenState extends State<CreateCodeScreen> {
  String code = "Unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    if (kDebugMode) {
      print('Device id from Create Code Screen: $deviceId');
    }
    // Call API
    final response = await HttpHelper.startSession(deviceId);
    if (kDebugMode) {
      print(response['data']['code']);
    }
    setState(() {
      code = response['data']['code'];
    });
    Provider.of<AppState>(context, listen: false).setSessionId(response['data']['session_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Code: $code'),
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
    );
  }
}