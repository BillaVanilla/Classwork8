import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babs Halloween Game',
      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 24, 1, 65)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Babs Halloween Game!!!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  late AnimationController controller;
  final AudioPlayer audioplay = AudioPlayer();  // Player for sound effects
  final AudioCache audiocargo = AudioCache();     // Cache for loading audio files
  bool shownmessage = false;
  String message = '';
  bool isGameOver = false;
  late StreamSubscription backgroundmusic;

 @override
  void initState() {
    super.initState();
    playbackgroundmusic();
    // Initialize animation
    controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

@override
  void dispose() {
    controller.dispose();
    audioplay.dispose();
    backgroundmusic?.cancel();
    super.dispose();
  }

   Future<void> playbackgroundmusic() async {
    audiocargo.load('assets/SSS.mp3');
    backgroundmusic = audioplay.onPlayerCompletion.listen((_) {
    audiocargo.play('SSS.mp3', volume: 0.8);
    });
    await audiocargo.play('SSS.mp3', volume: 0.8);
  }

Future<void> playtrapsound() async {
    await audiocargo.play('scream.mp3');
    setState(() {
      shownmessage = true;
      message = "You've been trapped!";
      isGameOver = true;
    });
  }

  Future<void> playWinningSound() async {
    await audiocargo.play('victory.mp3'); // Play victory sound
  }

void winitem() async {
    setState(() {
      shownmessage = true;
      message = "Congrats!!!! You Found It!";
      isGameOver = true;
    });
    await playWinningSound();
  }

 void resetGame() {
    setState(() {
      shownmessage = false;
      isGameOver = false;
      message = '';
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Spooky Halloween Game'),
      ),
      body: Stack(
        children: [
           Positioned.fill(
             child: Image.asset(
              'assets/spookcastle.jpg',
              fit: BoxFit.cover,
             ),
           ),
             // Animated Characters Lcoation
          animatedCharacter1('assets/zombie1.png', 0.03),
          animatedCharacter2('assets/zombie2.png', 0.054),
          animatedCharacter3('assets/zombie3.png', 0.05),
           // Hidden Winning Element
          Positioned(
          top: 200,
          left: 150,
          child: GestureDetector(
            onTap: isGameOver ? null : winitem,
              child: Image.asset('assets/closed closet.png', width: 60),  // Hidden closet location
            ),
          ),
           // Trap Child
          Positioned(
             top: 400,
            left: 100,
            child: GestureDetector(
            onTap: isGameOver ? null : playtrapsound,
            child: Image.asset('assets/cardboard box.png', width: 80),  // Cardboard box trap
            ),
          ),
          // Message Display and Reset Button
          if (shownmessage)
          Center(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                  padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 10, 10).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                     child: Text(
                        message,
                        style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        ),
                     ),
                  ),
                  const SizedBox(height: 20),
                   ElevatedButton(
                    onPressed: resetGame,
                    child: const Text("Play Again"),
                   ),
               ],
            ),
           ),
        ],
      ),
  );}

  // Zombie1
  Widget animatedCharacter1(String imagePath, double startPosition) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double randomPosition = Random().nextDouble() * MediaQuery.of(context).size.width;
        return Positioned(
          top: (startPosition + controller.value) * MediaQuery.of(context).size.height,
          right: randomPosition,
          child: child!,
        );
      },
      child: Image.asset(imagePath, width: 80),
    );
  }

  //Zombie2
  Widget animatedCharacter2(String imagePath, double startPosition) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double randomPosition = Random().nextDouble() * MediaQuery.of(context).size.width;
        return Positioned(
          top: (startPosition + controller.value) * MediaQuery.of(context).size.height,
          left: randomPosition,
          child: child!,
        );
      },
      child: Image.asset(imagePath, width: 120),
    );
  }

  //Zombie3
   Widget animatedCharacter3(String imagePath, double startPosition) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double randomPosition = Random().nextDouble() * MediaQuery.of(context).size.width;
        return Positioned(
          top: (startPosition + controller.value) * MediaQuery.of(context).size.height,
          left: randomPosition,
          child: child!,
        );
      },
      child: Image.asset(imagePath, width: 100),
    );
  }
}
