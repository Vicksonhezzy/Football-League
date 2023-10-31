import 'package:flutter/material.dart';
import 'package:sbc_league/core/constants/color_constant.dart';
import 'package:sbc_league/core/utils/size_utils.dart';

class CustomDivider extends StatelessWidget {
  final bool padRight;
  final EdgeInsetsGeometry? margin;
  final double? width;
  const CustomDivider(
      {Key? key, this.padRight = false, this.width, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.dividerColor,
      width: width,
      margin: margin ?? getMargin(top: 8, bottom: 8, right: padRight ? 10 : 0),
      height: 0.5,
    );
  }
}
