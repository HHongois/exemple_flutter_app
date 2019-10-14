import 'package:flutter/material.dart';
import 'package:wagwannews/models/date_convertisseur.dart';
import 'package:wagwannews/widgets/texte_gwan.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

import 'details.dart';

class Grille extends StatefulWidget {
  RssFeed feed;

  Grille(RssFeed feed) {
    this.feed = feed;
  }
  @override
  _GrilleState createState() => new _GrilleState();
}

class _GrilleState extends State<Grille> {
  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      itemCount: widget.feed.items.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, i) {
        RssItem item = widget.feed.items[i];
        return new InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
              return new Details(item);
            }));
          },
          child: new Card(
            elevation: 10.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new TexteGwan((item.author != null) ? item.author :'Auteur inconnu'),
                    new TexteGwan(
                      DateConvertisseur().convertirDate(item.pubDate),
                      color: Colors.redAccent,
                    )
                  ],
                ),
                new TexteGwan(item.title),
                new Card(
                  elevation: 7.5,
                  child: new Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child:
                        new Image.network(item.enclosure.url, fit: BoxFit.fill),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
