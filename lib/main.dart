import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 FlutterMidi fluttermidi = new FlutterMidi();
 String sfFile = 'assets/Best of Guitars-4U-v1.0.sf2';
  @override
  void initState() {
    load(sfFile);
    super.initState();
  }

  void load(String asset) async {
    fluttermidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    fluttermidi.prepare(sf2: _byte);
  }
  @override
  Widget build(BuildContext context) {
      return CupertinoApp(
        title: 'Piano Demo',
        home: Center(
          child: InteractivePiano(
            highlightedNotes: [
              NotePosition(note: Note.C, octave: 3)
            ],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              // Use an audio library like flutter_midi to play the sound
              print(position.pitch);
              fluttermidi.playMidiNote(midi: position.pitch);
              //load('assets/KBH-Real-Choir-V2.5.sf2');
              // _playMusic(position.pitch);
            },
          ),
        ));
  }
}




//60 -- 84