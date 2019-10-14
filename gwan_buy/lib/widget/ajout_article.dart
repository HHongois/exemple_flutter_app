import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gwan_buy/model/DatabaseClient.dart';
import 'package:gwan_buy/model/article.dart';
import 'package:image_picker/image_picker.dart';

class Ajout extends StatefulWidget {
  int id;
  Ajout(int id) {
    this.id = id;
  }

  _AjoutState createState() => new _AjoutState();
}

class _AjoutState extends State<Ajout> {
  String image;
  String nom;
  String magasin;
  String prix;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ajouter'),
        actions: <Widget>[
          new FlatButton(
            onPressed: ajouter,
            child: new Text(
              'Valider',
              style: new TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text(
              'Article à ajouter',
              textScaleFactor: 1.4,
              style:
                  new TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            new Card(
              elevation: 10.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == null)
                      ? new Image.asset('images/no_image.jpg')
                      : new Image.file(new File(image)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(Icons.camera_enhance),
                        onPressed: (()=> getImage(ImageSource.camera)),
                      ),
                      new IconButton(
                          icon: new Icon(Icons.photo_library),
                          onPressed: (()=> getImage(ImageSource.gallery)))
                    ],
                  ),
                  textfield(TypeTextField.nom, 'Nom de l\'article'),
                  textfield(TypeTextField.prix, 'Prix'),
                  textfield(TypeTextField.magasin, 'Magasin')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textfield(TypeTextField type, String label) {
    return new TextField(
      decoration: new InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }

  void ajouter(){
    print('PATH DE L\'IMAGE $image : ici le nom : $nom');

    if(nom != null) {
      Map<String,dynamic> map = {'nom': nom, 'item':widget.id};
      if(magasin != null){
        map['magasin'] = magasin;
      }
      if(prix != null){
        map['prix'] = prix;
      }
      if(image != null){
        map['image'] = image;
        print('path image ne base de données $image');

      }
      Article article = new Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value){
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        Navigator.pop(context);

      });
    }
  }
  Future getImage(ImageSource source)async{
    print('Un message ici la');
    var nouvelleImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = nouvelleImage.path;
    });
      print('PATH DE L\'IMAGE $image');

  }
}

enum TypeTextField { nom, prix, magasin }
