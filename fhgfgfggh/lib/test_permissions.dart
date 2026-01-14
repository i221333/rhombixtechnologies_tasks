import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Permission Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StoragePermissionPage(),
    );
  }
}

class StoragePermissionPage extends StatefulWidget {
  const StoragePermissionPage({super.key});

  @override
  _StoragePermissionPageState createState() => _StoragePermissionPageState();
}

class _StoragePermissionPageState extends State<StoragePermissionPage> {
  String _status = 'Unknown';

  Future<void> checkAndRequestPermission() async {
    Permission permission;

    if (Theme.of(context).platform == TargetPlatform.android) {
      permission = Permission.storage;
    } else {
      permission = Permission.photos;
    }

    final status = await permission.request();

    setState(() {
      if (status.isGranted) {
        _status = 'Permission Granted ✅';
      } else if (status.isDenied) {
        _status = 'Permission Denied ❌';
      } else if (status.isPermanentlyDenied) {
        _status = 'Permission Permanently Denied ❗';
      } else {
        _status = 'Permission Status: $status';
      }
    });

    if (status.isDenied) {
      // Opens settings so user can manually grant permission
      await openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    checkAndRequestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage Permission Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Storage Permission Status:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(_status, style: TextStyle(fontSize: 22, color: Colors.deepPurple)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: checkAndRequestPermission,
              child: Text('Request Again'),
            ),
          ],
        ),
      ),
    );
  }
}
