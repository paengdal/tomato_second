import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.geoFirePoint,
    required this.createDate,
    this.reference,
  });

  // UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
  //   userKey = json["userKey"];
  //   phoneNumber = json["phoneNumber"];
  //   address = json["address"];
  //   geoFirePoint = GeoFirePoint((json["geoFirePoint"]['geopoing']).latitude,
  //       (json["geoFirePoint"]['geopoing']).longitude);
  //   createDate = json["createDate"] == null
  //       ? DateTime.now().toUtc()
  //       : (json["createDate"] as Timestamp).toDate();
  //   reference = json["reference"];
  // }

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference)
      : phoneNumber = json["phoneNumber"],
        address = json["address"],
        geoFirePoint = GeoFirePoint((json["geoFirePoint"]['geopoint']).latitude,
            (json["geoFirePoint"]['geopoint']).longitude),
        createDate = json["createDate"] == null
            ? DateTime.now().toUtc()
            : (json["createDate"] as Timestamp).toDate();

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["phoneNumber"] = phoneNumber;
    data["address"] = address;
    data["geoFirePoint"] = geoFirePoint.data;
    data["createDate"] = createDate;
    return data;
  }
}
