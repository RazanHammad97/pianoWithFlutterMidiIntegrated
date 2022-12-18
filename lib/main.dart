import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


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
  String firstValue ='https://github.com/RazanHammad97';
  FlutterMidi fluttermidi = new FlutterMidi();

var actions =<String>[
    'Call',
    'Mail',
    'Page',
  ];

late int _action=0;
  //final Uri _url = Uri.parse('https://github.com/RazanHammad97');

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

  Future<void> _launchUrl(String? url) async {
    final Uri _url = Uri.parse(url!);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }


late String key;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  AppBar(
        title:  Center(child: Text(widget.title)),
        leading: DropdownButton<String>(
          value:  _action == null ? null : actions[_action],
          onChanged: (String? value) {
           // print(value);
            // This is called when the user selects an item.
            setState(() {
              //print(value);
              _action = actions.indexOf(value!);
              print(_action);


              if(_action ==0){
                _makePhoneCall('+970567203947');
              }

              if(_action ==1){
                _sendEmail('razanhammad97@gmail.com');
              }
              if(_action ==2){
                _launchUrl('https://github.com/RazanHammad97');
              }
              //print(firstValue);
              //_launchUrl(value);

            });
          },
          items: actions.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
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


class Action {
  const Action(this.name);
  final String name;
}


