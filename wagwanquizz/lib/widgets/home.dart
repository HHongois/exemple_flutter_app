import 'package:flutter/material.dart';
import 'package:wagwanquizz/widgets/custom_text.dart';
import 'page_quizz.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Card(
              elevation: 10.0,
              child: new Container(
                height: MediaQuery.of(context).size.width*0.8,
                width:MediaQuery.of(context).size.width*0.8,
                child: new Image.asset("quizz assets/cover.jpg",
                fit: BoxFit.cover),
              ),
            ),
            new RaisedButton(
              color: Colors.blue,
              onPressed: (){
                Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext  context){
                    return new PageQuizz();
                }));
              },
              child: new CustomText("Commencer le quizz",factor: 1.5),
            )
          ],
        ),
      ),
    );
  }
}