class FetchCompanyType {
  String? status;
  String? message;
  List<CompanyTypeData>? companyTypeData;

  FetchCompanyType({this.status, this.message, this.companyTypeData});

  FetchCompanyType.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      companyTypeData = <CompanyTypeData>[];
      json['data'].forEach((v) {
        companyTypeData!.add(CompanyTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (companyTypeData != null) {
      data['data'] = companyTypeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyTypeData {
  int? id;
  String? companyType;

  CompanyTypeData({this.id, this.companyType});

  CompanyTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyType = json['companyType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyType'] = companyType;
    return data;
  }
}
