import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/keys.dart';

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
    print(uri);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first couple videos from query
      List<Video> videos = [];
      videosJson.forEach(
            (json) => videos.add(
          Video.fromMap(json),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

}