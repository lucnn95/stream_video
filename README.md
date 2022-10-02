### [Getting Started](#getting-started)
* Flutter (Channel stable, 3.0.5)
* Dart 2.17.6
* Cocoapods 1.11.3

### [Main Packages](#main-packages)
* [`flutter_to_airplay`](https://pub.dev/packages/flutter_to_airplay)
  * This package is used to wirelessly send the content from any Apple device to another device that is enabled with AirPlay or Apple TV.
  * Platforms: iOS / iPadOS
* [`cast`](https://pub.dev/packages/cast): This package allows us to extend our Android app to direct its streaming video and audio to a TV or sound system.
  * Platform: Android
* [`video_player`](https://pub.dev/packages/video_player): A package allows our app to play videos.
  * Platforms: iOS, Android and Web

### [Installation](#installation)
* Add these packages to our package's pubspec.yaml file:
```
  flutter_to_airplay: ^2.0.2
  cast: ^1.1.1
  video_player: ^2.4.7
```
### [Usage](#usage)
* Use this widget in order to discover the Apple devices that are enabled with AirPlay or Apple TV.
```
AirPlayRoutePickerView(
    tintColor: #Colors,
    activeTintColor: #Colors,
    backgroundColor: #Colors,
)
```

* Use this widget to play videos on iOS/iPadOS devices.
```
FlutterAVPlayerView(
    urlString: #videoUrl,
),
```

* Use this function in order to discover the Android devices.
```
CastDiscoveryService().search()
```

* Use this widget to play videos on Android devices.
```
VideoPlayer(
    controller: #VideoPlayerController
)
```

### [How it works](#howitworks)
* [`Video`](https://drive.google.com/file/d/1diD1SpOaqyK2e0O4_NBEg5TzT1L_jhHD/view?usp=sharing)
