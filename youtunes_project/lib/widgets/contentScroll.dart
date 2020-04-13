import 'package:flutter/material.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/queue.dart';
import 'package:youtunes_project/screens/music-player.dart';
import 'package:youtunes_project/screens/trending-screen.dart';

// For Trending Videos
class ContentScroll extends StatelessWidget {
  final String title;
  final List<Video> videos;

  ContentScroll({
    this.title,
    this.videos,
  });

  _buildContentCard(context, int index) {
    return InkWell(
      onTap: () {
        Queue queue = new Queue(index, videos); // TEST
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MusicPlayerPage(queue: queue)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        width: 180.0,
        decoration: BoxDecoration(
          color: Colors.black38,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.black38,
                child: Image.network(videos[index].thumbnailUrl)
            ),
            SizedBox(height: 8.0),
            Text(
              videos[index].title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.0),
            Text(
              videos[index].channelTitle,
              style: TextStyle(
                fontSize: 10.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FlatButton(
                  color: Colors.cyan,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrendingPage()
                      )
                    );
                  },
                  child: Text(
                    "More",
                  ),
                ),
              ],
            ),
          ),
          videos != null && videos.length > 0
              ? Container(
                  height: 190.0,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildContentCard(context, index);
                    },
                  ),
                )
              : SizedBox(
                height: 190,
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
    );
  }
}
