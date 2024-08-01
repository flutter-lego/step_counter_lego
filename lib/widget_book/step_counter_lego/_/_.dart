import 'dart:io';

import 'package:daily_pedometer2/daily_pedometer2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  String _dailySteps = '?';

  @override
  void initState() {
    super.initState();
  }

  void getGrantedPermission() async {
    // iOS 권한 요청
    if (Platform.isIOS) {
      if (await Permission.sensors.isDenied) {
        await Permission.sensors.request();
      }
      if (!await Permission.sensors.isGranted) return;
    } else {
      // Android 권한 요청
      if (await Permission.activityRecognition.isDenied) {
        await Permission.activityRecognition.request();
      }
      if (!await Permission.activityRecognition.isGranted) return;
    }

    if (!mounted) return;

    DailyPedometer2.dailyStepCountStream.listen((event) {
      print(event);
      setState(() {
        _dailySteps = event.steps.toString();
      });
    }).onError((error) {
      print('onDailyStepCountError: $error');
      setState(() {
        _dailySteps = 'Daily Step Count not available';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // button
          ElevatedButton(
            onPressed: () {
              getGrantedPermission();
            },
            child: Text("Get Permission"),
          ),
          Divider(
            height: 100,
            thickness: 0,
            color: Colors.white,
          ),
          Text(
            'Daily Steps',
            style: TextStyle(fontSize: 30),
          ),
          Text(
            _dailySteps,
            style: TextStyle(fontSize: 60),
          ),
        ],
      ),
    );
  }
}


main() async {
  return runApp(MaterialApp(
    home: NewView(),
  ));
}