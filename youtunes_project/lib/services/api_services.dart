import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/models/video_model2.dart';
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
        (json) => videos.add(
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
      'maxResults': '5',
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
            (json) => videos.add(
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
      'maxResults': '6',
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

  Future<Duration> fetchDuration(String videoId) async {
    Map<String, String> parameters = {
      'part': 'contentDetails',
      'id': videoId,
      'key': apikey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
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

      String iso = data["items"][0]["contentDetails"]["duration"];

      int secondsFromIso = _convertYoutubeDurationToSeconds(iso);

      Duration duration = new Duration(seconds: secondsFromIso);
      return duration;
    }
    else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  int _convertYoutubeDurationToSeconds(String duration){
    int returnSeconds = 0;

    var dayTime = duration.split('T');
    String time = dayTime[1];

    int index = 0;
    String digitString = "";
    while(index < time.length)
    {
      if(_isDigit(time, index)) // digit, add to digit string
          {
        digitString += time[index];
      }
      else // a letter, convert digit string, check letter, apply time
          {
        int digits = int.parse(digitString);
        if(time[index] == 'H')
        {
          returnSeconds += digits * 60 * 60;
        }
        else if(time[index] == 'M')
        {
          returnSeconds += digits * 60;
        }
        else if(time[index] == 'S')
        {
          returnSeconds += digits;
        }
        digitString = "";
      }
      index++;
    }
    return returnSeconds;
  }

  bool _isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
}
