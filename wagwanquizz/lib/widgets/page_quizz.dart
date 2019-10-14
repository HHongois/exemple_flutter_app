import 'package:flutter/material.dart';
import 'custom_text.dart';
import 'package:wagwanquizz/models/question.dart';

class PageQuizz extends StatefulWidget {
  @override
 _PageQuizzState createState()=> new _PageQuizzState();

}

class _PageQuizzState extends State<PageQuizz> {

  Question question;

  List<Question> listeQuestions = [
    new Question('La devise de la Belgique est l\'union fait la force', true, '', 'belgique.JPG'),
    new Question('La lune va finir par tomber sur terre à cause de la gravité', false, 'Au contraire la lune s\'éloigne', 'lune.jpg'),
    new Question('La Russie est plus grande en superficie que Pluton', true, '', 'russie.jpg'),
    new Question('Nyctalope est une race naine d\'antilope', false, 'C’est une aptitude à voir dans le noir', 'nyctalope.jpg'),
    new Question('Le Commodore 64 est l\’oridnateur de bureau le plus vendu', true, '', 'commodore.jpg'),
    new Question('Le nom du drapeau des pirates es black skull', false, 'Il est appelé Jolly Roger', 'pirate.png'),
    new Question('Haddock est le nom du chien Tintin', false, 'C\'est Milou', 'tintin.jpg'),
    new Question('La barbe des pharaons était fausse', true, 'A l\'époque déjà ils utilisaient des postiches', 'pharaon.jpg'),
    new Question('Au Québec tire toi une bûche veut dire viens viens t\'asseoir', true, 'La bûche, fameuse chaise de bucheron', 'buche.jpg'),
    new Question('Le module lunaire Eagle de possédait de 4Ko de Ram', true, 'Dire que je me plains avec mes 8GO de ram sur mon mac', 'eagle.jpg'),
  ];

  int index = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    question = listeQuestions[index];
  }
  
  @override
  Widget build(BuildContext context) {
    double taille = MediaQuery.of(context).size.width * 0.75;
    return new Scaffold(
      appBar: new AppBar(
        title: new CustomText('Le Quizz'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new CustomText("Question numéro ${index + 1}", color: Colors.grey[900],),
            new CustomText("Score: $score / $index", color: Colors.grey[900],),
            new Card(
              elevation: 10.0,
              child: new Container(
                height: taille,
                width: taille,
                child: new Image.asset(
                    "quizz assets/${question.imagePath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new CustomText(question.question, color: Colors.grey[900], factor: 1.3,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                boutonBool(true),
                boutonBool(false)
              ],
            )
          ],
        ),

      ),
    );
  }
  
  RaisedButton boutonBool (bool b) {
    return new RaisedButton(
      elevation: 10.0,
      onPressed: (() => dialogue(b)),
      color: Colors.blue,
      child: new CustomText((b)? "Vrai": "Faux", factor: 1.25,),
    );
  }
  
  Future dialogue(bool b) async {
    bool bonneReponse = (b == question.response);
    String vrai = "quizz assets/vrai.jpg";
    String faux = "quizz assets/faux.jpg";
    if (bonneReponse) {
      score++;
    }

    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
          return new SimpleDialog(
            title: new CustomText((bonneReponse)? "C'est gagné!": "Oups! perdu...", factor: 1.4, color: (bonneReponse)? Colors.green: Colors.red,),
            contentPadding: EdgeInsets.all(20.0),
            children: <Widget>[
              new Image.asset((bonneReponse)? vrai: faux, fit: BoxFit.cover,),
              new Container(height: 25.0,),
              new CustomText(question.explication, factor: 1.25, color: Colors.grey[900],),
              new Container(height: 25.0,),
              new RaisedButton(onPressed: () {
                Navigator.pop(context);
                questionSuivante();
              },
              child: new CustomText("Au suivant", factor: 1.25,),
              color: Colors.blue,
                ),
            ],
          );
      }
    );
  }

  Future<Null> alerte() async {
    return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: new CustomText("C'est fini", color: Colors.blue, factor: 1.25,),
          contentPadding: EdgeInsets.all(10.0),
          content: new CustomText("Votre score: $score / $index", color: Colors.grey[900],),
          actions: <Widget>[
            new FlatButton(
                onPressed: (() {
                  Navigator.pop(buildContext);
                  Navigator.pop(context);
                }),
                child: new CustomText("OK", factor: 1.25, color: Colors.blue,))
          ],
        );
      }
    );
  }


  void questionSuivante() {
    if (index < listeQuestions.length - 1) {
      index++;
      setState(() {
        question = listeQuestions[index];
      });
    } else {
      alerte();
    }
  }
}