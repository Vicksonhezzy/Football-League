import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/widgets/custom_button.dart';
import 'package:sbc_league/widgets/custom_text_field.dart';

class AddSeasonDialog extends StatelessWidget {
  const AddSeasonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Dialog(
      child: SizedBox(
        height: getVerticalSize(150),
        child: Form(
          key: controller.addSeasonFormKey,
          child: Column(
            children: [
              CustomTextFormField(
                // width: getHorizontalSize(100),
                hintText: 'Season start year',
                controller: controller.seasonStartController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                validator: (value) =>
                    value == null || value.isEmpty ? 'fied required' : null,
              ),
              const Spacer(),
              CustomButton(
                text: 'SUBMIT',
                width: getHorizontalSize(100),
                margin: getMargin(bottom: 10),
                onTap: () => controller.addSeason(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
