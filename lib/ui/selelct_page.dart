import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_game_test/routes/routes/route_names.dart';


class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _games(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        'SelectPage',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _games() {
    return Padding(
      padding: EdgeInsets.only(
        left: 30.w,
        right: 30.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _gameListItem(text: 'Flappy Bird', routeName: RouteNames.game),
        ],
      ),
    );
  }

  Widget _gameListItem({
    required String text,
    required String routeName,
  }) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(routeName);
      },
      child: SizedBox(
        height: 30.h,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
