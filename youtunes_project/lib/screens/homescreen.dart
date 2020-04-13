import 'package:flutter/material.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/playlist_model.dart';
import 'package:youtunes_project/services/api_services.dart';
import 'package:youtunes_project/widgets/contentScroll.dart';
import 'package:youtunes_project/widgets/contentScroll2.dart';
import 'package:youtunes_project/widgets/chartScroll.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<Video> _trendingVideos;
  /*
  List<String> _charts = [
    "Top Songs Global",
    "Top Songs United States",
    "Top Songs South Korea",
    "Top Songs Mexico",
    "Top Songs Brazil",
    "Top Songs France",
  ];

  List<String> _chartUrl = [
    "PL4fGSI1pDJn6puJdseH2Rt9sMvt9E2M4i",
    "PL4fGSI1pDJn6O1LS0XSdF3RyO0Rq_LDeI",
    "PL4fGSI1pDJn6jXS_Tv_N9B8Z0HTRVJE0m",
    "PL4fGSI1pDJn6fko1AmNa_pdGPZr5ROFvd",
    "PL4fGSI1pDJn7BPgh08TpP9OLpFwhzTZr1",
  ];
  */

  // New and Trending Playlists
  List<Playlist> playlists_1;
  List<String> playlistIDs_1 = [
    "RDCLAK5uy_k7O9KByATGA1TqFYhyOkylpJ6fM1avtww", // Clout Rising
    "RDCLAK5uy_nGZRi-an-ruqiZlNJSGhCDHucdp2FBNfI", // R&B Wave
    "RDCLAK5uy_n0vqPVYwwLGVv8XMpjj7IovO50hqegreo", // Country's New Crop
  ];

  // Mood, Moment, Vibe
  List<Playlist> playlists_2;
  List<String> playlistIDs_2 = [
    "RDCLAK5uy_n9hGvSNdO2TpX8jJuiThvnfrfIi1qNRnY", // Classical Focus
    "RDCLAK5uy_nH_fdBVCcbNaVwi_tmZajZRq-ekddiuFY", // Pop Meets Country
    "RDCLAK5uy_n3VXlgOKj6OxuN3TpKEnVBX4qia-_2c1k", // Champagne Diet
    "RDCLAK5uy_nBE4bLuBHUXWZrF59ZrkPEToKt8M_I3Vc" // Coffee Shop Blend
  ];

  @override
  void initState() {
    super.initState();
    _listTrendingVideos();

    List<Playlist> temp = _getPlaylistInfos(playlistIDs_1);
    setState(() {
      playlists_1 = temp;
    });

    temp = _getPlaylistInfos(playlistIDs_2);
    setState(() {
      playlists_2 = temp;
    });
  }

  _listTrendingVideos() async {
    APIService.instance.nextPageToken = "";
    List<Video> temp = await APIService.instance.fetchTrending();
    setState(() {
      _trendingVideos = temp;
    });
  }

  List<Playlist> _getPlaylistInfos(List<String> playlistIDs) {
    APIService.instance.nextPageToken = "";
    List<Playlist> playlist_items = [];
    playlistIDs.forEach((id) async {
      Playlist temp =
          await APIService.instance.fetchPlaylistInfo(playlist_id: id);
      playlist_items.add(temp);
    });
    return playlist_items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: <Widget>[
          ChartScroll(),
          ContentScroll(
            title: "Popular Now",
            videos: _trendingVideos,
          ),
          ContentScroll2(title: "New & Trending", playlists: playlists_1,),
          ContentScroll2(title: "Mood, Moment, Vibe", playlists: playlists_2,),
        ],
      ),
    );
  }
}
