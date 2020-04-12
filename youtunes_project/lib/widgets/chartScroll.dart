import 'package:flutter/material.dart';
import 'package:youtunes_project/models/video_model.dart';
import 'package:youtunes_project/screens/playlist-result.dart';

class ChartScroll extends StatelessWidget {

  final List<String> _charts = [
    "Top Songs Global",
    "Top Songs United States",
    "Top Songs South Korea",
    "Top Songs Mexico",
    "Top Songs Brazil",
    "Top Songs France",
  ];

  final List<String> _chartUrl = [
    "PL4fGSI1pDJn6puJdseH2Rt9sMvt9E2M4i",
    "PL4fGSI1pDJn6O1LS0XSdF3RyO0Rq_LDeI",
    "PL4fGSI1pDJn6jXS_Tv_N9B8Z0HTRVJE0m",
    "PL4fGSI1pDJn6fko1AmNa_pdGPZr5ROFvd",
    "PL4fGSI1pDJn7BPgh08TpP9OLpFwhzTZr1",
  ];

  _buildChartCard(context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlaylistResultPage(
                  title: _charts[index],
                  playlist_id: _chartUrl[index])), // TEST
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        width: 190.0,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        scrollDirection: Axis.horizontal,
        itemCount: _charts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildChartCard(context, index);
        },
      ),
    );
  }
}
