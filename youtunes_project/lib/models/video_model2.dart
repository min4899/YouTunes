
// Sort video variables into classes from video.list query from YouTube API
class Video2 {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video2({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  // pass in the individual results from searchresult['items']
  factory Video2.fromMap(Map<String, dynamic> item) {
    //print("ID: " + item['id']);
    //print("Title: " + item['snippet']['title']);
    return Video2(
      id: item['id'],
      title: item['snippet']['title'],
      thumbnailUrl: item['snippet']['thumbnails']['medium']['url'],
      channelTitle: item['snippet']['channelTitle'],
    );
  }
}