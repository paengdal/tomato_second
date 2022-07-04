
class CdnAddressModel {
  Input? input;
  List<Result>? result;

  CdnAddressModel({this.input, this.result});

  CdnAddressModel.fromJson(Map<String, dynamic> json) {
    this.input = json["input"] == null ? null : Input.fromJson(json["input"]);
    this.result = json["result"]==null ? null : (json["result"] as List).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.input != null)
      data["input"] = this.input?.toJson();
    if(this.result != null)
      data["result"] = this.result?.map((e)=>e.toJson()).toList();
    return data;
  }
}

class Result {
  String? zipcode;
  String? type;
  String? text;
  Structure? structure;

  Result({this.zipcode, this.type, this.text, this.structure});

  Result.fromJson(Map<String, dynamic> json) {
    this.zipcode = json["zipcode"];
    this.type = json["type"];
    this.text = json["text"];
    this.structure = json["structure"] == null ? null : Structure.fromJson(json["structure"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["zipcode"] = this.zipcode;
    data["type"] = this.type;
    data["text"] = this.text;
    if(this.structure != null)
      data["structure"] = this.structure?.toJson();
    return data;
  }
}

class Structure {
  String? level0;
  String? level1;
  String? level2;
  String? level3;
  String? level4L;
  String? level4Lc;
  String? level4A;
  String? level4Ac;
  String? level5;
  String? detail;

  Structure({this.level0, this.level1, this.level2, this.level3, this.level4L, this.level4Lc, this.level4A, this.level4Ac, this.level5, this.detail});

  Structure.fromJson(Map<String, dynamic> json) {
    this.level0 = json["level0"];
    this.level1 = json["level1"];
    this.level2 = json["level2"];
    this.level3 = json["level3"];
    this.level4L = json["level4L"];
    this.level4Lc = json["level4LC"];
    this.level4A = json["level4A"];
    this.level4Ac = json["level4AC"];
    this.level5 = json["level5"];
    this.detail = json["detail"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["level0"] = this.level0;
    data["level1"] = this.level1;
    data["level2"] = this.level2;
    data["level3"] = this.level3;
    data["level4L"] = this.level4L;
    data["level4LC"] = this.level4Lc;
    data["level4A"] = this.level4A;
    data["level4AC"] = this.level4Ac;
    data["level5"] = this.level5;
    data["detail"] = this.detail;
    return data;
  }
}

class Input {
  Point? point;
  String? crs;
  String? type;

  Input({this.point, this.crs, this.type});

  Input.fromJson(Map<String, dynamic> json) {
    this.point = json["point"] == null ? null : Point.fromJson(json["point"]);
    this.crs = json["crs"];
    this.type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.point != null)
      data["point"] = this.point?.toJson();
    data["crs"] = this.crs;
    data["type"] = this.type;
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