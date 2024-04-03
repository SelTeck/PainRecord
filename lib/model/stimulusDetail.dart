class StimulusDetail {
  final String type;
  final double upright;
  final double lyingFront;
  final double lyingBack;
  final double lyingLeft;
  final double lyingRight;
  final double reclining;
  final String createAtTime;

  StimulusDetail(
      {required this.type,
      required this.upright,
      required this.lyingFront,
      required this.lyingBack,
      required this.lyingLeft,
      required this.lyingRight,
      required this.reclining,
      required this.createAtTime});

  factory StimulusDetail.fromJson(Map<String, dynamic> json) {
    return StimulusDetail(
        type: json['type'],
        upright: json['upright'] is int
            ? (json['upright'].toInt()).toDouble()
            : json['upright'].toDouble(),
        lyingFront: json['lying_Front'] is int
            ? (json['lying_Front'].toInt()).toDouble()
            : json['lying_Front'].toDouble(),
        lyingBack: json['lying_Back'] is int
            ? (json['lying_Back']).toDouble()
            : json['lying_Back'].toDouble(),
        lyingLeft: json['lying_Left'] is int
            ? (json['lying_Left'].toInt()).toDouble()
            : json['lying_Left'].toDouble(),
        lyingRight: json['lying_Right'] is int
            ? (json['lying_Right'].toInt()).toDouble()
            : json['lying_Right'].toDouble(),
        reclining: json['reclining'] is int
            ? (json['reclining'].toInt()).toDouble()
            : json['reclining'].toDouble(),
        createAtTime: json['createAtTime']);
  }
}
