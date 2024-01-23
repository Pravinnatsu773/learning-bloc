import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:learning_block/home/model/meditation_data_model.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({
    super.key,
    required this.data,
  });

  final MeditationDataModel data;

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final player = AudioPlayer();
  bool isInitialized = false;

  int prevSeconds = 0;

  @override
  void initState() {
    super.initState();
    playMusic();
  }

  playMusic() async {
    setState(() {
      isInitialized = false;
    });
    // final duration = await player.setAsset(// Load a URL
    //     'assets/audio/theta.mp3'); // Schemes: (https: | file: | asset: )
    // player.play(); // Play without waiting for completion

    // final duration = await player.setUrl(// Load a URL
    //     widget.audioUrl);
    final duration = await player.dynamicSet(url: widget.data.audio);
    player
        .play()
        .then((value) => setState(() {})); // Play while waiting for completion
    // await player.pause(); // Pause but remain ready to play
    // await player
    //     .seek(const Duration(seconds: 10)); // Jump to the 10 second position
    // await player.setSpeed(2.0); // Twice as fast
    // await player.setVolume(0.5); // Half as loud
    // await player.stop();

    player.durationStream.listen((event) {
      print(event);
    });

    player.positionStream.listen((e) {
      if (e.inSeconds > prevSeconds) {
        setState(() {
          prevSeconds = e.inSeconds;
        });
      } else {
        setState(() {
          prevSeconds = 0;
        });
      }
    });

    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.width * 0.65,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.data.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Text(
                widget.data.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 56,
              ),
              isInitialized ? SizedBox() : CircularProgressIndicator(),
              isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: player.duration == null
                            ? 0
                            : player.position.inSeconds /
                                player.duration!.inSeconds,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 24,
              ),
              isInitialized
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _replay();
                          },
                          child: const Icon(
                            Icons.replay_10_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (player.playing) {
                              player.pause();
                            } else {
                              player.play();
                            }

                            setState(() {});
                          },
                          child: Icon(
                            player.playing
                                ? Icons.pause_circle_outline_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 78,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _forward();
                          },
                          child: const Icon(
                            Icons.forward_10_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _replay() {
    final d = player.position;

    print('dddddd==>${d.inSeconds}');
    final c =
        d.inSeconds == 0 ? Duration.zero : Duration(seconds: d.inSeconds - 10);

    print('cccccc==>${c.inSeconds}');
    player.seek(c);
  }

  _forward() {
    final d = player.position;

    print('dddddd==>${d.inSeconds}');
    final c =
        d.inSeconds == 0 ? Duration.zero : Duration(seconds: d.inSeconds + 10);

    print('cccccc==>${c.inSeconds}');
    player.seek(c);
  }
}
