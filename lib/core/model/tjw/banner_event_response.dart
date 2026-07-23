class BannerEventResponse {
  String? status;
  String? message;
  BannerEventData? bannerEventData;

  BannerEventResponse({this.status, this.message, this.bannerEventData});

  BannerEventResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bannerEventData =
        json['data'] != null ? BannerEventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (bannerEventData != null) {
      data['data'] = bannerEventData!.toJson();
    }
    return data;
  }
}

class BannerEventData {
  List<BannerList>? bannerList;
  List<EventsList>? eventsList;

  BannerEventData({this.bannerList, this.eventsList});

  BannerEventData.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = <BannerList>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(BannerList.fromJson(v));
      });
    }
    if (json['eventsList'] != null) {
      eventsList = <EventsList>[];
      json['eventsList'].forEach((v) {
        eventsList!.add(EventsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bannerList != null) {
      data['bannerList'] = bannerList!.map((v) => v.toJson()).toList();
    }
    if (eventsList != null) {
      data['eventsList'] = eventsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  String? bannerURL;
  int? eventID;

  BannerList({this.bannerURL, this.eventID});

  BannerList.fromJson(Map<String, dynamic> json) {
    bannerURL = json['bannerURL'];
    eventID = json['eventID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bannerURL'] = bannerURL;
    data['eventID'] = eventID;
    return data;
  }
}

class EventsList {
  int? eventID;
  String? eventName;
  String? date;
  String? venue;
  String? city;
  String? eventLogo;

  String? eventStartOn;
  String? editionNumber;
  String? editionTag;
  String? stallUrl;

  EventsList({
    this.eventID,
    this.eventName,
    this.date,
    this.venue,
    this.city,
    this.eventLogo,

    this.eventStartOn,
    this.editionNumber,
    this.editionTag,
    this.stallUrl
  });

  EventsList.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogo = json['eventLogoURL'];

    eventStartOn = json['eventStartsOn'];
    editionNumber = json['editionNumber'];
    editionTag = json['editionTag'];
    stallUrl = json['stallEnquiryLink'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventID'] = eventID;
    data['eventName'] = eventName;
    data['date'] = date;
    data['venue'] = venue;
    data['city'] = city;
    data['eventLogoURL'] = eventLogo;

    data['eventStartsOn'] = eventStartOn;
    data['editionNumber'] = editionNumber;
    data['editionTag'] = editionTag;
    data['stallEnquiryLink'] = stallUrl;
    return data;
  }
}
