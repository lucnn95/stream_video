import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stream_video/airplay/airplay.dart';
import 'package:stream_video/chromecase/cast.dart';

const videoUrl =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Stream Video',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[
            Text('Stream Video'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[buildStreamWidget()],
        ),
      ),
    );
  }

  Widget buildStreamWidget() {
    if (Platform.isAndroid) {
      return ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChromeCast(),
          ),
        ),
        title: const Text('Chromecast'),
        trailing: const Icon(Icons.chevron_right),
      );
    } else if (Platform.isIOS) {
      return ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Airplay(),
          ),
        ),
        title: const Text('Airplay'),
        trailing: const Icon(Icons.chevron_right),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Only iOS/Android are supported at this moment.'),
      );
    }
  }
}