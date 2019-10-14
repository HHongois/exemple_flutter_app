import 'package:flutter/material.dart';
import 'package:wagwannews/models/date_convertisseur.dart';
import 'package:wagwannews/models/parser.dart';
import 'package:wagwannews/widgets/details.dart';
import 'package:wagwannews/widgets/texte_gwan.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class Liste extends StatefulWidget {
  RssFeed feed;
  Liste(RssFeed feed) {
    this.feed = feed;
  }

  @override
  _ListeState createState() => new _ListeState();
}

class _ListeState extends State<Liste> {
  @override
  Widget build(BuildContext context) {
    final taille = MediaQuery.of(context).size.width / 2.5;
    return new ListView.builder(
      itemCount: widget.feed.items.length,
      itemBuilder: (context, i) {
        RssItem item = widget.feed.items[i];
        return new Container(
            child: new InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
              return new Details(item);
            }));
          },
          child: new Card(
            elevation: 10.0,
            child: new Column(
              children: <Widget>[
                padding(),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new TexteGwan((item.author != null) ? item.author :'Auteur inconnu'),
                    new TexteGwan(
                        new DateConvertisseur().convertirDate(item.pubDate),
                        color: Colors.red)
                  ],
                ),
                padding(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Card(
                      elevation: 7.5,
                      child: new Container(
                        width: taille,
                        child: new Image.network(
                          item.enclosure.url,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    new Container(
                      width: taille,
                      child: new TexteGwan(item.title),
                    )
                  ],
                ),
                padding()
              ],
            ),
          ),
        ), 
        padding: EdgeInsets.only(right: 10.0,left: 7.5),
        );
      },
    );
  }

  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 10.0));
  }
}
