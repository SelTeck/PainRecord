class CommentInfo {
  final int index;
  final int blogIndex;
  final bool takeMorning;
  final bool takeEvening;
  final bool takeAnalogesic;
  final bool takeNarcotic;
  final bool usePath;
  final String comment;
  final int swellingLv;
  final int activeMode;
  final int sleepMode;
  final bool charging;

  CommentInfo(
      {required this.index,
      required this.blogIndex,
      required this.takeMorning,
      required this.takeEvening,
      required this.takeAnalogesic,
      required this.takeNarcotic,
      required this.usePath,
      required this.comment,
      required this.swellingLv,
      required this.activeMode,
      required this.sleepMode,
      required this.charging});

  factory CommentInfo.fromJson(Map<String, dynamic> json) {
    return CommentInfo(
        index: json['index'],
        blogIndex: json['blogIndex'],
        takeMorning: json['Morning'],
        takeEvening: json['Evening'],
        takeAnalogesic: json['Analgesic'],
        takeNarcotic: json['Narcotic'],
        usePath: json['usePath'],
        comment: json['Comments'],
        swellingLv: json['swellingLv'],
        activeMode: json['activeMode'],
        sleepMode: json['sleepMode'],
        charging: json['charging']);
  }
}
