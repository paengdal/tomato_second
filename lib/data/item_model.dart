import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ItemModel {
  late String itemKey;
  late String userKey;
  late List<String> imageDownloadUrls;
  late String title;
  late String category;
  late num price;
  late bool neogotiable;
  late String detail;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  late DocumentReference? reference;

  ItemModel(
      {required this.itemKey,
      required this.userKey,
      required this.imageDownloadUrls,
      required this.title,
      required this.category,
      required this.price,
      required this.neogotiable,
      required this.detail,
      required this.address,
      required this.geoFirePoint,
      required this.createdDate,
      this.reference});

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    userKey = json["userKey"] ?? "";
    imageDownloadUrls = json["imageDownloadUrls"] == null
        ? []
        : List<String>.from(json["imageDownloadUrls"]);
    title = json["title"] ?? "";
    category = json["category"] ?? "none";
    price = json["price"] ?? 0;
    neogotiable = json["neogotiable"] ?? false;
    detail = json["detail"] ?? "";
    address = json["address"] ?? "";
    geoFirePoint = GeoFirePoint((json["geoFirePoint"]['geopoint']).latitude,
        (json["geoFirePoint"]['geopoint']).longitude);
    createdDate = json["createDate"] == null
        ? DateTime.now().toUtc()
        : (json["createDate"] as Timestamp).toDate();
  }

  ItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["userKey"] = userKey;
    data["imageDownloadUrls"] = imageDownloadUrls;
    data["title"] = title;
    data["category"] = category;
    data["price"] = price;
    data["neogotiable"] = neogotiable;
    data["detail"] = detail;
    data["address"] = address;
    data["geoFirePoint"] = geoFirePoint.data;
    data["createdDate"] = createdDate;
    return data;
  }

  static String generateItemKey(String uid) {
    String timeMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '{$uid}_$timeMilli';
  }
}
