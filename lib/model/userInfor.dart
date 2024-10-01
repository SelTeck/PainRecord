class UserInfor {
  final String userId;
  final String token;

  UserInfor({required this.userId, required this.token});

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(userId: json['userId'], token: json['token']);
  }
}
