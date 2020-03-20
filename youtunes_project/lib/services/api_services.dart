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
    print(uri);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Videos
    var response = await http.get(uri, headers: headers);

    //print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      String iso = data["items"][0]["contentDetails"]["duration"];

      int secondsFromIso = convertYoutubeDurationToSeconds(iso);

      Duration duration = new Duration(seconds: secondsFromIso);
      return duration;
    }
    else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  int convertYoutubeDurationToSeconds(String duration){
    int returnSeconds = 0;

    var dayTime = duration.split('T');
    String time = dayTime[1];

    int index = 0;
    String digitString = "";
    while(index < time.length)
    {
      if(isDigit(time, index)) // digit, add to digit string
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

  bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
}
