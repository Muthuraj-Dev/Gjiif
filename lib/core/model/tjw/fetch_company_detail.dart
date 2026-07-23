class FetchCompanyDetail {
  String? status;
  String? message;
  companyData? data;

  FetchCompanyDetail({this.status, this.message, this.data});

  FetchCompanyDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? companyData.fromJson(json['data']) : null;
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

class companyData {
  String? gstN;
  String? companyType;
  String? companyName;
  String? address;
  String? city;
  String? pincode;
  String? stateID;
  String? district;
  String? landline;
  String? mobileNumber;
  String? email;
  int? primaryVisitorID;
  String? gstFileName;
  int? saveFlag;
  int? gstChangedFlag;
  String? gstFilePath;

  companyData({
    this.gstN,
    this.companyType,
    this.companyName,
    this.address,
    this.city,
    this.pincode,
    this.stateID,
    this.district,
    this.landline,
    this.mobileNumber,
    this.email,
    this.primaryVisitorID,
    this.gstFileName,
    this.saveFlag,
    this.gstChangedFlag,
    this.gstFilePath,
  });

  companyData.fromJson(Map<String, dynamic> json) {
    gstN = json['gstN'];
    companyType = json['companyType'];
    companyName = json['companyName'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    stateID = json['stateID'];
    district = json['district'];
    landline = json['landline'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    primaryVisitorID = json['primaryVisitorID'];
    gstFileName = json['gstFileName'];
    saveFlag = json['saveFlag'];
    gstChangedFlag = json['gstChangedFlag'];
    gstFilePath = json['gstFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gstN'] = gstN;
    data['companyType'] = companyType;
    data['companyName'] = companyName;
    data['address'] = address;
    data['city'] = city;
    data['pincode'] = pincode;
    data['stateID'] = stateID;
    data['district'] = district;
    data['landline'] = landline;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['primaryVisitorID'] = primaryVisitorID;
    data['gstFileName'] = gstFileName;
    data['saveFlag'] = saveFlag;
    data['gstChangedFlag'] = gstChangedFlag;
    data['gstFilePath'] = gstFilePath;
    return data;
  }
}
