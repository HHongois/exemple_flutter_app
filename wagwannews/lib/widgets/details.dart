import 'package:flutter/material.dart';
import 'package:wagwannews/models/date_convertisseur.dart';
import 'package:wagwannews/widgets/texte_gwan.dart';
import 'package:webfeed/webfeed.dart';

class Details extends StatelessWidget{

  RssItem item;

  Details(RssItem item){
    this.item = item;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:  new Text('Détails de l\'article'),
      ),
      body:  new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new TexteGwan(item.title,fontSize: 25.0,),
            padding(),
            new Card(
              elevation: 7.5,
              child: new Container(
                width: MediaQuery.of(context).size.width /1.5,
                child: new Image.network(item.enclosure.url, fit: BoxFit.fill),
              ),
            ),
            padding(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new TexteGwan((item.author != null) ? item.author :'Auteur inconnu'),
                new TexteGwan(DateConvertisseur().convertirDate(item.pubDate),color: Colors.redAccent,)
              ],
            ),
            padding(),
            new TexteGwan(item.description),
            padding()
          ],
        ),
      ),

    );
  }
  Padding padding(){
    return new Padding(padding: EdgeInsets.only(top:20.0));
  }

}