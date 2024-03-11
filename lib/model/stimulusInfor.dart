class StimulusInfor {
  List<dynamic> json;

  StimulusInfor({required this.json});

  factory StimulusInfor.fromJson(Map<String, dynamic> json) {
    // List<dynamic> item = json['stimulusInfo'];
    // List<dynamic> list = json.decode(receivedJson);
    // Fact fact = StimulusType.fromJson(item[0]);
    // for (int i = 0; i < item.length; ++i) {
    //   StimulusType type = StimulusType.fromJson(item[0]);

    // }
    // StimulusType type1 = StimulusType.fromJson(item[0]);
    // StimulusType type2 = StimulusType.fromJson(item[1]);
    return StimulusInfor(json: json['stimulusInfo']);
  }

  // final String type;
  // final int number;
  // final String createAtTime;

  // StimulusInfo(
  //     {required this.type,
  //     required this.number,
  //     required this.createAtTime});

  // factory StimulusInfo.fromJson(Map<String, dynamic> json) {
  //   return StimulusInfo(
  //       type: json['type'],
  //       number: json['index'],
  //       createAtTime: json['createAtTime'],
  //       );
  // }
}

class StimulusType {
  final String type;
  final int number;
  final String createAtTime;

  StimulusType(
      {required this.type, required this.number, required this.createAtTime});

  factory StimulusType.fromJson(Map<String, dynamic> json) {
    return StimulusType(
        type: json['type'],
        number: json['index'],
        createAtTime: json['createAtTime']);
  }
}
