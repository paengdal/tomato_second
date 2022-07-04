import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/common_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery.of(context).size;
        final sizeOfPosImg = size.width * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: common_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '토마토마켓',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Stack(
                  children: [
                    ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                    Positioned(
                      left: (size.width - 32) * 0.45,
                      top: (size.width - 32) * 0.45,
                      width: sizeOfPosImg,
                      height: sizeOfPosImg,
                      child: ExtendedImage.asset(
                        'assets/imgs/carrot_intro_pos.png',
                      ),
                    ),
                  ],
                ),
                Text(
                  '우리 동네 중고 직거래 토마토마켓',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '토마토마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        context.read<PageController>().animateToPage(1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        logger.d('on text button clicked!!');
                      },
                      child: Text(
                        '내 동네 설정하고 시작하기',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
