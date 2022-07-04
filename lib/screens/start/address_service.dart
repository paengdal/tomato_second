import 'package:dio/dio.dart';
import 'package:tomato_record/constants/keys.dart';
import 'package:tomato_record/data/address_model.dart';
import 'package:tomato_record/data/cdn_address_model.dart';

import '../../utils/logger.dart';

class AddressService {
  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'size': 30,
      'query': text,
      'type': 'ADDRESS',
      'category': 'ROAD',
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      logger.e(e.message);
    });

    AddressModel addressModel =
        AddressModel.fromJson(response.data['response']);
    logger.d(addressModel);

    return addressModel;
  }

  Future<List<CdnAddressModel>> findAddressByCoordinate(
      {required double long, required double lat}) async {
    final List<Map<String, dynamic>> formDatas = [];

    formDatas.add({
      'key': VWORLD_KEY,
      'request': 'GetAddress',
      'point': '$long, $lat',
      'service': 'address',
      'type': 'PARCEL',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'request': 'GetAddress',
      'point': '${long - 0.01}, $lat',
      'service': 'address',
      'type': 'PARCEL',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'request': 'GetAddress',
      'point': '${long + 0.01}, $lat',
      'service': 'address',
      'type': 'PARCEL',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'request': 'GetAddress',
      'point': '$long, ${lat - 0.01}',
      'service': 'address',
      'type': 'PARCEL',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'request': 'GetAddress',
      'point': '$long, ${lat + 0.01}',
      'service': 'address',
      'type': 'PARCEL',
    });

    logger.d(formDatas);

    List<CdnAddressModel> cdnAddresses = [];

    for (Map<String, dynamic> formData in formDatas) {
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        logger.e(e.message);
      });

      CdnAddressModel cdnAddressModel =
          CdnAddressModel.fromJson(response.data['response']);

      if (response.data['response']['status'] == 'OK')
        cdnAddresses.add(cdnAddressModel);
    }

    logger.d(cdnAddresses);
    return cdnAddresses;
  }
}
