class AddressModel {
  Page? page;
  Result? result;

  AddressModel({this.page, this.result});

  AddressModel.fromJson(Map<String, dynamic> json) {
    this.page = json["page"] == null ? null : Page.fromJson(json["page"]);
    this.result =
        json["result"] == null ? null : Result.fromJson(json["result"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.page != null) data["page"] = this.page?.toJson();
    if (this.result != null) data["result"] = this.result?.toJson();
    return data;
  }
}

class Result {
  String? crs;
  String? type;
  List<Items>? items;

  Result({this.crs, this.type, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    this.crs = json["crs"];
    this.type = json["type"];
    this.items = json["items"] == null
        ? null
        : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["crs"] = this.crs;
    data["type"] = this.type;
    if (this.items != null)
      data["items"] = this.items?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Items {
  String? id;
  Address? address;
  Point? point;

  Items({this.id, this.address, this.point});

  Items.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.address =
        json["address"] == null ? null : Address.fromJson(json["address"]);
    this.point = json["point"] == null ? null : Point.fromJson(json["point"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    if (this.address != null) data["address"] = this.address?.toJson();
    if (this.point != null) data["point"] = this.point?.toJson();
    return data;
  }
}

class Point {
  String? x;
  String? y;

  Point({this.x, this.y});

  Point.fromJson(Map<String, dynamic> json) {
    this.x = json["x"];
    this.y = json["y"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["x"] = this.x;
    data["y"] = this.y;
    return data;
  }
}

class Address {
  String? zipcode;
  String? category;
  String? road;
  String? parcel;
  String? bldnm;
  String? bldnmdc;

  Address(
      {this.zipcode,
      this.category,
      this.road,
      this.parcel,
      this.bldnm,
      this.bldnmdc});

  Address.fromJson(Map<String, dynamic> json) {
    this.zipcode = json["zipcode"];
    this.category = json["category"];
    this.road = json["road"];
    this.parcel = json["parcel"];
    this.bldnm = json["bldnm"];
    this.bldnmdc = json["bldnmdc"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["zipcode"] = this.zipcode;
    data["category"] = this.category;
    data["road"] = this.road;
    data["parcel"] = this.parcel;
    data["bldnm"] = this.bldnm;
    data["bldnmdc"] = this.bldnmdc;
    return data;
  }
}

class Page {
  String? total;
  String? current;
  String? size;

  Page({this.total, this.current, this.size});

  Page.fromJson(Map<String, dynamic> json) {
    this.total = json["total"];
    this.current = json["current"];
    this.size = json["size"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["total"] = this.total;
    data["current"] = this.current;
    data["size"] = this.size;
    return data;
  }
}
