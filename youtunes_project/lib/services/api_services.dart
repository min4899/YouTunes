import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/playlist_model.dart';
import 'package:youtunes_project/keys.dart';

// QUOTA LIMIT OF 10,000 UNITS EACH DAY

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<List<Video>> fetchVideos({String query}) async {
    print("Searching videos with querry: " + query);

    Map<String, String> parameters = {
      'part': 'snippet',
      'q': query,
      'type': 'video',
      'maxResults': '6',
      'order': 'relevance',
      'videoCategoryId': '10',
      'pageToken': _nextPageToken,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    //print(uri);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    //print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first couple videos from query
      List<Video> videos = [];
      videosJson.forEach(
            (json) =>
            videos.add(
              Video.fromMap(json),
            ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchRelated({String id}) async {
    print("Searching related videos with video id: " + id);

    Map<String, String> parameters = {
      'part': 'snippet',
      'type': 'video',
      'maxResults': '6',
      'order': 'relevance',
      'videoCategoryId': '10',
      'relatedToVideoId': id,
      'pageToken': _nextPageToken,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first couple videos from query
      List<Video> videos = [];
      videosJson.forEach(
            (json) =>
            videos.add(
              Video.fromMap(json),
            ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchTrending() async {
    print("Searching trending videos");

    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '8',
      'chart': 'mostPopular',
      'videoCategoryId': '10',
      'pageToken': _nextPageToken,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first couple videos from query
      /*
      List<Video2> videos = [];
      videosJson.forEach(
            (json) => videos.add(
          Video2.fromMap(json),
        ),
      );
      */
      List<Video> videos = [];
      videosJson.forEach(
              (json) {
            videos.add(Video(
              id: json['id'],
              title: json['snippet']['title'],
              thumbnailUrl: json['snippet']['thumbnails']['medium']['url'],
              channelTitle: json['snippet']['channelTitle'],
            ));
          }
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchPlaylistItem({String playlist_id}) async {
    print("Retrieving videos from playlist: " + playlist_id);

    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'playlistId': playlist_id,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      List<Video> videos = [];
      videosJson.forEach(
              (json) {
            videos.add(Video(
              id: json['snippet']['resourceId']['videoId'],
              title: json['snippet']['title'],
              thumbnailUrl: json['snippet']['thumbnails']['medium']['url'],
              channelTitle: json['snippet']['channelTitle'],
            ));
          }
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<Playlist> fetchPlaylistInfo({String playlist_id}) async {
    print("Retrieving playlist data: " + playlist_id);

    Map<String, String> parameters = {
      'part': 'snippet',
      'pageToken': _nextPageToken,
      'id': playlist_id,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> playlistJson = data['items'];

      Playlist playlist = new Playlist(
          id: playlistJson[0]['id'],
          title: playlistJson[0]['snippet']['title'],
          description: playlistJson[0]['snippet']['description'],
          thumbnailUrl: playlistJson[0]['snippet']['thumbnails']['medium']['url'],
      );

      //print(playlist.title + ": " + playlist.thumbnailUrl);

      return playlist;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}