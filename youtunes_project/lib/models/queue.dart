import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/services/api_services.dart';

class Queue {
  Queue._instantiate();

  static Queue instance = Queue._instantiate();
  List<Video> videos;
  int currentIndex;

  void printQueue() {
    print("Currently playing : " + currentIndex.toString() + ". " + videos[currentIndex].title);
    print("Queue:");
    for(int i = 0; i < videos.length; i++) {
      print(i.toString() + ". " + videos[i].title + " by " + videos[i].channelTitle);
    }
  }
}