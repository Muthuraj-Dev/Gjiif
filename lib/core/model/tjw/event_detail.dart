class EventDetailResponse {
  String? status;
  String? message;
  EventData? eventData;

  EventDetailResponse({this.status, this.message, this.eventData});

  EventDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    eventData = json['data'] != null ? EventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (eventData != null) {
      data['data'] = eventData!.toJson();
    }
    return data;
  }
}

class EventData {
  EventDetails? eventDetails;
  List<PreRegistrationDetail>? preRegistrationDetail;

  EventData({this.eventDetails, this.preRegistrationDetail});

  EventData.fromJson(Map<String, dynamic> json) {
    eventDetails =
        json['eventDetails'] != null
            ? EventDetails.fromJson(json['eventDetails'])
            : null;
    if (json['preRegistrationDetail'] != null) {
      preRegistrationDetail = <PreRegistrationDetail>[];
      json['preRegistrationDetail'].forEach((v) {
        preRegistrationDetail!.add(PreRegistrationDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eventDetails != null) {
      data['eventDetails'] = eventDetails!.toJson();
    }
    if (preRegistrationDetail != null) {
      data['preRegistrationDetail'] =
          preRegistrationDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventDetails {
  int? eventID;
  String? eventName;
  String? eventVenue;
  String? eventCity;
  String? eventDates;
  String? eventTitle;
  String? eventDescription;
  String? eventLogoURL;
  String? eventBannerURL;

  EventDetails({
    this.eventID,
    this.eventName,
    this.eventVenue,
    this.eventCity,
    this.eventDates,
    this.eventTitle,
    this.eventDescription,
    this.eventLogoURL,
    this.eventBannerURL,
  });

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventName = json['eventName'];
    eventVenue = json['eventVenue'];
    eventCity = json['eventCity'];
    eventDates = json['eventDates'];
    eventTitle = json['eventTitle'];
    eventDescription = json['eventDescription'];
    eventLogoURL = json['eventLogoURL'];
    eventBannerURL = json['eventBannerURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventID'] = eventID;
    data['eventName'] = eventName;
    data['eventVenue'] = eventVenue;
    data['eventCity'] = eventCity;
    data['eventDates'] = eventDates;
    data['eventTitle'] = eventTitle;
    data['eventDescription'] = eventDescription;
    data['eventLogoURL'] = eventLogoURL;
    data['eventBannerURL'] = eventBannerURL;
    return data;
  }
}

class PreRegistrationDetail {
  int? eventID;
  String? phase;
  String? preRegistrationFee;
  String? phaseDate;

  PreRegistrationDetail({
    this.eventID,
    this.phase,
    this.preRegistrationFee,
    this.phaseDate,
  });

  PreRegistrationDetail.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    phase = json['phase'];
    preRegistrationFee = json['preRegistrationFee'];
    phaseDate = json['phaseDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventID'] = eventID;
    data['phase'] = phase;
    data['preRegistrationFee'] = preRegistrationFee;
    data['phaseDate'] = phaseDate;
    return data;
  }
}
