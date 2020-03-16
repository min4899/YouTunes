import 'package:flutter/material.dart';

class OldSearchPage extends StatefulWidget {
  OldSearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OldSearchState createState() => _OldSearchState();
}

class _OldSearchState extends State<OldSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Search"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  // hard coded autofill
  final autofillSample = [
    "pop",
    "hiphop",
    "rock",
    "classical",
    "jazz",
    "folk",
    "heavy metal",
    "blues",
    "country",
    "punk rock",
    "popular",
  ];

  // hard coded autofill
  final recent = [
    "pokemon",
    "animal crossing",
    "insaneintherain",
    "gamechops mikel",
  ];

  // actions for app bar
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
    throw UnimplementedError();
  }

  // leading icon on the left of the app bar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    throw UnimplementedError();
  }

  // show some result based on selection
  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext content, int index){
          return Container(
            height: 100.0,
            child: Card(
              child: ListTile(
                onTap: () {
                  print("Clicked on " + query + " " + index.toString());
                },
                title: Center(
                  child: Text(
                    query,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        }
    );
    throw UnimplementedError();
  }

  // show when someone searches for something
  @override
  Widget buildSuggestions(BuildContext context) {
    // if field is empty, show recent searches, else autofill
    final suggestionList = query.isEmpty
        ? recent
        : autofillSample.where((p) => p.startsWith(query)).toList();

    // recommendations that show below search textfield
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          showResults(context);
        },
        leading: Icon(Icons.search),
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
    throw UnimplementedError();
  }
}
