import 'package:flutter/material.dart';
import 'package:wagwannews/models/parser.dart';
import 'package:wagwannews/widgets/chargement.dart';
import 'package:wagwannews/widgets/grille.dart';
import 'package:wagwannews/widgets/liste.dart';
import 'package:webfeed/webfeed.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  RssFeed feed;
  @override
  void initState() {
    super.initState();
    parse();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
       centerTitle: true,
        title: Text("Wagwan News boooomboclat !!!"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                feed = null;
                parse();
              });
            },
          )
        ],
      ),
      body: choixDuBody()
    
    );
  }

  Widget choixDuBody(){
    if(feed == null){
      return new Chargement();
    }else{
      Orientation orientation = MediaQuery.of(context).orientation;
      if(orientation == Orientation.portrait){
        return new  Liste(feed);
      }else{
        return new Grille(feed);
      }
    }
  }

  Future parse() async {
    RssFeed recu = await Parser().chargerRss();
    if(recu != null){
      setState(() {
        feed = recu;
        var i = 0;
        feed.items.forEach((f){
          i += 1; 
          print(i);
          RssItem item = f;
          print(item.author);
         

        });
        print("Taille du feed:${feed.items.length}");
      });
    }
  }
}