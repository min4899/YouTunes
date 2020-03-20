import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'dart:async';

class MusicPlayerPage extends StatefulWidget {
  //MusicPlayerPage({Key key, this.videoId}) : super(key: key);
  MusicPlayerPage({Key key, this.video}) : super(key: key);

  //final String videoId;
  final Video video;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  YoutubePlayerController _controller;

  Timer _everySecond;
  double _time = 0.0;
  String _timeString = "0:00";
  bool _playing;

  String _title;
  String _author;
  Duration _duration;
  String _durationString = "";
  double _durationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      //initialVideoId: widget.videoId,
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
      ),
    );
    _controller.value =
        new YoutubePlayerValue(isPlaying: false, position: new Duration());
    _playing = _controller.value.isPlaying;
    _setVideoInfo();

    _everySecond = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      if(_playing) {
        setState(() {
          _time = _controller.value.position.inSeconds.toDouble();
          //_timeString =  _durationToStringFormat(_controller.value.position.toString());
        });
      }
    });
  }

  void _setVideoInfo() {
    setState(() {
      _title = widget.video.title;
      _author = widget.video.channelTitle;
    });
    _setDuration();
  }

  void _setDuration() async {
    _duration = await APIService.instance.fetchDuration(widget.video.id);
    setState(() {
      _durationString = _durationToStringFormat(_duration.toString());
    });

    _durationSeconds = _duration.inSeconds.toDouble();
  }

  String _durationToStringFormat(String inputDurationString) {
    inputDurationString = inputDurationString.replaceFirst("0:", "");
    inputDurationString = inputDurationString.replaceFirst("00:", "");
    if(inputDurationString[0] == '0')
      inputDurationString = inputDurationString.substring(1);
    int periodIndex = inputDurationString.indexOf(".");
    inputDurationString = inputDurationString.substring(0, periodIndex);
    return inputDurationString;
  }

  void _playpause() {
    if (_playing) {
      setState(() {
        _playing = false;
      });
      _controller.pause();
    } else {
      setState(() {
        _playing = true;
      });
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              // for top bar
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
                  Expanded(child: Row()),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.more_vert,
                      size: 40.0,
                    ),
                  ),
                ],
              )),
          Expanded(
              // video
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  YoutubePlayer(
                    controller: _controller,
                    onReady: () {
                      print("Video " + widget.video.id + " is playing");
                    },
                  ),
                ],
              )),
          Expanded(
              // video info, artist, like button, add button
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
                      child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          _author,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.playlist_add,
                      size: 40.0,
                    ),
                  ),
                ],
              )),
          Expanded(
              // video timestamp
              flex: 10,
              child: Column(
                children: <Widget>[
                  Slider(
                    // timestamp slider
                    value: _time,
                    min: 0,
                    max: _durationSeconds,
                    onChanged: (newTime) {
                      setState(() => _time = newTime);
                      print(_time);
                    },
                  ),
                  Expanded(
                      // timestamp numbers
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
                          Expanded(child: Row()),
                          Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Text(
                              _durationString,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      )),
                ],
              )),
          Expanded(
              // back, play/pause, skip buttons
              flex: 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.skip_previous,
                      size: 50.0,
                    ),
                  ),
                  _playing
                      ? Expanded(
                          child: IconButton(
                            icon: Icon(Icons.pause),
                            iconSize: 50.0,
                            onPressed: () {
                              _playpause();
                            },
                          ),
                        )
                      : Expanded(
                          child: IconButton(
                            icon: Icon(Icons.play_arrow),
                            iconSize: 50.0,
                            onPressed: () {
                              _playpause();
                            },
                          ),
                        ),
                  Expanded(
                    child: Icon(
                      Icons.skip_next,
                      size: 50.0,
                    ),
                  ),
                ],
              )),
          Expanded(
              // sleep mode button
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
                      print(widget.video.id);
                      print("Video is playing: " + _controller.value.isPlaying.toString());
                      print("Position: " + _controller.value.position.toString());
                      print("Position in Seconds: " + _time.toString());
                      print("Total Duration: " + _durationString);
                      print("Total Duration: " + _duration.toString());
                    },
                    child: Text(
                      "Sleep Mode",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                ],
              )),
          Expanded(
              // queue bar
              flex: 10,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Row(
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
                      )),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
