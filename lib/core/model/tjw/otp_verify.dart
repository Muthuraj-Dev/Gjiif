class OtpVerify {
  String? status;
  String? message;
  Jwt? jwt;
  Data? data;

  OtpVerify({this.status, this.message, this.jwt, this.data});

  OtpVerify.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    jwt = json['jwt'] != null ? Jwt.fromJson(json['jwt']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (jwt != null) {
      data['jwt'] = jwt!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Jwt {
  String? token;
  String? expiryDate;

  Jwt({this.token, this.expiryDate});

  Jwt.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiryDate'] = expiryDate;
    return data;
  }
}

class Data {
  int? visitorID;
  bool? isCompanyDetailFull;
  int? otp;

  Data({this.visitorID, this.isCompanyDetailFull, this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    isCompanyDetailFull = json['isCompanyDetailFull'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitorID'] = visitorID;
    data['isCompanyDetailFull'] = isCompanyDetailFull;
    data['otp'] = otp;
    return data;
  }
}
