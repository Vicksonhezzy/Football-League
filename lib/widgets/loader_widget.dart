import 'package:flutter/material.dart';
import 'package:sbc_league/core/utils/size_utils.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
