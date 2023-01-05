class UserModel {
  String? userUID;
  String? userName;
  String? userAvatarUrl;
  String? userEmail;
  UserModel({this.userUID, this.userName, this.userAvatarUrl, this.userEmail});
  UserModel.fromJson(Map<String, dynamic> json) {
    userUID = json['userUID'];
    userName = json['userName'];
    userAvatarUrl = json['userAvatarUrl'];
    userEmail = json['userEmail'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userUID'] = this.userUID;
    data['userName'] = this.userName;
    data['userAvatarUrl'] = this.userAvatarUrl;
    data['userEmail'] = this.userEmail;
    return data;
  }
}
