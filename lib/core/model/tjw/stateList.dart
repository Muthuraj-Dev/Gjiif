class StateList {
  Response? response;
  List<StateData>? stateData;

  StateList({this.response, this.stateData});

  StateList.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    if (json['data'] != null) {
      stateData = <StateData>[];
      json['data'].forEach((v) {
        stateData!.add(StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    if (stateData != null) {
      data['data'] = stateData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? status;
  String? message;

  Response({this.status, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class StateData {
  int? stateID;
  String? stateName;
  String? countryID;

  StateData({this.stateID, this.stateName, this.countryID});

  StateData.fromJson(Map<String, dynamic> json) {
    stateID = json['stateID'];
    stateName = json['stateName'];
    countryID = json['countryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stateID'] = stateID;
    data['stateName'] = stateName;
    data['countryID'] = countryID;
    return data;
  }
}
