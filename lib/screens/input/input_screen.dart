import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/item_model.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/input/multi_image_select.dart';
import 'package:extended_image/extended_image.dart';
import 'package:tomato_record/states/select_image_notifier.dart';
import '../../repo/image_storage.dart';
import '../../repo/item_service.dart';
import '../../states/category_notifier.dart';
import '../../states/user_notifier.dart';
import '../../utils/logger.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _divider = Divider(
    height: 1,
    thickness: 0.5,
    color: Colors.grey,
    indent: common_padding,
    endIndent: common_padding,
  );

  bool _suggestPriceSelected = false;

  TextEditingController _priceController = TextEditingController();

  final _border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  bool isCreatingItem = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String itemKey =
        ItemModel.generateItemKey(FirebaseAuth.instance.currentUser!.uid);

    logger.d('check');

    List<Uint8List> images = context.read<SelectImageNotifier>().images;

    UserNotifier userNotifier = context.read<UserNotifier>();

    if (userNotifier.userModel == null) return;

    List<String> downloadUrls =
        await ImageStorage.uploadImages(images, itemKey);

    final num? price = num.tryParse(
        _priceController.text.replaceAll(',', "").replaceAll('원', ""));

    ItemModel itemModel = ItemModel(
      itemKey: itemKey,
      userKey: userKey,
      imageDownloadUrls: downloadUrls,
      title: _titleController.text,
      category: context.read<CategoryNotifier>().currentCategoryInEng,
      price: price ?? 0,
      neogotiable: _suggestPriceSelected,
      detail: _detailController.text,
      address: userNotifier.userModel!.address,
      geoFirePoint: userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
    );

    logger.d('upload finished - ${downloadUrls.toString()}');

    await ItemService().createNewItem(itemModel.toJson(), itemKey);

    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              leading: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.black87,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor),
                child: Text(
                  '뒤로',
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor),
                ),
                onPressed: () {
                  context.beamBack();
                },
              ),
              bottom: PreferredSize(
                  preferredSize: Size(_size.width, 2),
                  child: isCreatingItem
                      ? LinearProgressIndicator(
                          minHeight: 2,
                        )
                      : Container()),
              title: Text('중고거래 글쓰기'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black87,
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor),
                  onPressed: attemptCreateItem,
                  child: Text(
                    '완료',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.foregroundColor),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                MultiImageSelect(),
                _divider,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: '글 제목',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: common_padding),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
                _divider,
                ListTile(
                  onTap: (() {
                    context.beamToNamed(
                        '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT');
                  }),
                  dense: true,
                  title: Text(
                      context.watch<CategoryNotifier>().currentCategoryInKor),
                  trailing: Icon(Icons.navigate_next),
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: common_padding),
                        child: TextFormField(
                          controller: _priceController,
                          onChanged: (value) {
                            if (value == '0원') {
                              _priceController.clear();
                            }
                            setState(() {});
                          },
                          inputFormatters: [
                            MoneyInputFormatter(
                              mantissaLength: 0,
                              trailingSymbol: '원',
                            )
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '얼마에 파시겠어요?',
                            icon: ImageIcon(
                              ExtendedAssetImageProvider('assets/imgs/won.png'),
                              size: 18,
                              color: (_priceController.text.isEmpty)
                                  ? Colors.grey[400]
                                  : Colors.black87,
                            ),
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: common_s_padding),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _suggestPriceSelected = !_suggestPriceSelected;
                          });
                        },
                        icon: Icon(
                          _suggestPriceSelected
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: _suggestPriceSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        label: Text(
                          '가격제안 받기',
                          style: TextStyle(
                              color: _suggestPriceSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
                _divider,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: common_padding),
                  child: TextFormField(
                    controller: _detailController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '글 내용 힌트 텍스트입니다.',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
