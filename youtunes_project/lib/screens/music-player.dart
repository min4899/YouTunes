import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/queue.dart';

class MusicPlayerPage extends StatefulWidget {
  //MusicPlayerPage({Key key, this.video}) : super(key: key);
  MusicPlayerPage({Key key, this.queue}) : super(key: key);

  //final Video video;

  Queue queue; // Test

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  YoutubePlayerController _controller;

  bool _playing = true;

  String _title = "";
  String _author = "";
  String _nextSong = "";

  @override
  void initState() {
    super.initState();
    Video video = widget.queue.getCurrentSong();
    _controller = YoutubePlayerController(
      //initialVideoId: widget.video.id,
      initialVideoId: video.id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
      ),
    );
    _controller.value = new YoutubePlayerValue(isPlaying: false, position: new Duration());
    //_setVideoInfo(widget.video.title, widget.video.channelTitle);
    _setVideoInfo(video.title, video.channelTitle);
    _setNextVideoInfo();
    //queue = new Queue();
    //_setQueue();
  }

  void _setVideoInfo(String title, String channelTitle) {
    setState(() {
      _title = title;
      _author = channelTitle;
    });
    //_setDuration();
  }

  void _switchPlayPauseButton()
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

  /*
  void _setQueue() {
    queue.videos.insert(0, widget.video);
    queue.currentIndex = 0;
    queue.printQueue();
  }
   */

  void _previousVideo() {
    if (widget.queue.currentIndex > 0) {
      widget.queue.currentIndex--; // previous index
      Video previous = widget.queue.videos[widget.queue.currentIndex];
      _controller.load(previous.id);
      _setVideoInfo(previous.title, previous.channelTitle);
      _setNextVideoInfo();
      _controller.play();
      _playing = true;
      print("PLAYING PREVIOUS SONG");
    } else
      print("Already at the start of queue!");
  }

  void _nextVideo() {
    if (widget.queue.currentIndex < widget.queue.videos.length - 1) {
      widget.queue.currentIndex++; // next index
      Video next = widget.queue.videos[widget.queue.currentIndex];
      _controller.load(next.id);
      _setVideoInfo(next.title, next.channelTitle);
      _setNextVideoInfo();
      _controller.play();
      _playing = true;
      print("PLAYING NEXT SONG");
    } else
      print("No more videos left in the queue!");
  }

  void _setNextVideoInfo() { // update info on the bottom bar
    if (widget.queue.currentIndex < widget.queue.videos.length - 1) { // if next video is available
      Video nextVideo = widget.queue.videos[widget.queue.currentIndex + 1];
      setState(() {
        _nextSong = "Next: Sample Video Name 2 by Sample Artist 2";
        _nextSong = "Next: " + nextVideo.title.toString() + " by " + nextVideo.channelTitle;
      });
    }
    else {
      _nextSong = "End of Queue";
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
              flex: 35,
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
              flex: 15,
              child: Row(
                children: <Widget>[
                  /*
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                   */
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _title,
                          maxLines: 2,
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
                  /*
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.playlist_add),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                  */
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
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 35,
                    onPressed: () {

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 40,
                    onPressed: () {
                      if (_controller.value.position.inSeconds >= 5.0) {
                        if(_controller.value.isPlaying)
                          _controller.seekTo(new Duration());
                        else {
                          _controller.seekTo(new Duration());
                          _controller.pause();
                          setState(() {
                            _playing = false;
                          });
                        }
                      } else {
                        _previousVideo();
                      }
                    },
                  ),
                  _playing ?
                  IconButton (
                    iconSize: 40,
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      _switchPlayPauseButton();
                    },
                  ) :
                  IconButton (
                    iconSize: 40,
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      _switchPlayPauseButton();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 40,
                    onPressed: () {
                      _nextVideo();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.playlist_add),
                    iconSize: 35,
                    onPressed: () {

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
                      print("Video is playing: " + _controller.value.isPlaying.toString());
                      widget.queue.printQueue();
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
                        margin: EdgeInsets.only(left: 10, right: 10),
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
                            _nextSong,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
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
