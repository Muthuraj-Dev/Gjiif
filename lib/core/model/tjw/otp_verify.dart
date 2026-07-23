class OtpVerify {
  String? status;
  String? message;
  Data? data;

  OtpVerify({this.status, this.message, this.data});

  OtpVerify.fromJson(Map<String, dynamic> json) {
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
  bool? isCompanyDetailFull;

  Data({this.visitorID, this.isCompanyDetailFull});

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    isCompanyDetailFull = json['isCompanyDetailFull'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitorID'] = visitorID;
    data['isCompanyDetailFull'] = isCompanyDetailFull;
    return data;
  }
}
