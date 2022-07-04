import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_record/constants/shared_pref_keys.dart';
import 'package:tomato_record/data/cdn_address_model.dart';
import 'package:tomato_record/utils/logger.dart';
import 'package:tomato_record/screens/start/address_service.dart';
import '../../constants/common_size.dart';
import '../../data/address_model.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressModel? _addressModel;
  List<CdnAddressModel> _cdnAddressModelList = [];
  bool _isGettingLocation = false;

  TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: common_padding, right: common_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _cdnAddressModelList.clear();
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {});
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              prefixIconConstraints:
                  BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(10, 47)),
            onPressed: () async {
              _addressModel = null;
              _cdnAddressModelList.clear();

              setState(() {
                _isGettingLocation = true;
              });
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              _locationData = await location.getLocation();
              logger.d(_locationData);

              List<CdnAddressModel> addresses = await AddressService()
                  .findAddressByCoordinate(
                      long: _locationData.longitude!,
                      lat: _locationData.latitude!);
              _cdnAddressModelList.addAll(addresses);

              setState(() {
                _isGettingLocation = false;
              });
            },
            label: Text(
              _isGettingLocation ? '위치를 찾는 중입니다..' : '현재 위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
            icon: _isGettingLocation
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    CupertinoIcons.compass,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          if (_addressModel != null)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: common_padding),
                itemBuilder: (context, index) {
                  if (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(
                          _addressModel!.result!.items![index].address!.road ??
                              "",
                          num.parse(
                              _addressModel!.result!.items![index].point!.y ??
                                  "0"),
                          num.parse(
                              _addressModel!.result!.items![index].point!.x ??
                                  "0"));
                    },
                    title: Text(
                      _addressModel!.result!.items![index].address!.road ?? "",
                    ),
                    subtitle: Text(
                      _addressModel!.result!.items![index].address!.parcel ??
                          "",
                    ),
                  );
                },
                itemCount: (_addressModel == null ||
                        _addressModel!.result == null ||
                        _addressModel!.result!.items == null)
                    ? 0
                    : _addressModel!.result!.items!.length,
              ),
            ),
          if (_cdnAddressModelList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: common_padding),
                itemBuilder: (context, index) {
                  if (_cdnAddressModelList[index].result == null ||
                      _cdnAddressModelList[index].result!.isEmpty) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(
                          _cdnAddressModelList[index].result![0].text ?? "",
                          num.parse(
                              _cdnAddressModelList[index].input!.point!.y ??
                                  "0"),
                          num.parse(
                              _cdnAddressModelList[index].input!.point!.x ??
                                  "0"));
                    },
                    title: Text(
                      _cdnAddressModelList[index].result![0].text ?? "",
                    ),
                    subtitle: Text(
                      _cdnAddressModelList[index].result![0].zipcode ?? "",
                    ),
                  );
                },
                itemCount: _cdnAddressModelList.length,
              ),
            ),
        ],
      ),
    );
  }

  _saveAddressAndGoToNextPage(String address, num lat, num lon) async {
    await _saveAddressOnSharedPreference(address, lat, lon);

    context.read<PageController>().animateToPage(2,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  _saveAddressOnSharedPreference(String address, num lat, num lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat.toDouble());
    await prefs.setDouble(SHARED_LON, lon.toDouble());
  }
}
