import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:lottie/lottie.dart';
import 'package:timer/main.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;
  bool soundPlayed = false;

  Future<void> showLottieAnimationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 280,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Lottie.asset(
                    'assets/confetti.json',
                    width: 240,
                    height: 240,
                    repeat: true,
                    animate: true,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Lottie.asset(
                    'assets/teeth.json',
                    width: 240,
                    height: 240,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                stopBeepSound(context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() async {
    if (countText == '0:00:00' && !soundPlayed) {
      soundPlayed = true; // Set the flag to prevent repeated sound playback
      await startBeepSound();
      showLottieAnimationDialog(context);
    }
  }

  bool isDialogOpen = false;

  Future<void> startBeepSound() async {
    await FlutterRingtonePlayer.playAlarm();
  }

  void playBombingSound() {
    FlutterRingtonePlayer.playAlarm();

    // Schedule the stop action after 3 seconds using a delayed future
    Future.delayed(const Duration(seconds: 3), () {
      FlutterRingtonePlayer.stop();
    });
  }

  void stopBeepSound(BuildContext context) {
    FlutterRingtonePlayer.stop();
    setState(() {
      controller.duration = const Duration(seconds: 10);
    });
    soundPlayed = false; // Reset the flag when stopping the sound
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: [
              const Text(
                'Timers',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor),
              ),
              const SizedBox(height: 20),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white),
                        child: const Text(
                          'Brushing Timer',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey.shade300,
                                value: progress,
                                strokeWidth: 6,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.isDismissed) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      height: 300,
                                      child: CupertinoTimerPicker(
                                        initialTimerDuration:
                                            controller.duration!,
                                        onTimerDurationChanged: (time) {
                                          setState(() {
                                            controller.duration = time;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) => Text(
                                  countText,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isAnimating) {
                                    controller.stop();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  } else {
                                    controller.reverse(
                                        from: controller.value == 0
                                            ? 1.0
                                            : controller.value);
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  }
                                },
                                icon: Icon(
                                  isPlaying == true
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  controller.reset();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.stop,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        child: Icon(
          icon,
          size: 36,
        ),
      ),
    );
  }
}
