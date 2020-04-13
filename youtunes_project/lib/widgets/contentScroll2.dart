import 'package:flutter/material.dart';
import 'package:youtunes_project/models/playlist_model.dart';

// Display multiple video playlists recommended by YouTube
class ContentScroll2 extends StatelessWidget {

  final String title;
  final List<Playlist> playlists;

  ContentScroll2({
    this.title,
    this.playlists,
  });

  _buildContentCard(context, int index) {
    return InkWell(
      onTap: () {

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
        //child: Image.network(thumbnailURLs[index]),
        child: Image.network(playlists[index].thumbnailUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
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
              ],
            ),
          ),
          playlists != null && playlists.length > 0
          ? Container(
            height: 180.0,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.horizontal,
              //itemCount: playlist_ids.length,
              itemCount: playlists.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildContentCard(context, index);
              },
            ),
          )
          : SizedBox(
            height: 180,
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