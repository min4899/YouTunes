import 'package:flutter/material.dart';
import 'file:///C:/Users/min48/AndroidStudioProjects/YouTunes/youtunes_project/lib/screens/music-player.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/widgets/contentScroll.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<Video> _trendingVideos;
  List<String> _charts = [
    "Top Songs Global",
    "Top Songs United States",
    "Top Songs South Korea"
  ];

  @override
  void initState() {
    super.initState();
    //_listTrendingVideos();
    setState(() {
      _charts = [
        "Top Songs Global",
        "Top Songs United States",
        "Top Songs South Korea"
      ];
    });
  }

  _listTrendingVideos() async {
    List<Video> temp = await APIService.instance.fetchTrending();
    setState(() {
      _trendingVideos = temp;
    });
  }

  _buildChartCard(int index) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: 220.0,
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
      child: Center(
        child: Text(
          _charts[index],
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 3,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 220.0,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: _charts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildChartCard(index);
              },
            ),
          ),
          /*
          ContentScroll(
            title: "Trending",
            videos: _trendingVideos,
          ),
          */
        ],
      ),
    );
  }
}
