import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/widgets/custom_button.dart';
import 'package:sbc_league/widgets/custom_text_field.dart';

class CreateFixtureDialog extends StatelessWidget {
  const CreateFixtureDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Dialog(
      child: SizedBox(
        height: getVerticalSize(350),
        child: Form(
          key: controller.createFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    hintText: 'Start year',
                    digitsOnly: true,
                    controller: controller.startYearController,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    digitsOnly: true,
                    hintText: 'End year',
                    controller: controller.endYearController,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    hintText: 'Start month',
                    digitsOnly: true,
                    controller: controller.startMonthController,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    hintText: 'End month',
                    digitsOnly: true,
                    controller: controller.endMonthController,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    hintText: 'Start day',
                    controller: controller.startDayController,
                    digitsOnly: true,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                  CustomTextFormField(
                    width: getHorizontalSize(100),
                    hintText: 'End day',
                    digitsOnly: true,
                    controller: controller.endDayController,
                    textInputType: TextInputType.number,
                    margin: getMargin(bottom: 10, top: 20, left: 20, right: 20),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'fied required' : null,
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: 'SUBMIT',
                width: getHorizontalSize(100),
                margin: getMargin(bottom: 10),
                onTap: () => controller.createSeasonFixture(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
