import 'package:flutter/material.dart';
import 'package:pain_record/model/blogrss.dart';
import 'package:pain_record/views/blog_detail_view.dart';

class BlogRssRowView extends StatelessWidget {
  final BlogRss item;

  const BlogRssRowView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 4.0, 1.0),
                child: Text(
                  textAlign: TextAlign.justify,
                  item.createAtTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 4.0, 1.0),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      '(${item.title})',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: double.infinity,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
            child: Text(
              item.synopsis,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
