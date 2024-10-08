import 'dart:async';

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
       
        title: Text(widget.title),
      ),
      body: Center(
       
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
