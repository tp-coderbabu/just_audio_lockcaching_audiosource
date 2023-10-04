import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();
  bool isPlaying1 = false;
  bool isPlaying2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Working"),
                Material(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () async {
                      if (!isPlaying1) {
                        final audioSource = AudioSource.uri(
                          Uri.parse(
                              "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
                          tag: const MediaItem(id: "1", title: "Music"),
                        );
                        try {
                          await player1.setAudioSource(audioSource);
                        } catch (_) {}
                        player1.play();
                      } else {
                        player1.stop();
                      }
                      isPlaying1 = !isPlaying1;
                      setState(() {});
                    },
                    child: Icon(
                      isPlaying1 ? Icons.pause : Icons.play_arrow,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not Working"),
                Material(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () async {
                      if (!isPlaying2) {
                        final audioSource = LockCachingAudioSource(
                          Uri.parse(
                              "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
                          tag: const MediaItem(
                              id: '1', album: "Music", title: 'Music'),
                        );
                        try {
                          await player2.setAudioSource(audioSource);
                        } catch (_) {}
                        player2.play();
                      } else {
                        player2.stop();
                      }
                      isPlaying2 = !isPlaying2;
                      setState(() {});
                    },
                    child: Icon(
                      isPlaying2 ? Icons.pause : Icons.play_arrow,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
