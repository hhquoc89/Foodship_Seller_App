import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? pushlisedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;
  Items({
    this.menuID,
    this.sellerID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.pushlisedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price,
  });
  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    sellerID = json['sellerID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    longDescription = json['longDescription'];
    pushlisedDate = json['pushlisedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
    price = json['price'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuID'] = this.menuID;
    data['sellerID'] = this.sellerID;
    data['itemID'] = this.itemID;
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['longDescription'] = this.longDescription;
    data['pushlisedDate'] = this.pushlisedDate;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['status'] = this.status;
    data['price'] = this.price;
    return data;
  }
}
