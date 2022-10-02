import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/main.dart';
import 'package:video_player/video_player.dart';

class ChromeCast extends StatefulWidget {
  const ChromeCast({Key? key}) : super(key: key);

  @override
  State<ChromeCast> createState() => _ChromeCastState();
}

class _ChromeCastState extends State<ChromeCast> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) async {
        await _controller.play();
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              Text('Chromecast'),
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
          actions: <Widget>[
            ElevatedButton(
              child: const Icon(Icons.cast_outlined),
              onPressed: () async {
                await _showMyDialog();
              },
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller))
                : const CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cast to:', style: TextStyle(fontSize: 20)),
          content: const ChromecastRadar(),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ChromecastRadar extends StatefulWidget {
  const ChromecastRadar({Key? key}) : super(key: key);

  @override
  State<ChromecastRadar> createState() => _ChromecastRadarState();
}

class _ChromecastRadarState extends State<ChromecastRadar> {
  Future<List<CastDevice>>? _future;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<CastDevice>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString()}',
              ),
            );
          } else if (!snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
              ],
            );
          }
          if (snapshot.data!.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Center(
                  child: Text(
                    'No Chromecast founded',
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: snapshot.data!.map((device) {
              return ListTile(
                title: Text(device.name),
                onTap: () {
                  _connectAndPlayMedia(context, device);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  Future<void> _connectAndPlayMedia(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);
    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        var snackBar = const SnackBar(content: Text('Connected'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    var index = 0;
    session.messageStream.listen((message) {
      index += 1;

      if (index == 2) {
        Future.delayed(const Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // Need to update AppID
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    var message = {
      'contentId': videoUrl,
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED',
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': "Big Buck Bunny",
        'images': [
          {
            'url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg'
          }
        ]
      }
    };
    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}