import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gwan_buy/model/DatabaseClient.dart';
import 'package:gwan_buy/model/article.dart';
import 'package:gwan_buy/model/item.dart';
import 'package:gwan_buy/widget/ajout_article.dart';
import 'package:gwan_buy/widget/donnees_vides.dart';

class ItemDetail extends StatefulWidget {
  Item item;
  ItemDetail(Item item) {
    this.item = item;
  }

  _ItemDetailState createState() => new _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles;
  void initState() {
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState(() {
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.item.nom),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new Ajout(widget.item.id);
              })).then((value) {
                print('On est la !');
                DatabaseClient().allArticles(widget.item.id).then((liste) {
                  setState(() {
                    articles = liste;
                  });
                });
              });
            },
            child: new Text(
              'ajouter',
              style: new TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: (articles == null || articles.length == 0)
          ? new DonneesVides()
          : new GridView.builder(
              itemCount: articles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemBuilder: (context,i) {
                Article article = articles[i];
                return new Card(
                  child: new Column(
                    children: <Widget>[new Text(article.nom,textScaleFactor: 1.4,),
                    new Container(
                      height: MediaQuery.of(context).size.height /2.5,
                      child:(article.image == null)?
                    new Image.asset('images/no_image.jpg'):
                    new Image.file(new File(article.image)),

                    ),
                    
                    new Text((article.prix == null)? 'Aucun prix renseigné': "Prix : ${article.prix}"),
                    new Text((article.magasin == null)? 'Aucun magasin renseigné': "magasin: ${article.magasin}"),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
