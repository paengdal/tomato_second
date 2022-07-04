import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/item_model.dart';

import '../../repo/item_service.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;
  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
      future: ItemService().getItem(widget.itemKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ItemModel itemModel = snapshot.data!;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Size _size = MediaQuery.of(context).size;
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: _size.width,
                      flexibleSpace: FlexibleSpaceBar(
                        title: SmoothPageIndicator(
                            controller: _pageController, // PageController
                            count: itemModel.imageDownloadUrls.length,
                            effect: WormEffect(
                                activeDotColor: Theme.of(context).primaryColor,
                                dotColor:
                                    Theme.of(context).colorScheme.background,
                                radius: 4,
                                dotHeight: 8,
                                dotWidth: 8), // your preferred effect
                            onDotClicked: (index) {}),
                        background: PageView.builder(
                          controller: _pageController,
                          allowImplicitScrolling: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ExtendedImage.network(
                              itemModel.imageDownloadUrls[index],
                              fit: BoxFit.cover,
                              scale: 0.1,
                            );
                          },
                          itemCount: itemModel.imageDownloadUrls.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: _size.height * 2,
                        color: Colors.cyan,
                        child:
                            Center(child: Text('item key is${widget.itemKey}')),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
