class Result {
  final String message;

  const Result({required this.message});

  factory Result.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? Result(message: json['message'])
        : Result.message(msg: 'null');
  }

  factory Result.message({required String msg}) {
    return Result(message: msg);
  }
}
