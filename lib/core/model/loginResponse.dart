class LoginResponse {
  String? message;
  String? accessToken;
  String? refreshToken;
  User? user;
  String? orderId;

  LoginResponse({this.message, this.accessToken, this.refreshToken, this.user,this.orderId});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    orderId = json['orderId'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['orderId'] = orderId;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? phoneNumber;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;


  User(
      {this.id,
        this.phoneNumber,
        this.name,
        this.email,
        this.createdAt,
        this.updatedAt,
       });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // if (json['addresses'] != null) {
    //   addresses = <Null>[];
    //   json['addresses'].forEach((v) {
    //     addresses!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['orders'] != null) {
    //   orders = <Null>[];
    //   json['orders'].forEach((v) {
    //     orders!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['wishlist'] != null) {
    //   wishlist = <Null>[];
    //   json['wishlist'].forEach((v) {
    //     wishlist!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['cartItems'] != null) {
    //   cartItems = <Null>[];
    //   json['cartItems'].forEach((v) {
    //     cartItems!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // if (this.addresses != null) {
    //   data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    // }
    // if (this.orders != null) {
    //   data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    // }
    // if (this.wishlist != null) {
    //   data['wishlist'] = this.wishlist!.map((v) => v.toJson()).toList();
    // }
    // if (this.cartItems != null) {
    //   data['cartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}