import 'package:flutter/material.dart';
import 'package:sbc_league/core/utils/size_utils.dart';

class CustomCircularImage extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double? size;
  final String image;
  final bool selected;
  const CustomCircularImage(
      {Key? key,
      this.margin,
      required this.image,
      this.size,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? getMargin(all: 8),
      height: getHorizontalSize(size ?? 60),
      width: getHorizontalSize(size ?? 60),
      padding: getPadding(all: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.grey : Colors.transparent,
      ),
      child: ClipOval(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100,
          child: imageString(),
        ),
      ),
    );
  }

  Widget imageString() {
    if (image.endsWith('png')) {
      return Image.asset(
        image,
        fit: BoxFit.contain,
        height: 100,
        width: 100,
      );
    } else {
      return Image.network(
        image,
        fit: BoxFit.fill,
        height: 100,
        width: 100,
      );
    }
  }
}
