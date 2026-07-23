class SingleOtpVerifyResponse {
  String? status;
  String? message;
  Data? data;

  SingleOtpVerifyResponse({this.status, this.message, this.data});

  SingleOtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? visitorID;
  String? visitorPhotoURL;
  int? status;
  String? barcode;
  String? visitorName;
  String? designation;
  String? company;
  String? address;
  String? city;
  String? pincode;
  String? gstn;
  String? phone;
  String? emailID;

  Data({
    this.visitorID,
    this.visitorPhotoURL,
    this.status,
    this.barcode,
    this.visitorName,
    this.designation,
    this.company,
    this.address,
    this.city,
    this.pincode,
    this.gstn,
    this.phone,
    this.emailID,
  });

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorPhotoURL = json['visitorPhotoURL'];
    status = json['status'];
    barcode = json['barcode'];
    visitorName = json['visitorName'];
    designation = json['designation'];
    company = json['company'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    gstn = json['gstn'];
    phone = json['phone'];
    emailID = json['emailID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitorID'] = visitorID;
    data['visitorPhotoURL'] = visitorPhotoURL;
    data['status'] = status;
    data['barcode'] = barcode;
    data['visitorName'] = visitorName;
    data['designation'] = designation;
    data['company'] = company;
    data['address'] = address;
    data['city'] = city;
    data['pincode'] = pincode;
    data['gstn'] = gstn;
    data['phone'] = phone;
    data['emailID'] = emailID;
    return data;
  }
}
