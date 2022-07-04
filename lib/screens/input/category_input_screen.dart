import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/states/category_notifier.dart';
import 'package:provider/provider.dart';

class CategoryInputScreen extends StatelessWidget {
  const CategoryInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 선택'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: (categoriesMapEngToKor.values.elementAt(index) ==
                      context.read<CategoryNotifier>().currentCategoryInKor)
                  ? Colors.grey[300]
                  : Colors.transparent,
              title: Text(
                categoriesMapEngToKor.values.elementAt(index),
              ),
              onTap: () {
                context.read<CategoryNotifier>().setNewCategoryWithKor(
                    categoriesMapEngToKor.values.elementAt(index));
                Beamer.of(context).beamBack();
              },
            );
            // Map의 values를 추출하면 Iterable이기때문에 elementAt 사용
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            );
          },
          itemCount: categoriesMapEngToKor.length),
    );
  }
}
