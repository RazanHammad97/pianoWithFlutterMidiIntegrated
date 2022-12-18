import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:flutter/services.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: 'Razan Piano'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sfFile = 'assets/Expressive Flute SSO-v1.2.sf2';
  FlutterMidi fluttermidi = new FlutterMidi();
  @override
  void initState() {
    load(sfFile);
    super.initState();
  }

  void load(String asset) async {
    fluttermidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    fluttermidi.prepare(sf2: _byte,name: sfFile.replaceAll('assets/', '')); // return back to this point
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: [
          DropdownButton<String>(
            value: sfFile,
            onChanged: (String? value) {
              print(value);
              // This is called when the user selects an item.
              setState(() {
                sfFile  = value!;
                load(sfFile);
              });
            },
            items: [DropdownMenuItem(value: 'assets/KBH-Real-Choir-V2.5.sf2',child: Text('Choir'),),
              DropdownMenuItem(value: 'assets/Best of Guitars-4U-v1.0.sf2',child: Text('Guitar'),)
              ,DropdownMenuItem(value:'assets/Expressive Flute SSO-v1.2.sf2',child: Text('Flute'))
            ],
          ),
        ],

      ),
      body:InteractivePiano(

        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 60,
        noteRange: NoteRange.forClefs([
          Clef.Treble,Clef.Bass,Clef.Alto,
        ]),
        onNotePositionTapped: (position) {
          // Use an audio library like flutter_midi to play the sound
          print(position.pitch);
          fluttermidi.playMidiNote(midi: position.pitch);
          fluttermidi.stopMidiNote(midi: position.pitch);

          //load('assets/KBH-Real-Choir-V2.5.sf2');
          // _playMusic(position.pitch);
        },
      ),

    );
  }
}