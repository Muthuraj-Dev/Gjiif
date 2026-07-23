class RegisteredBadgeResponse {
  String? status;
  String? message;
  List<RegisteredVisitorBadgeList>? registeredVisitorBadgeList;

  RegisteredBadgeResponse({
    this.status,
    this.message,
    this.registeredVisitorBadgeList,
  });

  RegisteredBadgeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      registeredVisitorBadgeList = <RegisteredVisitorBadgeList>[];
      json['data'].forEach((v) {
        registeredVisitorBadgeList!.add(RegisteredVisitorBadgeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (registeredVisitorBadgeList != null) {
      data['data'] =
          registeredVisitorBadgeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisteredVisitorBadgeList {
  String? visitorName;
  String? registrationID;
  String? visitorPhone;
  String? photoURL;

  RegisteredVisitorBadgeList({
    this.visitorName,
    this.registrationID,
    this.visitorPhone,
    this.photoURL,
  });

  RegisteredVisitorBadgeList.fromJson(Map<String, dynamic> json) {
    visitorName = json['visitorName'];
    registrationID = json['registrationID'];
    visitorPhone = json['visitorPhone'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitorName'] = visitorName;
    data['registrationID'] = registrationID;
    data['visitorPhone'] = visitorPhone;
    data['photoURL'] = photoURL;
    return data;
  }
}
