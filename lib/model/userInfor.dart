class UserInfor {
  final String token;

  UserInfor({required this.token});

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(token: json['token']);
  }
}
