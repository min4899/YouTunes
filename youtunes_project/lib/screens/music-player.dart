import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/queue.dart';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({Key key, this.video}) : super(key: key);

  final Video video;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  YoutubePlayerController _controller;

  bool _playing = true;

  String _title;
  String _author;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
      ),
    );
    _controller.value = new YoutubePlayerValue(isPlaying: false, position: new Duration());
    _setVideoInfo(widget.video.title, widget.video.channelTitle);
    _setQueue();
  }

  void _setVideoInfo(String title, String channelTitle) {
    setState(() {
      _title = title;
      _author = channelTitle;
    });
    //_setDuration();
  }

  void _updatePlayPauseButton()
  {
    // was playing, pause video
    if(_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _playing = false;
      });
    }
    // was paused, play video
    else {
      _controller.play();
      setState(() {
        _playing = true;
      });
    }
  }

  void _setQueue() async {
    //Queue.instance.videos = await APIService.instance.fetchRelated(id: widget.video.id);
    Queue.instance.videos.insert(0, widget.video);
    Queue.instance.currentIndex = 0;
    Queue.instance.printQueue();
  }

  void _previousVideo() {
    if (Queue.instance.currentIndex > 0) {
      Queue.instance.currentIndex--;
      _controller.load(Queue.instance.videos[Queue.instance.currentIndex].id);
      setState(() {
        _title = Queue.instance.videos[Queue.instance.currentIndex].title;
        _author = Queue.instance.videos[Queue.instance.currentIndex].channelTitle;
      });
      _controller.play();
      _playing = true;
      print("PLAYING PREVIOUS SONG");
    } else
      print("Already at the start of queue!");
  }

  void _nextVideo() {
    if (Queue.instance.currentIndex < Queue.instance.videos.length - 1) {
      Queue.instance.currentIndex++;
      _controller.load(Queue.instance.videos[Queue.instance.currentIndex].id);
      setState(() {
        _title = Queue.instance.videos[Queue.instance.currentIndex].title;
        _author = Queue.instance.videos[Queue.instance.currentIndex].channelTitle;
      });
      _controller.play();
      _playing = true;
      print("PLAYING NEXT SONG");
    } else
      print("No more videos left!");
  }

  void playPause() {

  }

  /*
  void _setDuration() async {
    _duration = await APIService.instance.fetchDuration(widget.video.id);
    setState(() {
      _durationString = _durationToStringFormat(_duration.toString());
    });
  }

  String _durationToStringFormat(String inputDurationString) {
    inputDurationString = inputDurationString.replaceFirst("0:", "");
    inputDurationString = inputDurationString.replaceFirst("00:", "");
    if (inputDurationString[0] == '0')
      inputDurationString = inputDurationString.substring(1);
    int periodIndex = inputDurationString.indexOf(".");
    inputDurationString = inputDurationString.substring(0, periodIndex);
    return inputDurationString;
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              // for top bar
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 40,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(Icons.more_vert),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
          Expanded(
              // video
              flex: 38,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  YoutubePlayer(
                    controller: _controller,
                    onReady: () {
                      print("Video player loaded. Playing video.");
                      _controller.play();
                      _playing = true;
                    },
                    onEnded: (YoutubeMetaData) {
                      _nextVideo();
                    },
                  ),
                ],
              )),
          Expanded(
              // video info, artist, like button, add button
              flex: 12,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      iconSize: 40,
                      onPressed: () {},
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
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.playlist_add),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
          Expanded(
              // video timestamp
              flex: 6,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ProgressBar(
                      controller: _controller,
                    ),
                  ),
                  Expanded(
                      // timestamp numbers
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: CurrentPosition(
                          controller: _controller,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: RemainingDuration(
                          controller: _controller,
                        ),
                      ),
                    ],
                  )),
                ],
              )),
          Expanded(
              // back, play/pause, skip buttons
              flex: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 50,
                    onPressed: () {
                      if (_controller.value.position.inSeconds >= 5.0) {
                        _controller.seekTo(new Duration());
                        _updatePlayPauseButton();
                      } else {
                        _previousVideo();
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    //child: _playPauseButton = PlayPauseButton(controller: _controller),
                    child:
                    _playing ?
                    IconButton (
                      iconSize: 50,
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        _updatePlayPauseButton();
                      },
                    ) :
                    IconButton (
                      iconSize: 50,
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _updatePlayPauseButton();
                      },
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 50,
                    onPressed: () {
                      _nextVideo();
                    },
                  ),
                ],
              )),
          Expanded(
              // sleep mode button
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      print("video id: " + widget.video.id);
                      print("Video is playing: " +
                          _controller.value.isPlaying.toString());
                      Queue.instance.printQueue();
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
              flex: 8,
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
