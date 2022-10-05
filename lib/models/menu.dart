import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuID;
  String? sellerID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? pushlisedDate;
  String? thumbnailUrl;
  String? status;
  Menus({
    this.menuID,
    this.menuInfo,
    this.menuTitle,
    this.pushlisedDate,
    this.sellerID,
    this.status,
    this.thumbnailUrl,
  });
  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    sellerID = json['sellerID'];
    menuTitle = json['menuTitle'];
    menuInfo = json['menuInfo'];
    pushlisedDate = json['pushlisedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuID'] = this.menuID;
    data['sellerID'] = this.sellerID;
    data['menuTitle'] = this.menuTitle;
    data['menuInfo'] = this.menuInfo;
    data['pushlisedDate'] = this.pushlisedDate;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['status'] = this.status;
    return data;
  }
}
