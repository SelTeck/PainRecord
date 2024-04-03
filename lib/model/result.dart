class Result {
  final String message;

  int status = 0;

  Result({required this.message});

  factory Result.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? Result(message: json['message'])
        : Result.message(msg: '');
  }

  factory Result.message({required String msg}) {
    return Result(message: msg);
  }
}
