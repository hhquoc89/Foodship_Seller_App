class Orders {
  String? addressID;
  String? addressName;
  bool? isSuccess;
  String? orderBy;
  String? orderId;
  String? orderTime;
  String? paymentDetails;
  String? sellerUID;
  String? shipperUID;
  String? status;
  num? realEarn;
  num? totalAmount;
  List<OrdersList>? ordersList;

  Orders(
      {this.addressID,
      this.addressName,
      this.isSuccess,
      this.orderBy,
      this.orderId,
      this.orderTime,
      this.paymentDetails,
      this.sellerUID,
      this.shipperUID,
      this.status,
      this.totalAmount,
      this.realEarn,
      this.ordersList});

  Orders.fromJson(Map<String, dynamic> json) {
    addressID = json['addressID'];
    addressName = json['addressName'];
    isSuccess = json['isSuccess'];
    orderBy = json['orderBy'];
    orderId = json['orderId'];
    orderTime = json['orderTime'];
    paymentDetails = json['paymentDetails'];
    sellerUID = json['sellerUID'];
    shipperUID = json['shipperUID'];
    status = json['status'];
    totalAmount = json['totalAmount'];
    realEarn = json['realEarn'];
    if (json['ordersList'] != null) {
      ordersList = <OrdersList>[];
      json['ordersList'].forEach((v) {
        ordersList!.add(OrdersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressID'] = this.addressID;
    data['addressName'] = this.addressName;
    data['isSuccess'] = this.isSuccess;
    data['orderBy'] = this.orderBy;
    data['orderId'] = this.orderId;
    data['orderTime'] = this.orderTime;
    data['paymentDetails'] = this.paymentDetails;
    data['sellerUID'] = this.sellerUID;
    data['shipperUID'] = this.shipperUID;
    data['status'] = this.status;
    data['totalAmount'] = this.totalAmount;
    data['realEarn'] = this.realEarn;
    if (this.ordersList != null) {
      data['ordersList'] = this.ordersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersList {
  String? itemID;
  int? price;
  int? qty;
  String? status;
  String? title;

  OrdersList({this.itemID, this.price, this.qty, this.status, this.title});

  OrdersList.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    price = json['price'];
    qty = json['qty'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['status'] = this.status;
    data['title'] = this.title;
    return data;
  }
}
