import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtunes_project/keys.dart';
import 'package:youtunes_project/music-player.dart';

class OldSearch2Page extends StatefulWidget {
  @override
  _OldSearch2State createState() => _OldSearch2State();
}

class _OldSearch2State extends State<OldSearch2Page> {
    //with ListPopupTap<MyHomePage>, PortraitMode<MyHomePage> {
  TextEditingController textController;
  YoutubeAPI _youtubeAPI;
  List<YT_API> _ytResults;
  List<VideoItem> videoItem;
  String videoId;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _youtubeAPI = YoutubeAPI(apikey, type: "video", maxResults: 6);
    _ytResults = [];
    videoItem = [];

    callAPI("flutter");
  }

  Future<Null> callAPI(String query, {bool nextPage}) async {
    if (_ytResults.isNotEmpty) {
      videoItem.clear();
    }

    if (nextPage == null) {
      _ytResults = await _youtubeAPI.search(query);
      print(_ytResults);
    }
    if (nextPage == true)
      _ytResults = await _youtubeAPI.nextPage();
    else
      _ytResults = await _youtubeAPI.prevPage();

    for (YT_API result in _ytResults) {
      VideoItem item = VideoItem(
        api: result,
        //listPopupTap: this,
      );
      videoItem.add(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
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
                  controller: textController,
                  onFieldSubmitted: (String q) async {
                    await callAPI(q);

                    textController.clear();
                  },
                ),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: videoItem.length,
                    itemBuilder: (_, int index) => videoItem[index],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void onTap(YT_API apiItem, BuildContext context) {
    setState(() {
      videoId = apiItem.id;
    });

    /*
    Navigator.of(context).push(PopupVideoPlayerRoute(
      child: PopupVideoPlayer(
        videoId: videoId,
      ),
    ));
    */
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MusicPlayerPage(videoId: videoId)),
    );
  }
}

class VideoItem extends StatelessWidget {
  final YT_API api;
  //final ListPopupTap listPopupTap;

  //const VideoItem({Key key, this.api, this.listPopupTap}) : super(key: key);
  const VideoItem({Key key, this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Image.network(api.thumbnail["high"]["url"]),
          title: Text(api.title),
          subtitle: Text(api.channelTitle),
          onTap: () {
            //listPopupTap.onTap(api, context);

            //test
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicPlayerPage(videoId: api.id)),
            );
          },
        ),
      ),
    );
  }
}