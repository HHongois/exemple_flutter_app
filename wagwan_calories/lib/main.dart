import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

int calorieBase;
int calorieAvecActivite;

  double poids ;
  bool genre = false;
  double age ;
  double taille = 170.0;
  int radioSelectionnee;
  Map mapActivite = {
    0:"Faible",
    1:"Modere",
    2:"Forte"
  };

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      print('Nous sommes sur iOS');
      
    }else{
      print('Nous ne somme pas sur iOS');
    }
    return new GestureDetector(
      onTap: (()=> FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: setColor(),
          title: Text(widget.title),
        ),
        body: new SingleChildScrollView(
          padding:EdgeInsets.all(15.0),
          child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            textAvecStyle('Remplissez tous les champs pour obtenir votre besoin journalier en calorie'),
            padding(),
            new Card(elevation: 10.0,
            child: new Column(
              
              children: <Widget>[
                padding(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    textAvecStyle("Femme", color: Colors.pink),
                    new Switch(
                      value: genre,
                      inactiveTrackColor: Colors.pink,
                      activeTrackColor: Colors.blue,
                      onChanged: (bool b){
                        setState(() {
                          genre =b;
                        });
                      },
                    ),
                    textAvecStyle("Homme",color: Colors.blue)
                  ],
                ),
                new RaisedButton(
                  child: textAvecStyle((age == null) ? "Appuyer pour entrer votre age ":"Votre age est de : ${age.toInt()}",
                  color: Colors.white),
                  color: setColor(),
                  onPressed: montrerPicker,
                ),
                padding(),
                textAvecStyle("Votre taille est de: ${taille.toInt()} cm.",color: setColor(),),
                padding(),
                new Slider(
                  value:taille,
                  onChanged: (double d){
                  setState(() {
                    taille = d;
                  });
                },
                min : 100.0,
                max: 215.0
                ),
                padding(),
                new TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String string){
                    setState(() {
                      poids = double.tryParse(string);
                    });
                  },
                  decoration: new InputDecoration(
                    labelText: "Entrez votre poids en kilo"
                  ),
                ),
                padding(),
                textAvecStyle("Quel ets votre activité sportive ?", color: setColor()
                ),padding(),
                rowRadio(),
                padding(),
                new RaisedButton(
                  color: setColor(),
                  child: textAvecStyle("Calculer",color: Colors.white),
                  onPressed: calculerNombreDeCalorie,
                )
              ],
            ))
          ],
        )))
    );
    
  }
  Padding padding(){
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }
  Color setColor(){
    return genre ? Colors.blue : Colors.pink;
  }

  Future  montrerPicker() async {
    DateTime choix = await showDatePicker(
      context:context,
      initialDate:   new DateTime.now(),
      firstDate:new DateTime(1900),
      lastDate:  new DateTime.now(),
      initialDatePickerMode: DatePickerMode.year);
    if( choix != null){
      var difference = new DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours /365);
      setState(() {
        age = ans;
      });

    }
  }

  Text textAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(data,
        style: new TextStyle(color: color, fontSize: fontSize));
  }

  Row rowRadio(){
    List<Widget> l = [];
    mapActivite.forEach((key,value){
      Column colonne = new Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            value: key,
            groupValue: radioSelectionnee,
            onChanged: (Object i){
              setState(() {
                radioSelectionnee = i;
              });
            }
          ),
          textAvecStyle(value,color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l
    );
  }

  void calculerNombreDeCalorie(){
    if (age != null && poids != null && radioSelectionnee != null) {
      //Calculer
      if (genre) {
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      } else {
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionnee) {
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }

      setState(() {
        dialogue();
      });

    } else {
      alerte();
    }
  }

  Future dialogue() async{
    return showDialog(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext buildContext){
        return SimpleDialog(
        title: textAvecStyle("Votre besoin en calories",color: setColor()),
        contentPadding:EdgeInsets.all(15.0),
        children: <Widget>[
          textAvecStyle("Votre besoin de base est de: $calorieBase"),
          padding(),
          textAvecStyle("Votre besoin avec activite sportive est de : $calorieAvecActivite"),
          new RaisedButton(
            onPressed: (){
              Navigator.pop(buildContext);
            },
            child: textAvecStyle("OK",color: Colors.white),
            color: setColor(),
          )
        ],
        );

      }
    );
  }

  Future alerte() async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext){
        return new AlertDialog(
          title: textAvecStyle("Erreur"),
          content: textAvecStyle("Tous les champs ne sont pas remplis"),
          actions: <Widget>[
            new FlatButton(
              onPressed: (){
                Navigator.pop(buildContext);
              },
              child: textAvecStyle("OK",color: Colors.red),
            )
          ],);
      }
    );
  }


}
