import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_dld/auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  static const String _title = 'Lorelei Group';

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
         home: Home(),
         title: _title,
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      );
  }
}

class Home extends  StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//-------------------------------------------
//Searching panel
//-------------------------------------------

  final String clientId = '673803ec3b544cc8b95e301fdcc11eb4';
  final String clientSecret = '9db381cc65fe4fcf87f1954a49d75150';
  final String redirectUri = 'my-spotify-app://callback';
  late String accessToken;

  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _searchResults = [];

  void _authenticate() async {
    final String url = 'https://accounts.spotify.com/api/token';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    final http.Response response = await http.post(Uri.parse(url), headers: {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'grant_type': 'client_credentials'
    });

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    setState(() {
      accessToken = responseData['access_token'];
    });
  }

  void _searchSongs(String query) async {
    final String url =
        'https://api.spotify.com/v1/search?q=$query&type=track&limit=10';
    final http.Response response =
        await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $accessToken'});
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    setState(() {
      _searchResults = responseData['tracks']['items'];
    });
  }

//-------------------------------------------
//Login & Register panel
//-------------------------------------------

  final User? user = Auth().currentUser;

  String? messageError = '';
  bool isLogin = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch(e) {
      setState(() {
        messageError = e.message;
      });
    }
  }

    Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch(e) {
      setState(() {
        messageError = e.message;
      });
    }
  }

    Widget _userUid() {
      return Text(user?.email ?? '$_controllerEmail');
    }

    Widget _entryField(
      String title,
      TextEditingController controller,
      ) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title
          ),
        );
    }

    Widget _erroeMessage(){
      return Text(messageError == '' ? '' : 'Error detect: ? $messageError');
    }

    Widget _subMitButton() {
      return ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword, 
        child: Text(isLogin ? 'Log in' : 'Register')
      );
    }

    Widget _LogOrRegButton() {
      return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        }, 
        child: Text(isLogin ? 'Go to Register' : 'Go to Log in')
      );
    }

    Future<void> signOut() async {
      await Auth().signOut();
    }

    Widget _signOutButton() {
      return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
    }

