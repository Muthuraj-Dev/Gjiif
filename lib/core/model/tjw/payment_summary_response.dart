class PaymentSummaryResponse {
  String? status;
  String? message;
  PaymentSummaryData? paymentSummaryData;

  PaymentSummaryResponse({this.status, this.message, this.paymentSummaryData});

  PaymentSummaryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    paymentSummaryData =
        json['data'] != null ? PaymentSummaryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (paymentSummaryData != null) {
      data['data'] = paymentSummaryData!.toJson();
    }
    return data;
  }
}

class PaymentSummaryData {
  List<VisitorSummary>? visitorSummary;
  EventDetail? eventDetail;
  int? totalPayment;

  PaymentSummaryData({
    this.visitorSummary,
    this.eventDetail,
    this.totalPayment,
  });

  PaymentSummaryData.fromJson(Map<String, dynamic> json) {
    if (json['visitorSummary'] != null) {
      visitorSummary = <VisitorSummary>[];
      json['visitorSummary'].forEach((v) {
        visitorSummary!.add(VisitorSummary.fromJson(v));
      });
    }
    eventDetail =
        json['eventDetail'] != null
            ? EventDetail.fromJson(json['eventDetail'])
            : null;
    totalPayment = json['totalPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (visitorSummary != null) {
      data['visitorSummary'] = visitorSummary!.map((v) => v.toJson()).toList();
    }
    if (eventDetail != null) {
      data['eventDetail'] = eventDetail!.toJson();
    }
    data['totalPayment'] = totalPayment;
    return data;
  }
}

class VisitorSummary {
  int? visitorID;
  String? visitorName;
  int? preRegistrationFee;

  VisitorSummary({this.visitorID, this.visitorName, this.preRegistrationFee});

  VisitorSummary.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorName = json['visitorName'];
    preRegistrationFee = json['preRegistrationFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visitorID'] = visitorID;
    data['visitorName'] = visitorName;
    data['preRegistrationFee'] = preRegistrationFee;
    return data;
  }
}

class EventDetail {
  int? eventID;
  int? eventMasterID;
  String? eventName;
  String? date;
  String? venue;
  String? city;
  String? eventLogoURL;

  EventDetail({
    this.eventID,
    this.eventMasterID,
    this.eventName,
    this.date,
    this.venue,
    this.city,
    this.eventLogoURL,
  });

  EventDetail.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventMasterID = json['eventMasterID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogoURL = json['eventLogoURL'];
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
    return data;
  }
}
