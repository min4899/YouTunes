
// Sort video variables into classes from search.list query from YouTube API
class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  // pass in the individual results from searchresult['items']
  factory Video.fromMap(Map<String, dynamic> item) {
    return Video(
      id: item['id']['videoId'],
      title: item['snippet']['title'],
      //thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
      thumbnailUrl: item['snippet']['thumbnails']['medium']['url'],
      channelTitle: item['snippet']['channelTitle'],
    );
  }
}