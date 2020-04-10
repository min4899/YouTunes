import 'package:flutter/material.dart';
import 'file:///C:/Users/min48/AndroidStudioProjects/YouTunes/youtunes_project/lib/screens/music-player.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/models/queue.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  TextEditingController _textController;
  String _videoId;
  List<Video> _videoItem;
  bool _isLoading = false;
  String _currentQuery;
  int _searchLimit = 30;

  bool _buttonFlag = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  _listVideos(String q) async {
    List<Video> temp = await APIService.instance.fetchVideos(query: q);
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
          trailing: Icon(Icons.more_vert),
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
        await APIService.instance.fetchVideos(query: _currentQuery);
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
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Search music",
              ),
              controller: _textController,
              onFieldSubmitted: (String q) {
                if (q != "") {
                  _currentQuery = q;
                  _listVideos(_currentQuery);
                  //_textController.clear();
                }
              },
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
