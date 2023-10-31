import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/widgets/add_season_dialog.dart';
import 'package:sbc_league/widgets/create_fixture_dialog.dart';
import 'package:sbc_league/widgets/custom_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.blueGrey : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            width: getHorizontalSize(100),
            height: getVerticalSize(20),
            padding: ButtonPadding.PaddingAll9,
            margin: getMargin(left: 10),
            text: 'ADD SEASON',
            onTap: () => Get.dialog(const AddSeasonDialog()),
          ),
          CustomButton(
            width: getHorizontalSize(150),
            padding: ButtonPadding.PaddingAll9,
            height: getVerticalSize(20),
            margin: getMargin(right: 10),
            text: 'CREATE FIXTURE',
            onTap: () => Get.dialog(const CreateFixtureDialog()),
          ),
        ],
      ),
    );
  }
}
