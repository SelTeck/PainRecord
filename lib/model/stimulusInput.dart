import 'package:pain_record/model/result.dart';

class StimulusInput extends Result {
  late int _statusCode;
  final int number;

  StimulusInput({required super.message, required this.number});

  factory StimulusInput.fromJson(Map<String, dynamic> json) {
    return StimulusInput(message: json['message'], number: json['number']);
  }

  get statusCode => _statusCode;
  set statusCode(code) => _statusCode = code;
}
