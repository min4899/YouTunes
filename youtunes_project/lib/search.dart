import 'package:flutter/material.dart';
import 'package:youtunes_project/music-player.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/services/api_services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  TextEditingController _textController;
  String _videoId;
  List<Video> _videoItem;
  bool _isLoading = false;
  String _currentquery;
  int _searchLimit = 30;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    //_listVideos("gamechops");
  }

  _listVideos(String q) async {
    List<Video> temp = await APIService.instance.fetchVideos(query: q);
    setState(() {
      _videoItem = temp;
    });
  }

  _buildVideo(Video video) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Image.network(video.thumbnailUrl),
          title: Text(video.title),
          subtitle: Text(video.channelTitle != null ? video.channelTitle : ""),
          trailing: Icon(Icons.more_vert),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  //builder: (context) => MusicPlayerPage(videoId: video.id)),
                  builder: (context) => MusicPlayerPage(video: video)),
            );
          },
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos =
        await APIService.instance.fetchVideos(query: _currentquery);
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
        title: Text("Search"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Search music",
                  ),
                  controller: _textController,
                  onFieldSubmitted: (String q) {
                    if (q != "") {
                      _currentquery = q;
                      _listVideos(_currentquery);
                      //_textController.clear();
                    }
                  },
                ),
                _videoItem != null
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
                              return _buildVideo(video);
                            },
                          ),
                        )
                    )
                    : Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor, // Red
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
