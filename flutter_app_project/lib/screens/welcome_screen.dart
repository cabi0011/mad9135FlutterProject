import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_project/utils/app_state.dart';
import 'package:flutter_app_project/screens/create_code_screen.dart';
import 'package:flutter_app_project/screens/enter_code_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
  }

  Future<void> _initializeDeviceId() async {
    String deviceId;
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidId = AndroidId();
        deviceId = await androidId.getId() ?? 'Unknown ID';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'Unknown ID';
      } else {
        deviceId = 'Unsupported Platform';
      }
    } on PlatformException {
      deviceId = 'Failed to get device ID';
    }

    Provider.of<AppState>(context, listen: false).setDeviceId(deviceId);
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
            Text('Device ID: ${Provider.of<AppState>(context).deviceId}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCodeScreen(),
                  ),
                );
              },
              child: const Text('Create a code'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnterCodeScreen(),
                  ),
                );
              },
              child: const Text('Enter a code'),
            ),
          ],
        ),
      ),
    );
  }
}