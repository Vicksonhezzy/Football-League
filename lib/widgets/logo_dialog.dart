import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/authentication_controller.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/club_logo_model.dart';
import 'package:sbc_league/models/util_model.dart';
import 'package:sbc_league/widgets/custom_circular_image.dart';
import 'package:sbc_league/widgets/custom_text_field.dart';

Future<void> selectLogoDialog(Function onTap) async {
  return Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        insetAnimationCurve: Curves.easeInOut,
        insetAnimationDuration: const Duration(milliseconds: 300),
        child: LogoCard(onTap: onTap),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionCurve: Curves.easeInOut,
  );
}

class LogoCard extends StatelessWidget {
  final Function onTap;
  const LogoCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.fetchUtils(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            UtilsModel? _utilsModel;
            if (snapshot.hasData && snapshot.data != null) {
              _utilsModel = snapshot.data!.data() == null
                  ? null
                  : UtilsModel.fromJson(snapshot.data!.data()!);
            }
            return SizedBox(
              height: getVerticalSize(350),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: controller.clubeNameController,
                      hintText: 'Enter team name',
                      margin:
                          getMargin(bottom: 10, top: 20, left: 20, right: 20),
                      validator: (value) => value == null || value.isEmpty
                          ? 'field required'
                          : snapshot.hasData &&
                                  snapshot.data != null &&
                                  _utilsModel != null &&
                                  _utilsModel.listOfTeams.any((element) =>
                                      element.name.toString().toLowerCase() ==
                                      value.toLowerCase())
                              ? 'Name already exist'
                              : null,
                    ),
                    Padding(
                      padding: getPadding(top: 20, bottom: 10),
                      child: const Text(
                        'SELECT TEAM LOGO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: GridView.builder(
                        itemCount: listOfClubLogos.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          ClubLogoModel model = listOfClubLogos[index];
                          return GestureDetector(
                            onTap: () {
                              onTap(model);
                            },
                            child: CustomCircularImage(
                              image: model.logo,
                              selected: snapshot.hasData &&
                                      snapshot.data != null &&
                                      _utilsModel != null
                                  ? _utilsModel.listOfTeams.any(
                                      (element) => element.logo == model.name)
                                  : false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