//-------------------------------------------
//Music panel
//-------------------------------------------

  int amaxduration = 100;
  int acurrentpos = 0;
  String acurrentpostlabel = "00:00";
  int bmaxduration = 100;
  int bcurrentpos = 0;
  String bcurrentpostlabel = "00:00";
  int cmaxduration = 100;
  int ccurrentpos = 0;
  String ccurrentpostlabel = "00:00";
  int lemaxduration = 100;
  int lecurrentpos = 0;
  String lecurrentpostlabel = "00:00";
  int limaxduration = 100;
  int licurrentpos = 0;
  String licurrentpostlabel = "00:00";
  int mmaxduration = 100;
  int mcurrentpos = 0;
  String mcurrentpostlabel = "00:00";
  int nmaxduration = 100;
  int ncurrentpos = 0;
  String ncurrentpostlabel = "00:00";
  int pmaxduration = 100;
  int pcurrentpos = 0;
  String pcurrentpostlabel = "00:00";
  int tmaxduration = 100;
  int tcurrentpos = 0;
  String tcurrentpostlabel = "00:00";
  int ymaxduration = 100;
  int ycurrentpos = 0;
  String ycurrentpostlabel = "00:00";
  bool aisplaying = false;
  bool aaudioplayed = false;
  bool bisplaying = false;
  bool baudioplayed = false;
  bool cisplaying = false;
  bool caudioplayed = false;
  bool leisplaying = false;
  bool leaudioplayed = false;
  bool liisplaying = false;
  bool liaudioplayed = false;
  bool misplaying = false;
  bool maudioplayed = false;
  bool nisplaying = false;
  bool naudioplayed = false;
  bool pisplaying = false;
  bool paudioplayed = false;
  bool tisplaying = false;
  bool taudioplayed = false;
  bool yisplaying = false;
  bool yaudioplayed = false;
  AudioCache? _audioCache;

  late Uint8List aimeraudiobytes;
  String aimeraudioasset = "assets/audios/Aimer.mp3";
  late Uint8List bpaudiobytes;
  String bpaudioasset = "assets/audios/BLACKPINK.mp3";
  late Uint8List cbaudiobytes;
  String cbaudioasset = "assets/audios/Clean Bandit.mp3";
  late Uint8List leaudiobytes;
  String leaudioasset = "assets/audios/LE SSERAFIM.mp3";
  late Uint8List liaudiobytes;
  String liaudioasset = "assets/audios/LiSA.mp3";
  late Uint8List miaudiobytes;
  String miaudioasset = "assets/audios/Mili.mp3";
  late Uint8List ngaudiobytes;
  String ngaudioasset = "assets/audios/NGT48.mp3";
  late Uint8List paaudiobytes;
  String paaudioasset = "assets/audios/PALMY.mp3";
  late Uint8List taaudiobytes;
  String taaudioasset = "assets/audios/TangBadVoice.mp3";
  late Uint8List yoaudiobytes;
  String yoaudioasset = "assets/audios/YOASOBI.mp3";

  AudioPlayer playera = AudioPlayer();
  AudioPlayer playerb = AudioPlayer();
  AudioPlayer playerc = AudioPlayer();
  AudioPlayer playerle = AudioPlayer();
  AudioPlayer playerli = AudioPlayer();
  AudioPlayer playerm = AudioPlayer();
  AudioPlayer playern = AudioPlayer();
  AudioPlayer playerp = AudioPlayer();
  AudioPlayer playert = AudioPlayer();
  AudioPlayer playery = AudioPlayer();


  @override
  void initState() {

    super.initState();
    _authenticate();
    _audioCache = AudioCache(fixedPlayer: playera);
    _audioCache = AudioCache(fixedPlayer: playerb);
    _audioCache = AudioCache(fixedPlayer: playerc);
    _audioCache = AudioCache(fixedPlayer: playerle);
    _audioCache = AudioCache(fixedPlayer: playerli);
    _audioCache = AudioCache(fixedPlayer: playerm);
    _audioCache = AudioCache(fixedPlayer: playern);
    _audioCache = AudioCache(fixedPlayer: playerp);
    _audioCache = AudioCache(fixedPlayer: playert);
    _audioCache = AudioCache(fixedPlayer: playery);

    Future.delayed(Duration.zero, () async {

       ByteData bytes = await rootBundle.load(aimeraudioasset); //load audio from assets
       aimeraudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(bpaudioasset); //load audio from assets
       bpaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(cbaudioasset); //load audio from assets
       cbaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(leaudioasset); //load audio from assets
       leaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(liaudioasset); //load audio from assets
       liaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(miaudioasset); //load audio from assets
       miaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(ngaudioasset); //load audio from assets
       ngaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(paaudioasset); //load audio from assets
       paaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(taaudioasset); //load audio from assets
       taaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       bytes = await rootBundle.load(yoaudioasset); //load audio from assets
       yoaudiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
       //convert ByteData to Uint8List

       playera.onDurationChanged.listen((Duration d) { //get the duration of audio
           amaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playera.onAudioPositionChanged.listen((Duration  p){
        acurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:acurrentpos).inHours;
          int sminutes = Duration(milliseconds:acurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:acurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          acurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerb.onDurationChanged.listen((Duration d) { //get the duration of audio
           bmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerb.onAudioPositionChanged.listen((Duration  p){
        bcurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:bcurrentpos).inHours;
          int sminutes = Duration(milliseconds:bcurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:bcurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          bcurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerc.onDurationChanged.listen((Duration d) { //get the duration of audio
           cmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerc.onAudioPositionChanged.listen((Duration  p){
        ccurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:ccurrentpos).inHours;
          int sminutes = Duration(milliseconds:ccurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:ccurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          ccurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerle.onDurationChanged.listen((Duration d) { //get the duration of audio
           lemaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerle.onAudioPositionChanged.listen((Duration  p){
        lecurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:lecurrentpos).inHours;
          int sminutes = Duration(milliseconds:lecurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:lecurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          lecurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerli.onDurationChanged.listen((Duration d) { //get the duration of audio
           limaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerli.onAudioPositionChanged.listen((Duration  p){
        licurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:licurrentpos).inHours;
          int sminutes = Duration(milliseconds:licurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:licurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          licurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerm.onDurationChanged.listen((Duration d) { //get the duration of audio
           mmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerm.onAudioPositionChanged.listen((Duration  p){
        mcurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:mcurrentpos).inHours;
          int sminutes = Duration(milliseconds:mcurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:mcurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          mcurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playern.onDurationChanged.listen((Duration d) { //get the duration of audio
           nmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playern.onAudioPositionChanged.listen((Duration  p){
        ncurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:ncurrentpos).inHours;
          int sminutes = Duration(milliseconds:ncurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:ncurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          ncurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playerp.onDurationChanged.listen((Duration d) { //get the duration of audio
           pmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playerp.onAudioPositionChanged.listen((Duration  p){
        pcurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:pcurrentpos).inHours;
          int sminutes = Duration(milliseconds:pcurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:pcurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          pcurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playert.onDurationChanged.listen((Duration d) { //get the duration of audio
           tmaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playert.onAudioPositionChanged.listen((Duration  p){
        tcurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:tcurrentpos).inHours;
          int sminutes = Duration(milliseconds:tcurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:tcurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          tcurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });

      playery.onDurationChanged.listen((Duration d) { //get the duration of audio
           ymaxduration = d.inMilliseconds; 
           setState(() {
             
           });
       });

      playery.onAudioPositionChanged.listen((Duration  p){
        ycurrentpos = p.inMilliseconds; //get the current position of playing audio

          //generating the duration label
          int shours = Duration(milliseconds:ycurrentpos).inHours;
          int sminutes = Duration(milliseconds:ycurrentpos).inMinutes;
          int sseconds = Duration(milliseconds:ycurrentpos).inSeconds;

          int rhours = shours;
          int rminutes = sminutes - (shours * 60);
          int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

          ycurrentpostlabel = "$rminutes:$rseconds";

          setState(() {
             //refresh the UI
          });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    playera!.dispose();
    playera.release();
    playerb!.dispose();
    playerb.release();
    playerc!.dispose();
    playerc.release();
    playerle!.dispose();
    playerle.release();
    playerli!.dispose();
    playerli.release();
    playerm!.dispose();
    playerm.release();
    playern!.dispose();
    playern.release();
    playerp!.dispose();
    playerp.release();
    playert!.dispose();
    playert.release();
    playery!.dispose();
    playery.release();
    super.dispose();
  }

  void _stopSong() async {
    await playera!.stop();
    await playerb!.stop();
    await playerc!.stop();
    await playerle!.stop();
    await playerli!.stop();
    await playerm!.stop();
    await playern!.stop();
    await playerp!.stop();
    await playert!.stop();
    await playery!.stop();
    setState(() {
      aaudioplayed = false;
      baudioplayed = false;
      caudioplayed = false;
      leaudioplayed = false;
      liaudioplayed = false;
      maudioplayed = false;
      naudioplayed = false;
      paudioplayed = false;
      taudioplayed = false;
      yaudioplayed = false;
    });
  }

//-------------------------------------------
//Build panel
//-------------------------------------------

  @override
  Widget build(BuildContext context) {

    //player.dispose();
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Music App'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.search), //search music
              ),
              Tab(
                icon: Icon(Icons.list), //music storage
              ),
              Tab(
                icon: Icon(Icons.wordpress), //lyrics
              ),
              Tab(
                icon: Icon(Icons.info), //info
              ),
              Tab(
                icon: Icon(Icons.login), //login
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'Enter song name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _searchQuery = _searchController.text.trim();
                            });
                            _searchSongs(_searchQuery);
                          },
                        )),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Search Results:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: _searchResults.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              final track = _searchResults[index];
                              return ListTile(
                                title: Text(track['name']),
                                subtitle: Text(track['artists'][0]['name']),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.play_arrow),
                                        onPressed: () {
                                          // Add song playing functionality here
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.download),
                                        onPressed: () {
                                          // Add download functionality here
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                        )
                        : const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!aisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          if(!aisplaying && !aaudioplayed) {
                            int result = await playera.playBytes(aimeraudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 aisplaying = true;
                                                 aaudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(aaudioplayed && !aisplaying){
                                          int result = await playera.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 aisplaying = true;
                                                 aaudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playera.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 aisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(acurrentpos.toString()),
                            min: 0,
                            max: double.parse(amaxduration.toString()),
                            divisions: amaxduration,
                            label: acurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playera.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    acurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('Aimer - Deep Down'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!bisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!bisplaying && !baudioplayed) {
                            int result = await playerb.playBytes(bpaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 bisplaying = true;
                                                 baudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(baudioplayed && !bisplaying){
                                          int result = await playerb.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 bisplaying = true;
                                                 baudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerb.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 bisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(bcurrentpos.toString()),
                            min: 0,
                            max: double.parse(bmaxduration.toString()),
                            divisions: bmaxduration,
                            label: bcurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerb.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    bcurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('BLACKPINK - Pink Venom'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!cisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!cisplaying && !caudioplayed) {
                            int result = await playerc.playBytes(cbaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 cisplaying = true;
                                                 caudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(caudioplayed && !cisplaying){
                                          int result = await playerc.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 cisplaying = true;
                                                 caudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerc.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 cisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(ccurrentpos.toString()),
                            min: 0,
                            max: double.parse(cmaxduration.toString()),
                            divisions: cmaxduration,
                            label: ccurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerc.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    ccurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('Clean Bandit - Symphony (feat. Zara Larsson)'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!leisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!leisplaying && !leaudioplayed) {
                            int result = await playerle.playBytes(leaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 leisplaying = true;
                                                 leaudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(leaudioplayed && !leisplaying){
                                          int result = await playerle.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 leisplaying = true;
                                                 leaudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerle.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 leisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(lecurrentpos.toString()),
                            min: 0,
                            max: double.parse(lemaxduration.toString()),
                            divisions: lemaxduration,
                            label: lecurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerle.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    lecurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('LE SSERAFIM - FEARLESS'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!liisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!liisplaying && !liaudioplayed) {
                            int result = await playerli.playBytes(liaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 liisplaying = true;
                                                 liaudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(liaudioplayed && !liisplaying){
                                          int result = await playerli.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 liisplaying = true;
                                                 liaudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerli.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 liisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(licurrentpos.toString()),
                            min: 0,
                            max: double.parse(limaxduration.toString()),
                            divisions: limaxduration,
                            label: licurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerli.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    licurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('LiSA - unlasting'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!misplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!misplaying && !maudioplayed) {
                            int result = await playerm.playBytes(miaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 misplaying = true;
                                                 maudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(maudioplayed && !misplaying){
                                          int result = await playerm.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 misplaying = true;
                                                 maudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerm.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 misplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(mcurrentpos.toString()),
                            min: 0,
                            max: double.parse(mmaxduration.toString()),
                            divisions: mmaxduration,
                            label: mcurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerm.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    mcurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('Mili - Nine Point Eight'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!nisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!nisplaying && !naudioplayed) {
                            int result = await playern.playBytes(ngaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 nisplaying = true;
                                                 naudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(naudioplayed && !nisplaying){
                                          int result = await playern.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 nisplaying = true;
                                                 naudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playern.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 nisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(ncurrentpos.toString()),
                            min: 0,
                            max: double.parse(nmaxduration.toString()),
                            divisions: nmaxduration,
                            label: ncurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playern.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    ncurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('NGT48 - Wataridoritachini Sorahamienai'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!pisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!pisplaying && !paudioplayed) {
                            int result = await playerp.playBytes(paaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 pisplaying = true;
                                                 paudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(paudioplayed && !pisplaying){
                                          int result = await playerp.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 pisplaying = true;
                                                 paudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playerp.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 pisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(pcurrentpos.toString()),
                            min: 0,
                            max: double.parse(pmaxduration.toString()),
                            divisions: pmaxduration,
                            label: pcurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playerp.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    pcurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('PALMY - ซ่อนกลิ่น'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!tisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!tisplaying && !taudioplayed) {
                            int result = await playert.playBytes(taaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 tisplaying = true;
                                                 taudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(taudioplayed && !tisplaying){
                                          int result = await playert.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 tisplaying = true;
                                                 taudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playert.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 tisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(tcurrentpos.toString()),
                            min: 0,
                            max: double.parse(tmaxduration.toString()),
                            divisions: tmaxduration,
                            label: tcurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playert.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    tcurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('TangBadVoice - ชม'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius:  20,
                      child: IconButton(
                        icon: Icon(!yisplaying ? Icons.play_arrow : Icons.pause),
                        iconSize: 20,
                        onPressed: () async {
                          
                          if(!yisplaying && !yaudioplayed) {
                            int result = await playery.playBytes(yoaudiobytes);
                                          if(result == 1){ //play success
                                              setState(() {
                                                 yisplaying = true;
                                                 yaudioplayed = true;
                                              });
                                          }else{
                                              print("Error while playing audio."); 
                                          }
                          } else if(yaudioplayed && !yisplaying){
                                          int result = await playery.resume();
                                          if(result == 1){ //resume success
                                              setState(() {
                                                 yisplaying = true;
                                                 yaudioplayed = true;
                                              });
                                          }else{
                                              print("Error on resume audio."); 
                                          }
                          }else{
                                          int result = await playery.pause();
                                          if(result == 1){ //pause success
                                              setState(() {
                                                 yisplaying = false;
                                              });
                                          }else{
                                              print("Error on pause audio."); 
                                          }
                                      }
                        }
                      ),
                    ),
                    title: Slider(
                      value: double.parse(ycurrentpos.toString()),
                            min: 0,
                            max: double.parse(ymaxduration.toString()),
                            divisions: ymaxduration,
                            label: ycurrentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await playery.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    ycurrentpos = seekval;
                               }else{
                                    print("Seek unsuccessful.");
                               }
                            },
                    ),
                    subtitle: const Text('YOASOBI - Sangenshoku'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
            ],
            ),
            ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Aimer()),
                        );
                      },
                    ),
                    title: const Text('Deep Down'),
                    subtitle: const Text('Aimer'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BP()),
                        );
                      },
                    ),
                    title: const Text('Pink Venom'),
                    subtitle: const Text('BLACKPINK'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Clean()),
                        );
                      },
                    ),
                    title: const Text('Symphony'),
                    subtitle: const Text('Clean Bandit (feat. Zara Larsson)'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LE()),
                        );
                      },
                    ),
                    title: const Text('FEARLESS'),
                    subtitle: const Text('LE SSERAFIM'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiSA()),
                        );
                      },
                    ),
                    title: const Text('unlasting'),
                    subtitle: const Text('LiSA'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Mili()),
                        );
                      },
                    ),
                    title: const Text('Nine Point Eight'),
                    subtitle: const Text('Mili'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NGT48()),
                        );
                      },
                    ),
                    title: const Text('Wataridoritachini Sorahamienai'),
                    subtitle: const Text('NGT48'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PALMY()),
                        );
                      },
                    ),
                    title: const Text('ซ่อนกลิ่น'),
                    subtitle: const Text('PALMY'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TangBadVoice()),
                        );
                      },
                    ),
                    title: const Text('ชม'),
                    subtitle: const Text('TangBadVoice'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: ElevatedButton(
                      child: const Text('Lyrics'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const YOASOBI()),
                        );
                      },
                    ),
                    title: const Text('Sangenshoku'),
                    subtitle: const Text('YOASOBI'),
                  ),
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Deep Down'),
                          content: const Text("Artist: Aimer"
                          "\nAlbum: Deep down"
                          "\nReleased: 2022"
                          "\nGenre: J-Pop"
                          "\nLyricist: aimerrhythm"
                          "\nComposer: Kazuma Nagasawa"
                          "\nArranger: Kenji Tamai・Rui Momota"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Deep Down'),
                    subtitle: const Text('Aimer'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Pink Venom'),
                          content: const Text("Artist: BLACKPINK"
                          "\nAlbum: Born Pink"
                          "\nReleased: 2022"
                          "\nGenre: Hip hop music, Electronic dance music, Dance-pop, Indian Film Pop, Pop rap, Korean Dance, K-Pop"
                          "\nLyricist: TEDDY・Danny Chung"
                          "\nComposer: TEDDY・24・R.Tee・IDO"
                          "\nArranger: 24・R.Tee・IDO"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Pink Venom'),
                    subtitle: const Text('BLACKPINK'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Symphony'),
                          content: const Text("Artist: Clean Bandit (feat. Zara Larsson)"
                          "\nAlbum: So Good"
                          "\nReleased: 2017"
                          "\nGenre: Dance music, Dance-pop, Dance/Electronic, Pop, Country"
                          "\nLyricist: Ammar Malik, Ina Wroldsen, Jack Patterson, Steve Mac"
                          "\nComposer: Clean Bandit"
                          "\nArranger: Ammar Malik, Ina Wroldsen, Jack Patterson, Steve Mac"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Symphony'),
                    subtitle: const Text('Clean Bandit (feat. Zara Larsson)'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('FEARLESS'),
                          content: const Text("Artist: LE SSEERAFIM"
                          "\nAlbum: FEARLESS"
                          "\nReleased: 2022"
                          "\nGenre: Dance-pop, Indian Film Pop, Alternative pop, Korean Dance, Dance/Electronic, K-Pop"
                          "\nLyricist: SCORE (13)・Megatone (13)・Supreme Boi・BLVSH・JARO・Nikolay Mohr・'Hitman' Bang・Oneye・Josefin Glenmark・emmy kasai・Kyler Niko・PAU・Destiny Rogers"
                          "\nComposer: SCORE (13)・Megatone (13)・Supreme Boi・BLVSH・JARO・Nikolay Mohr・'Hitman' Bang・Oneye・Josefin Glenmark・emmy kasai・Kyler Niko・PAU・Destiny Rogers"
                          "\nArranger: -"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('FEARLESS'),
                    subtitle: const Text('LE SSERAFIM'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('unlasting'),
                          content: const Text("Artist: LiSA"
                          "\nAlbum: Leo-Nine"
                          "\nReleased: 2020"
                          "\nGenre: J-Pop"
                          "\nLyricist: LiSA"
                          "\nComposer: Kayoko Kusano"
                          "\nArranger: Shota Horie"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('unlasting'),
                    subtitle: const Text('LiSA'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Nine Point Eight'),
                          content: const Text("Artist: Mili"
                          "\nAlbum: Mag Mell"
                          "\nReleased: 2013"
                          "\nGenre: Dance/Electronic, Vocaloid Utaite, Seasonal, J-Pop"
                          "\nLyricist: momocashew"
                          "\nComposer: momocashew & Yamato Kasai"
                          "\nArranger: Yamato Kasai & Soshi Isaka"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Nine Point Eight'),
                    subtitle: const Text('Mili'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Wataridoritachini Sorahamienai'),
                          content: const Text("Artist: NGT48"
                          "\nAlbum: 渡り鳥たちに空は見えない"
                          "\nReleased: 2022"
                          "\nGenre: J-Pop"
                          "\nLyricist: Yasushi Akimoto"
                          "\nComposer: Shuho Mitani"
                          "\nArranger: Nonaka 'Masa' Yuichi"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Wataridoritachini Sorahamienai'),
                    subtitle: const Text('NGT48'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ซ่อนกลิ่น'),
                          content: const Text("Artist: PALMY"
                          "\nAlbum: ซ่อนกลิ่น"
                          "\nReleased: 2018"
                          "\nGenre: Rock"
                          "\nLyricist: PALMY, วีรณัฐ ทิพยมณฑล, พีระนัต สุขสำราญ"
                          "\nComposer: PALMY, วีรณัฐ ทิพยมณฑล"
                          "\nArranger: อธิราช ปิ่นทอง, อธิชนม์ ปิ่นทอง, เจนวิทย์ จันทร์ปัญญาวงศ์, กฤติธี แสงดี"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('ซ่อนกลิ่น'),
                    subtitle: const Text('PALMY'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ชม'),
                          content: const Text("Artist: TangBadVoice"
                          "\nAlbum: TANGBADALBUM"
                          "\nReleased: 2023"
                          "\nGenre: Rap, Hip hop music"
                          "\nLyricist: TangBadVoice"
                          "\nComposer: BILLbilly01"
                          "\nArranger: BILLbilly01, Henry Watkins"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('ชม'),
                    subtitle: const Text('TangBadVoice'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Sangenshoku'),
                          content: const Text("Artist: YOASOBI"
                          "\nAlbum: The Book 2"
                          "\nReleased: 2021"
                          "\nGenre: Vocaloid Utaite, J-Pop"
                          "\nLyricist: Ayase"
                          "\nComposer: Ayase"
                          "\nArranger: -"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Back'),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ), child: const Text('Info'),
                    ),
                    title: const Text('Sangenshoku'),
                    subtitle: const Text('YOASOBI'),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: Auth().authStateChanges,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _userUid(),
                        _signOutButton()
                      ]
                    )
                  );
                } else {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _entryField('Email', _controllerEmail),
                        _entryField('Password', _controllerPassword),
                        _LogOrRegButton(),
                        _erroeMessage(),
                        _subMitButton()
                      ]
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class Aimer extends StatelessWidget {
  const Aimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Down'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text('[Verse 1]'
'\nInochi no himei, todae yami e'
'\nToketara kotonoha wo chirashita'
'\nFukai, fukai, madoromi e'
'\nNemureru you akai yubi de sonome wo toji'
'\n'
'\n[Pre-Chorus]'
'\nOsoreru you ni'
'\nChi ni oboreru kairitsu no you ni'
'\nKizuguchi ni furu ame no you ni'
'\nItami kizamitsukete'
'\nSamayou mure no naka de'
'\nIkitsuku basho ni kidzukenai mama'
'\nMatahitotsu kaketa'
'\n'
'\n[Chorus]'
'\nWakaranai, wakaritai'
'\nHirou koto naku mata sute yuku namida'
'\nTodokanai kikoenai'
'\nSugari tsuku koe yobi samasu zaregoto'
'\nNakushita mono wo wasureta'
'\nSukima ni sumi tsuite iru kage'
'\nItsukara soko ni ite, waratte ta'
'\nI feel you deep, deep, deep, deep down'
'\n'
'\n[Verse 2]'
'\nSetsuna no hisame'
'\nUta reme same'
'\nZawameku tsugegoto wo chigashita'
'\nAwai, awai maboroshi wo'
'\nFurikireba itsuwari ga rinkaku wo ukage'
'\n'
'\n[Instrumental Bridge]'
'\n'
'\n[Pre-Chorus]'
'\nHirefusu you ni'
'\nMune ni ugatsu kusabi no you ni'
'\nIki wo tome aragau hodo ni'
'\nKioku wo hikisaite'
'\nSurikireru kibou wo'
'\nAseta sekai ni yakitsuketa mama'
'\nTada tsunagi tometa'
'\n'
'\n[Chorus]'
'\nHanarenai, hanashitai'
'\nIeru koto naku matsuwari tsuku kizashi'
'\nModorenai, hibikanai'
'\nSurinuketa koe kakinarashita kodou'
'\nNegatta mono wo te ni shita'
'\nKanbi to soushitsu ni noma re'
'\nDorehodo nagai toki wo tadotteta'
'\n'
'\n[Outro]'
'\nI call you deep, deep, deep, deep'
'\nDeep, deep, deep, deep down'),
        ),
      ),
    );
  }
}

class BP extends StatelessWidget {
  const BP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pink Venom'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text("[Intro: All]"
"\nBLACKPINK, BLACKPINK"
"\nBLACKPINK, BLACKPINK"
"\n"
"\n[Verse 1: Jennie, Lisa]"
"\nKick in the door, waving the coco"
"\nPapkonina chaenggyeo kkyeodeul saenggak malgo"
"\nI talk that talk, runways I walk, walk"
"\nNun gamgo pop, pop an bwado cheok"
"\nOne by one, then two by two"
"\nNae sonkkeut tuk hanae da muneojineun jung"
"\nGajja syo chigon hwaryeohaetji"
"\nMakes no sense, you couldn't get a dollar outta me"
"\n"
"\n[Pre-Chorus: Rosé, Jisoo]"
"\nJa oneul bamiya"
"\nNan dogeul pumeun kkot"
"\nNe honeul ppaeaseun daeum"
"\nLook what you made us do"
"\nCheoncheonhi neol jamjaeul fire (Fire)"
"\nJaninhal mankeum areumdawo"
"\nI bring the pain like"
"\n"
"\n[Chorus: Jennie, Lisa]"
"\nThis that pink venom"
"\nThis that pink venom"
"\nThis that pink venom"
"\nGet 'em, get 'em, get 'em"
"\nStraight to ya dome like"
"\nWoah, woah, woah"
"\nStraight to ya dome like"
"\nAh, ah, ah"
"\nTaste that pink venom"
"\nTaste that pink venom"
"\nTaste that pink venom"
"\nGet 'em, get 'em, get 'em"
"\nStraight to ya dome like"
"\nWoah, woah, woah"
"\nStraight to ya dome like"
"\nAh, ah, ah"
"\n"
"\n[Verse 2: Lisa, Jennie]"
"\nBlack paint and ammo, got bodies like Rambo"
"\nRest in peace, please light up a candle"
"\nThis the life of a vandal, masked up and I'm still in CELINE"
"\nDesigner crimes or it wouldn't be me, ooh"
"\nDiamonds shining, drive in silence, I don't mind it, I'm riding"
"\nFlying private side by side with the pilot up in the sky"
"\nAnd I'm wilding, styling on them and there's no chance"
"\n'Cause we got bodies on bodies like this a slow dance"
"\n"
"\n[Pre-Chorus: Jisoo, Rosé]"
"\nJa oneul bamiya"
"\nNan dogeul pumeun kkot"
"\nNe honeul ppaeaseun daeum"
"\nLook what you made us do"
"\nCheoncheonhi neol jamjaeul fire (Fire)"
"\nJaninhal mankeum areumdawo"
"\nI bring the pain like"
"\n"
"\n[Chorus: Lisa, Jennie]"
"\nThis that pink venom"
"\nThis that pink venom"
"\nThis that pink venom"
"\nGet 'em, get 'em, get 'em"
"\nStraight to ya dome like"
"\nWoah, woah, woah"
"\nStraight to ya dome like"
"\nAh, ah, ah"
"\nTaste that pink venom"
"\nTaste that pink venom"
"\nTaste that pink venom"
"\nGet 'em, get 'em, get 'em"
"\nStraight to ya dome like"
"\nWoah, woah, woah"
"\nStraight to ya dome like"
"\nAh, ah, ah"
"\n"
"\n[Bridge: Rosé, Jisoo, Rosé & Jisoo, Lisa]"
"\nWonhandamyeon provoke us"
"\nGamdang mothae and you know this"
"\nImi peojyeobeorin shot that potion"
"\nNe nunapeun pingkeubit ocean"
"\nCome and give me all the smoke"
"\nDo animyeon mo like I'm so rock and roll"
"\nCome and give me all the smoke"
"\nDa jul sewo bwa ja stop, drop"
"\nI bring the pain like"
"\n"
"\n[Outro: Jennie, Lisa, All]"
"\nBrra-ta-ta-ta, trra-ta-ta-ta"
"\nBrra-ta-ta-ta, trra-ta-ta-ta"
"\nBrra-ta-ta-ta, trra-ta-ta-ta"
"\nStraight to ya, straight to ya, straight to ya dome like"
"\nBrra-ta-ta-ta, trra-ta-ta-ta (BLACKPINK)"
"\nBrra-ta-ta-ta, trra-ta-ta-ta (BLACKPINK)"
"\nBrra-ta-ta-ta, trra-ta-ta-ta (BLACKPINK)"
"\nI bring the pain like"),
        ),
      ),
    );
  }
}

class Clean extends StatelessWidget {
  const Clean({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symphony'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text("I've been hearing symphonies"
"\nBefore, all I heard was silence"
"\nA rhapsody for you and me"
"\nAnd every melody is timeless"
"\nLife was stringing me along"
"\nThen you came and you cut me loose"
"\nWas solo, singing on my own"
"\nNow I can't find the key without you"
"\n"
"\nAnd now your song is on repeat"
"\nAnd I'm dancin' on to your heartbeat"
"\nAnd when you're gone, I feel incomplete"
"\nSo, if you want the truth"
"\n"
"\nI just wanna be part of your symphony"
"\nWill you hold me tight and not let go?"
"\nSymphony"
"\nLike a love song on the radio"
"\nWill you hold me tight and not let go?"
"\n"
"\nI'm sorry if it's all too much"
"\nEvery day you're here, I'm healing"
"\nAnd I was runnin' out of luck"
"\nI never thought I'd find this feeling"
"\n'Cause I've been hearing symphonies"
"\nBefore all I heard was silence"
"\nA rhapsody for you and me"
"\n(A rhapsody for you and me)"
"\nAnd every melody is timeless"
"\n"
"\nAnd now your song is on repeat"
"\nAnd I'm dancin' on to your heartbeat"
"\nAnd when you're gone, I feel incomplete"
"\nSo, if you want the truth"
"\n"
"\nI just wanna be part of your symphony"
"\nWill you hold me tight and not let go?"
"\nSymphony"
"\nLike a love song on the radio"
"\nWill you hold me tight and not let go?"
"\n"
"\nAh, ah, ah, ah, ah, ah"
"\nAh ah, ah"
"\nAh, ah, ah, ah, ah, ah"
"\nAh ah, ah"
"\n"
"\nAnd now your song is on repeat"
"\nAnd I'm dancin' on to your heartbeat"
"\nAnd when you're gone, I feel incomplete"
"\nSo, if you want the truth (oh)"
"\n"
"\nI just wanna be part of your symphony"
"\nWill you hold me tight and not let go?"
"\nSymphony"
"\nLike a love song on the radio"
"\nSymphony"
"\nWill you hold me tight and not let go?"
"\nSymphony"
"\nLike a love song on the radio"
"\nWill you hold me tight and not let go?"),
        ),
      ),
    );
  }
}

class LE extends StatelessWidget {
  const LE({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEARLESS'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text("[Intro: Sakura]"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\n"
"\n[Verse 1: Garam, Chaewon, Yunjin, Kazuha]"
"\nJeil nopeun gose nan dakil wonhae"
"\nNeukkyeosseo nae answer"
"\nNae hyeolgwan soge nalttwineun new wave"
"\nNae geodaehan passion"
"\nGwansim eopseo gwageoe"
"\nModuga algo inneun geu troublee, huh"
"\nI'm fearless, a new bitch"
"\nNew crazy, ollaga, next one"
"\n"
"\n[Pre-Chorus: Chaewon, Sakura, Yunjin, Eunchae, (All)]"
"\n(Woah-oh-oh-oh-oh) Balbajwo, highway, highway"
"\n(Woah-oh-oh-oh-oh) Meotjin gyeolmare dake"
"\nNae hyungjimdo naui ilburamyeon"
"\n(Woah-oh-oh-oh-oh) Geobi nan eopji, eopji"
"\n"
"\n[Chorus: Sakura, Chaewon]"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\nYou should get away, get a, get a, get away"
"\nDachiji anke, dachi-dachiji anke"
"\nYou should get away, get a, get a, get away"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\n"
"\n[Refrain: Sakura]"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\n"
"\n[Verse 2: Yunjin, Kazuha]"
"\nYoksimeul sumgiraneun"
"\nNe maldeureun isanghae"
"\nGyeomsonhan yeongi gateun geon"
"\nDeo isang an hae"
"\nGajyeowa forever win naege, ayy"
"\nGaseumpage sutja il naege, ayy"
"\nNae miteuro joarin segye, ayy"
"\nTake the world, break it down, break you down, down"
"\n"
"\n[Pre-Chorus: Yunjin, Eunchae, Chaewon, Sakura, (All)]"
"\n(Woah-oh-oh-oh-oh) Balbajwo, highway, highway"
"\n(Woah-oh-oh-oh-oh) Meotjin gyeolmare dake"
"\nNae hyungjimdo naui ilburamyeon"
"\n(Woah-oh-oh-oh-oh) Geobi nan eopji, eopji"
"\n"
"\n[Chorus: Garam, Chaewon]"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\nYou should get away, get a, get a, get away"
"\nDachiji anke, dachi-dachiji anke"
"\nYou should get away, get a, get a, get away"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\n"
"\n[Refrain: Sakura]"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam-bam"
"\nBam"
"\nBa-ba-ba-bam-bam"
"\nBa-ba-ba-bam"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\n"
"\n[Bridge: Sakura, Garam, Chaewon, Yunjin]"
"\n(Bam, ba-ba-ba-bam-bam)"
"\nDeoneun eopseo paebae"
"\n(Ba-ba-ba-bam-bam, ba-ba-ba-bam-bam)"
"\nJunbidoen nae payback"
"\n(Bam, ba-ba-ba-bam-bam)"
"\nBring it, dangjang naege"
"\n(Ba-ba-ba-bam)"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\n"
"\n[Chorus: Yunjin, Kazuha, Garam]"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nWhat you lookin' at? What you, what you lookin' at?"
"\nMm-mm-mm-mm, I'm fearless, huh"
"\nYou should get away, get a, get a, get away"
"\nDachiji anke, dachi-dachiji anke"
"\nYou should get away, get a, get a, get away"
"\nMm-mm-mm-mm, I'm fearless, huh"),
        ),
      ),
    );
  }
}

class LiSA extends StatelessWidget {
  const LiSA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('unlasting'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text('[Verse 1]'
'\nHitorikiri demo'
'\nHeiki to koboreochita tsuyogari'
'\nFutari no mabushi sugita hi ga'
'\nKonna ni kanashii'
'\n'
'\n[Pre-Chorus]'
'\nHitori de ikirareru nara'
'\nDareka wo aishitari shinai kara'
'\n'
'\n[Chorus]'
'\nAnata no kaori anata no hanashi kata'
'\nIma mo karadajuu ni ai no kakera ga nokotteru yo'
'\nWatashi no negai watashi no negai wa tada'
'\nDou ka anata mo dokoka de naite imasu you ni'
'\n'
'\n[Verse 2]'
'\nItsumo atarashii ippo wa'
'\nOmokute sabishii'
'\n'
'\n[Pre-Chorus]'
'\nMoshi umarekawattemo'
'\nMou ichido anata ni deaitai'
'\n'
'\n[Chorus]'
'\nManatsu no hizashi mafuyu no shiroi yuki'
'\nMeguru kisetsujuu ni ai no kakera ga maiochite'
'\nShiawase na no ni dokoka de sabishii no wa'
'\nAnata yori mo ookina watashi no ai no sei'
'\n'
'\n[Bridge]'
'\nKagi wa anata ga motta mama'
'\nUtau imi wo nakushita kanaria'
'\nKurai torikago no naka de'
'\n'
'\n[Chorus]'
'\nAnata no kaori anata no hanashi kata'
'\nIma mo karadajuu ni ai no kakera ga nokotteru yo'
'\nWatashi no negai watashi no negai wa tada'
'\nDou ka anata ga shiawase de arimasu you ni'
'\n'
'\n[Post-Chorus]'
'\nOh, ooh-woah, oh'
'\nUnlasting world'
'\nThe course of love'
'\nForever thinking of you'),
        ),
      ),
    );
  }
}

class Mili extends StatelessWidget {
  const Mili({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nine Point Eight'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text("[Intro]"
"\nYou ready?"
"\n"
"\n[Verse 1]"
"\nCalla lily, carnation, daisy"
"\nSilently chase away your worries"
"\nChrysanthemum, kalanchoe"
"\nBecome your shield whenever you fall asleep"
"\nI cried out"
"\nPlease don't leave me behind, leave me behind"
"\nSo you held me tight"
"\nAnd said I will be just fine"
"\nI will be just fine, I will be just fine"
"\n"
"\n[Chorus]"
"\nPetals dance for our valediction"
"\nAnd synchronize to your frozen pulsation"
"\nTake me to where your soul may live in peace"
"\nFinal destination"
"\nTouch of your skin sympathetically brushed against"
"\nThe shoulders you used to embrace"
"\nSparkling ashes drift along your flames"
"\nAnd softly merge into the sky"
"\n"
"\n[Verse 2]"
"\nLisianthus aroma drags me out of where I was"
"\nCream rose, stargazer, iris"
"\nConstruct the map that helps me trace your steps"
"\nZips my mouth"
"\nI just keep climbing up, keep climbing up"
"\nJustify our vows I know you are right above"
"\nYou are right above, you are right above"
"\n"
"\n[Verrse 3]"
"\nLook now"
"\nI'm on the top of your world, top of your world"
"\nMy darling, here I come, I yell"
"\nAnd take a leap to Hell"
"\n"
"\n[Chorus]"
"\nSwirling wind sings for our reunion"
"\nAnd nine point eight is my acceleration"
"\nTake me to where our souls may live in peace"
"\nOur brand new commencement"
"\nTouch of your lips compassionately pressed against"
"\nThe skull that you used to cherish"
"\nDelicate flesh decomposes off my rotten bones"
"\nAnd softly merge into the sky"),
        ),
      ),
    );
  }
}

class NGT48 extends StatelessWidget {
  const NGT48({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wataridoritachini Sorahamienai'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text('どこまで行けば 夜明けが見える?'
'\n暗闇の中で汽車を待つステーション'
'\n思い出だけじゃ生きていけない'
'\n明日のために愛を探しに行こう'
'\n心の羽根 (もし傷ついても)'
'\n羽ばたくこと (決してやめはしない)'
'\n'
'\n過ぎてく時間 感じないまま大人になるものか'
'\n「僕たちは ずっと夢を見続ける」'
'\n渡り鳥たちに空は見えない'
'\n飛んでいるのはどこなのか?'
'\n'
'\n今 風に逆らい'
'\n進もうとしている'
'\n渡り鳥たちに地図なんてない'
'\nひたすら本能的に'
'\nいくつもの (海流) 荒波を (越えて)'
'\n大陸を目指している'
'\n青春の群像'
'\n'
'\n都会の暮らし 好きになれずに'
'\nあれから何度 帰ろうとしただろう'
'\n記憶の底 (沈澱している)'
'\n甘く苦い (忘れられぬ痛み)'
'\n疲れ果てても休めなくて無理した遠い日々'
'\n'
'\n「今になってわかることがある」'
'\n季節は巡り 旅は始まる'
'\n僕はどうして行くのだろう?'
'\nこの羽根は自然に'
'\n動いてしまうよ'
'\n'
'\n季節は巡り 逞しくなり'
'\n若さは道を切り拓く'
'\n懐かしい (あの人) 想うのは (恋か)'
'\n故郷を覚えている'
'\n夕焼けの美しさ'
'\n'
'\n行ったり来たりしてるのは'
'\n飛び出した街と憧れた街'
'\n窓の景色は変わらない'
'\n眺める自分だけが変わった'
'\n大人になるっていうことは'
'\n何かに慣れることですか?'
'\n刺激もやがて失くなって'
'\n当たり前のように春が来る'
'\n'
'\n心の羽根 (もし傷ついても)'
'\n羽ばたくこと (決してやめはしない)'
'\n過ぎてく時間 感じないまま大人になるものか'
'\n「僕たちは 今 どこにいるんだろう?」'
'\n'
'\n渡り鳥たちに空は見えない'
'\n飛んでいるのはどこなのか?'
'\n今 風に逆らい'
'\n進もうとしている'
'\n渡り鳥たちに地図なんてない'
'\nひたすら本能的に'
'\nいくつもの (海流) 荒波を (越えて)'
'\n大陸を目指している'
'\n青春の群像'
'\n夢見るか 諦めるか?'),
        ),
      ),
    );
  }
}

class PALMY extends StatelessWidget {
  const PALMY({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ซ่อนกลิ่น'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text('ลมอ่อนพัดโชยมา น้ำตาก็ไหลริน'
'\nเหลือเพียงกลิ่นหัวใจ คลุ้งไปกับความเหงา'
'\nรักยังไม่จางไป ตรึงติดชิดดวงใจ'
'\nยังหอมรัญจวนชวนให้ฝัน'
'\n'
'\nเคยแอบแนบเคียงกาย อิงแอบมิรู้คลาย'
'\nใต้เงาของแสงจันทร์ เย้ายวนไม่เลือนหาย'
'\nซ่อนเก็บไว้ข้างใน ตรงสุดลึกดวงใจ'
'\nถนอมเธออยู่ในนั้น'
'\n'
'\nคงไว้ได้แค่กลิ่น ที่ไม่เคยเลือนลา'
'\nยังหอมดังวันเก่า ยามเมื่อลมโชยมา'
'\nทิ้งไว้เพียงอดีต ที่ไม่เคยหวนมา'
'\nซ่อนเธอไว้ในใจ'
'\n'
'\nเจ้าดอกไม้ซ่อนกลิ่น หอมบาดลึกเกินใคร'
'\nหอมเกินหักห้ามใจ ทุกคราวต้องหวั่นไหว'
'\nร้อยเก็บเจ้ามาลัย ทัดเธอไว้ในใจ'
'\nเพื่อคงกลิ่นหอมไว้อย่างนั้น'
'\n'
'\nคงไว้ได้แค่กลิ่น ที่ไม่เคยเลือนลา'
'\nยังหอมดังวันเก่า ยามเมื่อลมโชยมา'
'\nทิ้งไว้เพียงอดีต ที่ไม่เคยหวนมา'
'\nซ่อนเธอไว้ในใจ (ซ่อนเธอไว้ในใจ)'
'\n'
'\nคงไว้ได้แค่กลิ่น ที่ไม่เคยเลือนลา'
'\nยังหอมดังวันเก่า ยามเมื่อลมโชยมา'
'\nทิ้งไว้เพียงอดีต ที่ไม่เคยหวนมา'
'\nซ่อนเธอไว้ในใจ'
'\n'
'\nเคยแอบแนบเคียงกาย'
'\nซ่อนเธอไว้ในใจ (ซ่อนเธอไว้ในใจ)'
'\n'
'\nทิ้งไว้เพียงอดีตที่ไม่เคยหวนมา'
'\nซ่อนเธอไว้ในใจ'),
        ),
      ),
    );
  }
}

class TangBadVoice extends StatelessWidget {
  const TangBadVoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชม'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text("ฮึกๆๆ"
"\nอ้าวเป็นไรอะ "
"\nก็มันไม่มีใครชมผมเลยอะพี่"
"\nยังไงนะ "
"\nมันไม่เคยมีใครชมผมเลย "
"\nไม่มีเลยเหรอ"
"\nผมทำอะไรดีขนาดไหน ผมทุ่มเทขนาดไหน มันไม่มีใครชมเลย"
"\nไม่มีเลยเหรอ"
"\n"
"\nมา"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\nฮ่า"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\nฮ่า"
"\n"
"\nไม่ต้องจำเป็นต้องคิด"
"\nถ้าเรื่องที่คิด มันไม่เป็นมิตร "
"\nมันจะเป็นพิษ มาทีละนิด "
"\nไม่ดีชีวิต นํ้าตาเป็นลิตร "
"\n"
"\nปัง "
"\nร้อยคะแนน "
"\nพันคะแนน "
"\nกูไม่ได้แกง "
"\nจะมีแต่แรง "
"\nสุดอะแพง"
"\nเพราะมึงอะอิน เตอร์เนชั่นแนล (High End) "
"\n"
"\nไม่มี can't "
"\nไม่มี can't "
"\nมีแต่ can "
"\nWonderland "
"\nนี่มันเพรชที่ทองผสม พี่แอน " 
"\n"
"\nไม่มีหรอกอะไรที่จะมาหยุด "
"\nเพราะมึงอะสุด มึงโคตรจะแกรนด์"
"\nและเดี๋ยวมึงจะมีแฟน"
"\n"
"\nเชดเข้ "
"\n"
"\nนํ้าหยดลงหิน "
"\nหินบอกว่าเอ้ยนํ้ามึงเท่หว่ะโอเค "
"\nนํ้าหยดลงหิน "
"\nหินบอกว่า นํ้า มีสเน่ห์ อยากให้มาหยดทุกวัน"
"\nI can do this all day "
"\n"
"\nเฮ้ย ดูโหงวเฮ้งนี่ก็ รู้เลยว่ารวย ถ้าไม่รวยเดี๋ยวก็รวย ใครมาบอกมึงจะไม่รวย มึงก็สวนเลย เฮงซวย"
"\nไม่ได้อวย ธุรกิจนี่พุ่งทะยานเดี๋ยวเทอก็รับเงินรัว "
"\nโอโห "
"\n"
"\nขนาดนี้เลยเหรอพี่ "
"\nเบอร์นี้แหละ "
"\nงั้นเอาอีก มา "
"\n"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\nฮ่า"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\n"
"\nสมปราถนา "
"\nนิสัยเทอดีขนาดนี้ โอบอ้อมมากและอารี ทุกทุกคนเลยเข้าหา น่าอิจฉา "
"\n"
"\nซ้ายและทางขวา เพราะเธอฉลาดในทุกเรื่อง "
"\nมันแลยไม่มีปัญหา การศึกษา"
"\nเพราะว่ามึงอะเรียนเก่ง ท่องเล็กน้อยแต่สอบใหญ่มันเลยไม่ใช่ปัญหา "
"\n"
"\nเอ้ยแปปดิ เอ้ย "
"\nดีเทออะดี "
"\nใครมาบอกว่าเทอไม่ดีเดี๋ยวโดนตี "
"\nเชี่ย "
"\nเอาซะดูดี เธอควรอยู่บนเวที"
"\nไปเลยเฮ้ย "
"\nสิ่งที่มึงคิดมันไม่เกินแฟนตาซี "
"\nหรอกอีสาว "
"\nเว้ย เชี่ย "
"\nสิ่งที่มึงคิดมันไม่เกินแฟนตาซี "
"\n"
"\nให้ได้งี้ดิ "
"\nเปิดมาไอจี มีแต่คนดีเอ็ม "
"\nมาแต่ละที "
"\nนี่มึงก็ฮ็อทเกินไป"
"\nให้ได้อย่างงี้ดิ "
"\n"
"\nดูมีบารมี "
"\nดวงแข็งมะฮอกกะนี "
"\nประมาณกับชายชาตรี "
"\nไม่ชายแท้"
"\nให้ได้อย่างงี้ดิ "
"\n"
"\nทำไปทุกวิธี ไม่กี่ปี "
"\nกูจะรอยินดี ทำพิธีเฉลิมฉลอง ให้ได้งี้ดิ "
"\n"
"\nให้มันได้อย่างงี้ดิ "
"\nมึงอะเก่งมาก ดีมาก เยี่ยมมาก มันต้องได้อย่างงี้ดิ "
"\n"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\nฮ่า"
"\nไม่มีใครชม เดี๋ยวกูชมเอง "
"\nเดี๋ยวกูจับพรมด้วยนํ้ามนต์เอง "
"\nไม่มีใครชมเดี๋ยวกูชมเอง "
"\nบรรเลง ด้วยพลังบวก หนึ่งบทเพลง "
"\n"
"\nมึงเอาอีกป่ะ "
"\nไม่เป็นไรพี่ รู้สึกดีขึ้นละ "
"\n"
"\nกูจะชม "
"\nทุกอุปสรรค์มันจะพังลงถ้ามึงชน "
"\nเขาถามมึงดีตรงไหน กูเลยตอบว่าทุกตรง "
"\n"
"\nทุกสิ่งนี้มันจะดี นะมันจะดี ไม่มี ลง"
"\nว้าว"
"\nมึงจะอีโว "
"\nมึงจะอีโวเพราะกูชม ใครไม่ชม แต่กูชม "),
        ),
      ),
    );
  }
}

class YOASOBI extends StatelessWidget {
  const YOASOBI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sangenshoku'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 2000,
          child: const Text('[Chorus]'
'\nDokoka de togireta monogatari'
'\nBokura mou ichido sono saki e'
'\nTatoe nando hanarete shimattemo'
'\nHora tsunagatte iru'
'\n'
'\n[Verse 1]'
'\nSore ja mata ne kawashita kotoba'
'\nAre kara ikutsu asahi wo mitanda'
'\nSorezore no kurashi no saki de'
'\nAno hi no tsudzuki saikai no hi'
'\n'
'\n[Pre-Chorus]'
'\nMachiawase made no jikan ga tada'
'\nSugite yuku tabi ni mune ga takanaru'
'\nAmeagari no sora mi agereba'
'\nAno hi to onaji you ni kakaru nanairo no hashi'
'\n'
'\n[Chorus]'
'\nKoko de mou ichido deaetanda yo'
'\nBokura tsunagatte itai nda zutto'
'\nHanashitai koto tsutaetai koto tte'
'\nAfurete tomaranai kara'
'\nHora, hodokete iyashinai yo kitto'
'\nMeguru kisetsu ni sekasarete'
'\nTsudzuku michi no sono saki mata'
'\nHanaretatte sa nando datte sa'
'\nTsuyoku musubi naoshitanara'
'\nMata aeru'
'\n'
'\n[Verse 2]'
'\nAh nan dakke?'
'\nOmoide banashi wa tomannai ne'
'\nTadotta kioku to kaisou'
'\nNazotte waratte wa aita jikan wo mitasu'
'\nKotoba to kotoba de kizukeba shootokatto'
'\nAshita no koto wa ki ni sezu douzo'
'\nMarude mukashi ni modotta you na'
'\n'
'\n[Verse 3]'
'\nSoredemo kawatte shimatta koto datte'
'\nHontou wa kitto ikutsumo aru'
'\nDakedo (Woah-oh) kyou datte (Woah-oh)'
'\nAkkenai hodo'
'\nAno koro no mama de, hm'
'\nBa-la-ba-la-ba-bi-la, ba'
'\n'
'\n[Bridge]'
'\nKizukeba sora wa shirami hajime'
'\nTsukare hateta bokura no katahoo ni'
'\nFureru honoka na atatakasa'
'\nAno hi to onaji you ni'
'\nSorezore no hibi ni kaeru'
'\nNe, koko made aruite kita'
'\nMichi wa sorezore chigau keredo'
'\nOnaji asahi ni ima terasareteru'
'\nMata kasanari aeta nda'
'\n'
'\n[Chorus]'
'\nDokoka de togireta monogatari'
'\nBokura mou ichido sono saki e'
'\nHanashitai koto tsutaetai koto tte'
'\nPeeji wo umete yuku you ni'
'\nHora kakitasou yo nando demo'
'\nItsuka miageta akai yuuhi mo'
'\nTomo ni sugoshita aoi hibi mo'
'\nWasurenai kara kie ya shinai kara'
'\nMidori ga mebuku you ni mata aeru kara'
'\nMonogatari wa shiroi asahi kara hajimaru'
'\n"Mata ashita"'
'\n'
'\n[Outro]'
'\nWoah oh, oh-oh-oh, woah oh, oh-oh-oh'
'\nWoah oh, oh-oh-oh, woah oh, oh-oh-oh'
'\nWoah oh, oh-oh-oh, woah oh, oh-oh-oh'
'\nWoah oh, oh-oh-oh'),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Downloader'),
        ),
        body: Column(
          children: [
            Text(email),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Logging in success, you can go back."),
              ),
            ),
          ],
        ));
  }
}