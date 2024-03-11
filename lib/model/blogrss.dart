class BlogRss {
  final int index;
  final String title;
  final String synopsis;
  final String url;
  final String createAtTime;

  BlogRss(
      {required this.index,
      required this.title,
      required this.synopsis,
      required this.url,
      required this.createAtTime});

  factory BlogRss.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? BlogRss(
            index: json['idx'],
            title: json['title'],
            synopsis: json['synopsis'],
            url: json['url'],
            createAtTime: json['createAtTime'])
        : BlogRss(
            index: -1, title: '', synopsis: '', url: '', createAtTime: '');
  }
}
