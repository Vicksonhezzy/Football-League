import 'package:flutter/material.dart';
import 'package:sbc_league/core/utils/size_utils.dart';

class Last5Widget extends StatelessWidget {
  final List last5;
  const Last5Widget({Key? key, required this.last5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getVerticalSize(15),
      child: ListView.builder(
        itemCount: last5.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int value = last5[index];
          return Container(
            width: getHorizontalSize(15),
            height: getVerticalSize(15),
            margin: getMargin(right: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value == 0
                  ? Colors.red
                  : value == 1
                      ? Colors.grey
                      : Colors.green,
            ),
            child: Center(
              child: Icon(
                value == 0
                    ? Icons.clear
                    : value == 1
                        ? Icons.remove
                        : Icons.check,
                size: getSize(10),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
