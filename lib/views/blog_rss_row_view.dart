import 'package:flutter/material.dart';
import 'package:pain_record/commmon/commons.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/views/blog_detail_view.dart';

class BlogRssRowView extends StatelessWidget {
  final BlogRss item;

  const BlogRssRowView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Commons.logger.d('click is ${item.index}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlogDetailView(url: item.url, blogIndex: item.index),
            fullscreenDialog: false,
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 330, // dp 계산인 듯
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 2.0, 4.0, 1.0),
                  child: Text(
                    textAlign: TextAlign.justify,
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 2.0, 4.0, 1.0),
                  child: Text(
                    textAlign: TextAlign.end,
                    item.createAtTime,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Text(
            item.synopsis,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}
