import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key key, this.videoId}) : super(key: key);

  final String videoId;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      )
    );
  }

  double _time = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded( // for top bar
              flex: 10,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down, size: 40.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                      child: Row()
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.more_vert,
                      size: 40.0,
                    ),
                  ),
                ],
              )
          ),
          Expanded( // video
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*
                  Image(
                      image: AssetImage("assets/sampleimage.jpg")
                  ),
                   */
                  YoutubePlayer (
                    controller: _controller,
                    showVideoProgressIndicator: false,
                    onReady: () {
                      print("Video " + widget.videoId + " is playing");
                    },
                  ),
                ],
              )
          ),
          Expanded( // video info, artist, like button, add button
              flex: 10,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.favorite_border,
                      size: 40.0,
                    ),
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
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.playlist_add,
                      size: 40.0,
                    ),
                  ),
                ],
              )
          ),
          Expanded( // video timestamp
              flex: 10,
              child: Column(
                children: <Widget>[
                  Slider( // timestamp slider
                    value: _time,
                    onChanged: (newTime) {
                      setState(() => _time = newTime);
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
                      print(widget.videoId);
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
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.queue_music,
                          size: 40.0,
                        ),
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
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 40.0,
                        ),
                      ),
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }
}
