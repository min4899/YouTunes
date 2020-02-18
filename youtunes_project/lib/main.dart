import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTunes Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'YouTunes Music Player Demo Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded( // for top bar
            flex: 10,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 40.0,
                ),
              Expanded(
                child: Row()
              ),
                Icon(
                  Icons.more_vert,
                  size: 40.0,
                ),
              ],
            )
          ),
          Expanded( // video
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/sampleimage.jpg")
                  ),
                ],
              )
          ),
          Expanded( // video info, artist, like button, add button
              flex: 10,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite_border,
                    size: 40.0,
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Video name",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Artist name",
                          ),
                        ],
                      )
                  ),
                  Icon(
                    Icons.playlist_add,
                    size: 40.0,
                  ),
                ],
              )
          ),
          Expanded( // video timestamp
              flex: 10,
              child: Column(
                children: <Widget>[
                  Slider( // timestamp slider
                    value: 0,
                    onChanged: (newTime) {
                      setState(() {

                      });
                    },
                  ),
                  Expanded( // timestamp numbers
                      flex: 10,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Text(
                                "0:00",
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                              child: Row()
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Text(
                                "3:00",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              )
          ),
          Expanded( // back, play/pause, skip buttons
              flex: 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.skip_previous,
                      size: 50.0,
                    ),
                  ),
                  Expanded(
                      child: Icon(
                        Icons.play_arrow,
                        size: 50.0,
                      ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.skip_next,
                      size: 50.0,
                    ),
                  ),
                ],
              )
          ),
          Expanded( // sleep mode button
              flex: 10,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Sleep Mode",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                ],
              )
          ),
          Expanded( // queue bar
              flex: 10,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                child: Row (
                  children: <Widget>[
                    Icon(
                      Icons.queue_music,
                      size: 40.0,
                    ),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Next: Sample Video Name 2 by Sample Artist 2",
                            ),
                          ],
                        )
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 40.0,
                    ),
                  ],
                )
              )
          ),
          /*
          Expanded( // queue bar
              flex: 10,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.queue_music,
                    size: 40.0,
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Next: Sample Video Name 2 by Sample Artist 2",
                          ),
                        ],
                      )
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 40.0,
                  ),
                ],
              )
          ),
          */
        ],
      ),
    );
  }
}
