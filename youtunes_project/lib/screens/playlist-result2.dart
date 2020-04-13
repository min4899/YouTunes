import 'package:flutter/material.dart';
import 'file:///C:/Users/min48/AndroidStudioProjects/YouTunes/youtunes_project/lib/screens/music-player.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/playlist_model.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/models/queue.dart';

class PlaylistResultPage2 extends StatefulWidget {
  PlaylistResultPage2({Key key, this.playlist}) : super(key: key);

  Playlist playlist;

  @override
  _PlaylistResult2 createState() => _PlaylistResult2();
}

class _PlaylistResult2 extends State<PlaylistResultPage2> {
  List<Video> _videoItem;
  bool _isLoading = false;
  int _searchLimit = 40;

  bool _buttonFlag = false;

  @override
  void initState() {
    super.initState();
    _listPlaylistVideos(widget.playlist.id);
  }

  _listPlaylistVideos(String q) async {
    APIService.instance.nextPageToken = "";
    List<Video> temp = await APIService.instance.fetchPlaylistItem(playlist_id: widget.playlist.id);
    setState(() {
      _videoItem = temp;
      _buttonFlag = true;
    });
  }

  _buildVideo(Video video, int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Image.network(video.thumbnailUrl),
          title: Text(video.title),
          subtitle: Text(video.channelTitle != null ? video.channelTitle : ""),
          //trailing: Icon(Icons.more_vert),
          onTap: () {
            Queue queue = new Queue(index, _videoItem); // TEST
            Navigator.push(
              context,
              MaterialPageRoute(
                //builder: (context) => MusicPlayerPage(video: video)),
                  builder: (context) => MusicPlayerPage(queue: queue)), // TEST
            );
          },
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos =
    await APIService.instance.fetchPlaylistItem(playlist_id: widget.playlist.id);
    List<Video> allVideos = _videoItem..addAll(moreVideos);
    setState(() {
      _videoItem = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.network(widget.playlist.thumbnailUrl),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        widget.playlist.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
          _videoItem != null && _videoItem.length > 0
              ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
              if (!_isLoading &&
                  _videoItem.length != _searchLimit &&
                  scrollDetails.metrics.pixels ==
                      scrollDetails.metrics.maxScrollExtent) {
                _loadMoreVideos();
              }
              return false;
            },
            child: Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _videoItem.length,
                itemBuilder: (BuildContext context, int index) {
                  Video video = _videoItem[index];
                  return _buildVideo(video, index);
                },
              ),
            ),)
              : Expanded(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility( // play all the songs listed in the search, starting with the first video
        visible: _buttonFlag,
        child: FloatingActionButton (
          child: Icon(Icons.play_arrow),
          onPressed: () {
            Queue queue = new Queue(0, _videoItem);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MusicPlayerPage(queue: queue)),
            );
          },
        ),
      ),
    );
  }
}
