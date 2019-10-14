import 'package:flutter/material.dart';
import 'package:wagwannews/widgets/texte_gwan.dart';

class Chargement extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new TexteGwan("Chargement en cours ...",fontStyle: FontStyle.italic,fontSize: 30.0,),
    );
  }

}