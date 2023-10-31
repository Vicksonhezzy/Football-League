import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/fixture_model.dart';
import 'package:sbc_league/widgets/custom_button.dart';
import 'package:sbc_league/widgets/custom_text_field.dart';

selectFixtureDialog(String id, FixtureModel model) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetAnimationCurve: Curves.easeInOut,
      insetAnimationDuration: const Duration(milliseconds: 300),
      child: FixtureLogoCard(model: model, id: id),
    ),
    // barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionCurve: Curves.easeInBack,
  );
}

class FixtureLogoCard extends StatelessWidget {
  final String id;
  final FixtureModel model;
  const FixtureLogoCard({Key? key, required this.model, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return IntrinsicHeight(
        child: Container(
          padding: getPadding(left: 20, right: 20, top: 20, bottom: 20),
          // height: getVerticalSize(300),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Padding(
                  padding: getPadding(bottom: 20),
                  child: const Text(
                    'ADD ONLY CURRENT ADDED SCORE FOR EACH TEAM',
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomTextFormField(
                  controller: controller.homeController,
                  textInputType: TextInputType.number,
                  hintText: '${model.homeClub} added score',
                  digitsOnly: true,
                  margin: getMargin(bottom: 10, top: 10),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'field required' : null,
                ),
                CustomTextFormField(
                  controller: controller.awayController,
                  textInputType: TextInputType.number,
                  hintText: '${model.awayClub} added score',
                  digitsOnly: true,
                  margin: getMargin(bottom: 10, top: 10),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'field required' : null,
                ),
                Padding(
                  padding: getPadding(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Match Ended?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Obx(() => Switch(
                            value: controller.ended.value,
                            onChanged: (value) {
                              controller.ended.value = value;
                            },
                          )),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: 'SUBMIT',
                  onTap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.updateRecord(model, id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
