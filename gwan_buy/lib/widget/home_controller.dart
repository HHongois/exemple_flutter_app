import 'package:flutter/material.dart';
import 'package:gwan_buy/model/DatabaseClient.dart';
import 'package:gwan_buy/model/item.dart';
import 'package:gwan_buy/widget/donnees_vides.dart';
import 'package:gwan_buy/widget/itemDetail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  String nouvelleListe;
  List<Item> items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new FlatButton(
            onPressed: (() =>ajouter(null)),
            child: new Text("Ajouter",
                style: new TextStyle(
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: (items == null || items.length == 0)
          ? new DonneesVides()
          : new ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                Item item = items[i];
                print(items[i]);
                return new ListTile(
                  title: new Text(item.nom),
                  trailing: new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () {
                      DatabaseClient().delete(item.id, 'item').then((int) {
                        print("L'int récupéré est :$int");
                        recuperer();
                      });
                    },
                  ),
                  leading: new IconButton(
                    icon: new Icon(Icons.edit),
                    onPressed: (() => ajouter(item)),
                  ),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
                      return new ItemDetail(item);
                    }));
                  },
                );
              }),
    );
  }

  Future ajouter(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: new Text("Ajouter une liste de souhaits"),
            content: new TextField(
              decoration: new InputDecoration(
                  labelText: "liste:",
                  hintText: (item == null)
                      ? "ex: mes prochains jeux videos"
                      : item.nom),
              onChanged: (String str) {
                nouvelleListe = str;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: (() => Navigator.pop(buildContext)),
                  child: new Text("Annuler")),
              new FlatButton(
                  onPressed: () {
                    if (nouvelleListe != null) {
                      if (item == null) {
                        item = new Item();
                        Map<String, dynamic> map = {'nom': nouvelleListe};
                        item.fromMap(map);
                      }else{
                        item.nom = nouvelleListe;
                      }
                      DatabaseClient().upsertItem(item).then((i) => recuperer());
                      nouvelleListe = null;
                    }

                    Navigator.pop(buildContext);
                  },
                  child: new Text(
                    "Valider",
                    style: new TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  void recuperer() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
