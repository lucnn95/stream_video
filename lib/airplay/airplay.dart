import 'package:flutter/material.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:stream_video/main.dart';

class Airplay extends StatefulWidget {
  const Airplay({Key? key}) : super(key: key);

  @override
  State<Airplay> createState() => _AirplayState();
}

class _AirplayState extends State<Airplay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              Text('Airplay'),
            ],
          ),
          leading: IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: const <Widget>[
            AirPlayRoutePickerView(
              tintColor: Colors.white,
              activeTintColor: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
        body: const SafeArea(
          child: Center(
            child: FlutterAVPlayerView(
              urlString: videoUrl,
            ),
          ),
        ),
      ),
    );
  }
}