import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:sbc_league/core/generete_fixtures.dart';
import 'package:sbc_league/core/utils/firebase_utils.dart';
import 'package:sbc_league/core/utils/notification_service.dart';
import 'package:sbc_league/core/utils/pref_utils.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/club_logo_model.dart';
import 'package:sbc_league/models/table_model.dart';
import 'package:sbc_league/models/util_model.dart';
import 'package:sbc_league/views/home.dart';
import 'package:sbc_league/widgets/custom_button.dart';
import 'package:sbc_league/widgets/logo_dialog.dart';

class AuthController extends GetxController {
  static AuthController get authInstance => Get.find();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  late ClubLogoModel selectedModel;

  TextEditingController clubeNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late String serialNo;

  @override
  void onReady() {
    super.onReady();
    checkAuth();
  }

  @override
  void onInit() {
    super.onInit();
    getDeviceData();
  }

  getDeviceData() async {
    AndroidDeviceInfo build = (await deviceInfoPlugin.androidInfo);
    serialNo = build.fingerprint;
  }

  checkAuth() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.getToken();
      FlutterNativeSplash.remove();
      final db = await dbUtils.doc('utils000').get();
      if (db.exists) {
        utilsModel = UtilsModel.fromJson(db.data()!);
        if (PrefUtils.getString(resgitered) != null ||
            PrefUtils.getBool(spectator) == true) {
          Get.offAll(Home());
        } else {
          if (utilsModel.users.contains(serialNo)) {
            Get.offAll(Home());
          } else {
            checkCanRegister();
          }
        }
      } else {
        utilsModel = UtilsModel(seasons: [], users: [], listOfTeams: []);
        checkCanRegister();
      }
    } catch (e) {
      checkAuth();
    }
  }

  register() {
    selectLogoDialog(selectLogo);
  }

  selectLogo(ClubLogoModel model) async {
    try {
      if (clubeNameController.text.isEmpty) {
        Get.snackbar('', 'Please enter team name', backgroundColor: Colors.red);
      } else {
        if (formKey.currentState!.validate()) {
          if (utilsModel.listOfTeams
                  .any((element) => element.logo == model.name) ==
              false) {
            selectedModel = model;
            final db = await dbUtils.doc('utils000').get();
            if (db.exists) {
              addUser(model, true);
            } else {
              addUser(model, false);
            }
          } else {
            Get.snackbar('LOGO HAS ALREDAY BEEN CHOOSEN BY ANOTHER PLAYER',
                'Please selected from unhighlited logos',
                backgroundColor: Colors.red);
          }
        }
      }
    } catch (e) {
      Get.snackbar('ERROR',
          'Something went wrong. Please check your internet connection and try again');
    }
  }

  void addUser(ClubLogoModel model, bool exist) async {
    utilsModel.listOfTeams.add(Teams(model.name, clubeNameController.text));
    utilsModel.users.add(serialNo);
    String season =
        utilsModel.seasons.isEmpty ? generateSeason() : utilsModel.seasons.last;
    if (!utilsModel.seasons.contains(season)) {
      utilsModel.seasons.add(season);
    }
    if (exist) {
      await dbUtils.doc('utils000').update(utilsModel.toJson());
    } else {
      await dbUtils.doc('utils000').set(utilsModel.toJson());
    }

    TableModel tableModel = TableModel(
      position: 0,
      club: clubeNameController.text,
      logo: model.name,
      mp: 0,
      w: 0,
      d: 0,
      l: 0,
      pts: 0,
      gf: 0,
      ga: 0,
      gd: 0,
      last5: [],
    );

    NotificationService.subscribeToTopic();

    await dbTable.doc(season).collection('table').add(tableModel.toJson());

    final db = await dbUtils.doc('utils000').get();
    utilsModel = UtilsModel.fromJson(db.data()!);
    update();
    Get.offAll(Home());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchUtils() {
    return dbUtils.doc('utils000').snapshots();
  }

  checkCanRegister() async {
    try {
      String season = utilsModel.seasons.isEmpty
          ? generateSeason()
          : utilsModel.seasons.last;
      final QuerySnapshot<Map<String, dynamic>> fixtures =
          await dbFixtures.doc(season).collection('fixtures').get();

      if (fixtures.size > 0) {
        Get.dialog(
          Dialog(
            child: WillPopScope(
              onWillPop: () async => false,
              child: SizedBox(
                height: getVerticalSize(100),
                child: Column(
                  children: [
                    Padding(
                      padding: getPadding(top: 10),
                      child: const Text(
                        'Sorry, league already started. Please try again next season',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'Join as a spectator',
                      margin: getMargin(bottom: 10, left: 20, right: 20),
                      onTap: () {
                        PrefUtils.setBool(spectator, true);
                        Get.offAll(Home());
                      },
                    ),
                    // CustomButton(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.dialog(
          Dialog(
            child: WillPopScope(
              onWillPop: () async => false,
              child: SizedBox(
                height: getVerticalSize(100),
                child: Column(
                  children: [
                    Padding(
                      padding: getPadding(top: 20),
                      child: const Text(
                        'Join as a spectator?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: getPadding(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                            text: 'NO',
                            width: getHorizontalSize(100),
                            onTap: () async {
                              if (utilsModel.users.contains(serialNo)) {
                                Get.offAll(Home());
                              } else {
                                register();
                              }
                            },
                          ),
                          CustomButton(
                            text: 'Yes',
                            width: getHorizontalSize(100),
                            onTap: () {
                              PrefUtils.setBool(spectator, true);
                              Get.offAll(Home());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('', 'Something went wrong. Try again later');
    }
  }
}
