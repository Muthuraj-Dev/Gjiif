class DefaultEventDetails {
  String? title;
  String? imageUrl;
  String? icon;
  String? description;
  String? logo;

  DefaultEventDetails({this.title, this.imageUrl, this.icon, this.description,this.logo});

  DefaultEventDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageUrl = json['imageUrl'];
    icon = json['icon'];
    description = json['description'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['icon'] = icon;
    data['description'] = description;
    data['logo'] = logo;
    return data;
  }
}
