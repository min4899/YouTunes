import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/services/api_services.dart';

class Queue {
  int currentIndex = 0;
  List<Video> videos = [
    Video(id: "eaMpXK8cpVM", title: "Fairy Fountain", thumbnailUrl: "https://i.ytimg.com/vi/eaMpXK8cpVM/mqdefault.jpg", channelTitle: "GameChops - Topic"),
    Video(id: "xh5dV3un924", title: "Song of Storms", thumbnailUrl: "https://i.ytimg.com/vi/xh5dV3un924/mqdefault.jpg", channelTitle: "GameChops - Topic"),
    Video(id: "dCUFw2Hfs7Q", title: "Ecruteak City", thumbnailUrl: "https://i.ytimg.com/vi/dCUFw2Hfs7Q/mqdefault.jpg", channelTitle: "GameChops - Topic"),
    Video(id: "xQZbODfDiag", title: "Pokémon League", thumbnailUrl: "https://i.ytimg.com/vi/xQZbODfDiag/mqdefault.jpg", channelTitle: "GameChops - Topic"),
    Video(id: "GRU15XVAXAg", title: "Zelda ▸ Lost Woods ~ Chuck None Remix", thumbnailUrl: "https://i.ytimg.com/vi/GRU15XVAXAg/mqdefault.jpg", channelTitle: "GameChops")
  ];

  Queue(int currentIndex, List<Video> videos)
  {
    this.currentIndex = currentIndex;
    this.videos = videos;
  }

  // Return the video object at the current index
  Video getCurrentSong() {
    return videos[currentIndex];
  }

  void printQueue() {
    print("Currently playing : " + currentIndex.toString() + ". " + videos[currentIndex].title);
    print("Queue:");
    for(int i = 0; i < videos.length; i++) {
      print(i.toString() + ". " + videos[i].title + " by " + videos[i].channelTitle);
    }
  }
}