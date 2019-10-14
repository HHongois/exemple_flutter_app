import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wagwan/musique.dart';
import 'package:audioplayer/audioplayer.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Wagwan Music',
      theme: new ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: new Home(),
    );
  }
}

class Home extends StatefulWidget {
  final String title = 'Wagwan Music';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Home();
  }
}

class _Home extends State<Home> {

List<Musique> listMusic = [
  new Musique('Theme Swift', 'Popcaan', 'images/iceland.jpg', 'https://www.cjoint.com/doc/19_09/IIwspu1kbnH_dababy-intro-official-music-video.mp3'),
  new Musique('Theme 2', 'Rapper', 'images/bee.jpg', 'https://www.cjoint.com/doc/19_09/IIwspu1kbnH_dababy-intro-official-music-video.mp3'),
];

Musique myMusic;
AudioPlayer audioPlayer;
Duration position = new Duration(seconds: 0);
Duration duree = new Duration(seconds: 10);

StreamSubscription positionSub;
StreamSubscription stateSub;

PlayerState statut = PlayerState.stopped;

int index = 0;
@override
void initState(){
  super.initState();
  myMusic = listMusic[index];
  configAudioPlayer();
}
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
         centerTitle:true,
         backgroundColor: Colors.grey[900],
        ),
        backgroundColor: Colors.grey[700],
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Card(
                elevation: 9.0,
                child: new Container(
                  width: MediaQuery.of(context).size.height /2.5,
                  child: new Image.asset(myMusic.imagePath)
                  )
              ),
              textWidthStyle(myMusic.titre, 1.5),
              textWidthStyle(myMusic.artiste, 1.0),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  bouton(Icons.fast_rewind,30.0,ActionMusic.rewind),
                  bouton((statut == PlayerState.playin) ?  Icons.pause: Icons.play_arrow,45.0,(statut == PlayerState.playin) ? ActionMusic.pause : ActionMusic.play),
                  bouton(Icons.fast_forward,30.0,ActionMusic.forward),

                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  textWidthStyle(fromDuration(position), 0.8),
                  textWidthStyle(fromDuration(duree), 0.8)
                ],
              ),
              new Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duree.inSeconds.toDouble(),
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d){
                  setState(() {
                    audioPlayer.seek(d);
                  });
                },
              )
            ],
          ),
        ),
      );
  }

IconButton bouton(IconData icone, double taille,ActionMusic action){
  return IconButton(
    icon: new Icon(icone),
    color:Colors.white,
    onPressed: (){
      switch (action){
        case ActionMusic.play:
        play();
        break;
        case ActionMusic.pause:
        pause();
        break;
        case ActionMusic.forward:
       forward();
        break;
        case ActionMusic.rewind:
        rewind();
        break;
      }
    }
  );
}
  Text textWidthStyle(String data,double scale){
    return new Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      )
    );
  }

  void configAudioPlayer(){
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen(
      (pos) => setState(()=> position = pos)
    );
    stateSub = audioPlayer.onPlayerStateChanged.listen((state){
      if(state == AudioPlayerState.PLAYING){
        setState(() {
          duree = audioPlayer.duration;
        });
      }else if(state == AudioPlayerState.STOPPED){
        setState(() {
          statut = PlayerState.stopped;
          duree = new Duration(seconds: 0);
          position = new Duration(seconds: 0);
        });
      }
    },
    onError: (message){
      print('Erreur:$message');
      setState(() {
        statut = PlayerState.stopped;
      });

    } );
  }
  Future play() async{
    await audioPlayer.play(myMusic.urlSong);
    setState(() {
      statut = PlayerState.playin;
    });
  }

   Future pause() async{
    await audioPlayer.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  void forward(){
    if(index== listMusic.length -1){
      index =0;
    }else{
      index++;
    }
    myMusic = listMusic[index];
    audioPlayer.stop();
    configAudioPlayer();
    play();
  }
  void rewind(){
    if(position > Duration(seconds:3)){
      audioPlayer.seek(0.0);
    }else{
      if(index == 0){
        index = listMusic.length -1;
      }else{
        index--;
      }
      myMusic = listMusic[index];
      audioPlayer.stop();
      configAudioPlayer();
      play();
    }
  }

  String fromDuration(Duration duree){
    print(duree);
    return duree.toString().split('.').first;
  }

}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}

enum PlayerState {
  playin,
  stopped,
  paused
}
