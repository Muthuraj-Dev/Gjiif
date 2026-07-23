class DropdownApi {
  String? status;
  String? message;
  List<DropDownData>? data;

  DropdownApi({this.status, this.message, this.data});

  DropdownApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DropDownData>[];
      json['data'].forEach((v) {
        data!.add(DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  int? eventID;
  int? eventMasterID;
  String? eventName;
  String? eventShortName;
  String? date;
  String? venue;
  String? city;
  String? eventLogoURL;

  DropDownData({
    this.eventID,
    this.eventMasterID,
    this.eventName,
    this.date,
    this.venue,
    this.eventShortName,
    this.city,
    this.eventLogoURL,
  });

  DropDownData.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventMasterID = json['eventMasterID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogoURL = json['eventLogoURL'];
    eventShortName = json['eventShortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventID'] = eventID;
    data['eventMasterID'] = eventMasterID;
    data['eventName'] = eventName;
    data['date'] = date;
    data['venue'] = venue;
    data['city'] = city;
    data['eventLogoURL'] = eventLogoURL;
    data['eventShortName'] = eventShortName;
    return data;
  }
}
