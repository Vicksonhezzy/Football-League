import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/authentication_controller.dart';
import 'package:sbc_league/core/generete_fixtures.dart';
import 'package:sbc_league/core/utils/date_time_utils.dart';
import 'package:sbc_league/core/utils/firebase_utils.dart';
import 'package:sbc_league/core/utils/notification_service.dart';
import 'package:sbc_league/core/utils/pref_utils.dart';
import 'package:sbc_league/core/utils/progress_dialog_utils.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/fixture_model.dart';
import 'package:sbc_league/models/table_model.dart';
import 'package:sbc_league/models/util_model.dart';
import 'package:sbc_league/widgets/custom_button.dart';
import 'package:sbc_league/widgets/custom_fixtures_dialog.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late Rx<TabController> tabController;

  TextEditingController startYearController = TextEditingController();
  TextEditingController endYearController = TextEditingController();
  TextEditingController startDayController = TextEditingController();
  TextEditingController endDayController = TextEditingController();
  TextEditingController startMonthController = TextEditingController();
  TextEditingController endMonthController = TextEditingController();

  TextEditingController seasonStartController = TextEditingController();

  ScrollController tableScrollController = ScrollController();

  ScrollController scrollController = ScrollController();

  List<FixtureModel> fixtures = [];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this).obs;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToCondition();
    });
  }

  void jumpToCondition() {
    for (int i = 0; i < fixtures.length; i++) {
      if (fixtures[i].played == false) {
        scrollController.jumpTo(i * getVerticalSize(15));
        break;
      }
    }
  }

  TextEditingController homeController = TextEditingController();

  TextEditingController awayController = TextEditingController();

  Rx<bool> ended = false.obs;

  final formKey = GlobalKey<FormState>();

  onTap(FixtureModel model, String id) {
    if (!model.played) {
      if (DateTime.now().isAfter(model.dateTime)) {
        selectFixtureDialog(id, model);
      } else {
        sendNotificaton(model, id);
      }
      ended.value = false;
    }
  }

  updateRecord(FixtureModel model, String id) async {
    try {
      showProgressDialog();
      model.homeScore = model.homeScore + int.parse(homeController.text);
      model.awayScore = model.awayScore + int.parse(awayController.text);
      model.played = ended.value;
      await dbFixtures
          .doc(utilsModel.seasons.last)
          .collection('fixtures')
          .doc(id)
          .update(model.toJson());

      final dbFixture = await dbFixtures
          .doc(utilsModel.seasons.last)
          .collection('fixtures')
          .doc(id)
          .get();

      final FixtureModel fixData = FixtureModel.fromJson(dbFixture.data()!);

      final home = await dbTable
          .doc(utilsModel.seasons.last)
          .collection('table')
          .where('club', isEqualTo: model.homeClub)
          .limit(1)
          .get();
      TableModel homeData = TableModel.fromJson(home.docs.first.data());
      final int? homeLastU =
          PrefUtils.getInt('$id-${home.docs.first.id}last-update');

      bool homePref = PrefUtils.find(id);

      final away = await dbTable
          .doc(utilsModel.seasons.last)
          .collection('table')
          .where('club', isEqualTo: model.awayClub)
          .limit(1)
          .get();
      TableModel awayData = TableModel.fromJson(away.docs.first.data());
      final int? awayLastU =
          PrefUtils.getInt('$id-${away.docs.first.id}last-update');

      bool awayPref = PrefUtils.find(id);

      // home record
      homeData.mp = !homePref ? homeData.mp + 1 : homeData.mp;
      homeData.gf = homeData.gf + int.parse(homeController.text);
      homeData.ga = homeData.ga + int.parse(awayController.text);

      // away record
      awayData.mp = !awayPref ? awayData.mp + 1 : awayData.mp;
      awayData.gf = awayData.gf + int.parse(awayController.text);
      awayData.ga = awayData.ga + int.parse(homeController.text);

      // draw
      if (fixData.homeScore == fixData.awayScore) {
        print('--------DRAW--------');
        // home
        if (!homePref && homeData.last5.length == 5) {
          homeData.last5.removeAt(0);
        }
        if (homePref && homeData.last5.isNotEmpty) {
          homeData.last5.removeLast();
        }
        homeData.last5.add(1);

        // away
        if (!awayPref && awayData.last5.length == 5) {
          awayData.last5.removeAt(0);
        }
        if (awayPref && awayData.last5.isNotEmpty) {
          awayData.last5.removeLast();
        }
        awayData.last5.add(1);

        if (homeLastU != 1 || !homePref) {
          homeData.d = homeData.d + 1;
        }
        if (homeLastU == 2) {
          homeData.w = homeData.w - 1;
        }
        if (homeLastU == 0) {
          homeData.l = homeData.l - 1;
        }

        homeData.pts = !homePref
            ? homeData.pts + 1
            : homeLastU != null && homeLastU != 1
                ? homeLastU == 2
                    ? homeData.pts - 2
                    : homeData.pts + 1
                : homeData.pts;
        homeData.gd = homeData.gf - homeData.ga;

        print('homeData = $homeData');

        if (!awayPref || awayLastU != 1) {
          awayData.d = awayData.d + 1;
        }

        if (awayLastU != null && awayLastU == 2) {
          awayData.w = awayData.w - 1;
        }

        if (awayLastU != null && awayLastU == 0) {
          awayData.l = awayData.l - 1;
        }

        awayData.pts = !awayPref
            ? awayData.pts + 1
            : awayLastU != null && awayLastU != 1
                ? awayLastU == 2
                    ? awayData.pts - 2
                    : awayData.pts + 1
                : awayData.pts;
        awayData.gd = awayData.gf - awayData.ga;

        print('awayData = $awayData');

        if (!ended.value) {
          PrefUtils.setInt('$id-${home.docs.first.id}last-update', 1);
          PrefUtils.setInt('$id-${away.docs.first.id}last-update', 1);
        }

        // home win
      } else if (fixData.homeScore > fixData.awayScore) {
        print('------HOME WIN------');
        // home
        if (!homePref && homeData.last5.length == 5) {
          homeData.last5.removeAt(0);
        }
        if (homePref && homeData.last5.isNotEmpty) {
          homeData.last5.removeLast();
        }
        homeData.last5.add(2);

        // away
        if (!awayPref && awayData.last5.length == 5) {
          awayData.last5.removeAt(0);
        }
        if (awayPref && awayData.last5.isNotEmpty) {
          awayData.last5.removeLast();
        }
        awayData.last5.add(0);

        if (!homePref || homeLastU != 2) {
          homeData.w = homeData.w + 1;
        }
        if (homeLastU == 1) {
          homeData.d = homeData.d - 1;
        }
        if (homeLastU == 0) {
          homeData.l = homeData.l - 1;
        }

        homeData.pts = !homePref
            ? homeData.pts + 3
            : homeLastU != null && homeLastU != 2
                ? homeLastU == 1
                    ? homeData.pts + 2
                    : homeData.pts + 3
                : homeData.pts;
        homeData.gd = homeData.gf - homeData.ga;

        if (!awayPref || awayLastU != 0) {
          awayData.l = awayData.l + 1;
        }
        if (awayLastU == 1) {
          awayData.d = awayData.d - 1;
        }
        if (awayLastU == 2) {
          awayData.w = awayData.w - 1;
        }

        if (awayLastU == 2) {
          awayData.pts = awayData.pts - 3;
        }
        if (awayLastU == 1) {
          awayData.pts = awayData.pts - 1;
        }

        awayData.gd = awayData.gf - awayData.ga;

        if (!ended.value) {
          PrefUtils.setInt('$id-${home.docs.first.id}last-update', 2);
          PrefUtils.setInt('$id-${away.docs.first.id}last-update', 0);
        }

        // away win
      } else {
        // home
        print('-----AWAY WIN------');
        print('homeData != ${homeData.toJson()}');
        print('awayData != ${awayData.toJson()}');
        if (!homePref && homeData.last5.length == 5) {
          homeData.last5.removeAt(0);
        }
        if (homePref && homeData.last5.isNotEmpty) {
          homeData.last5.removeLast();
        }
        homeData.last5.add(0);

        // away
        if (!awayPref && awayData.last5.length == 5) {
          awayData.last5.removeAt(0);
        }
        if (awayPref && awayData.last5.isNotEmpty) {
          awayData.last5.removeLast();
        }
        awayData.last5.add(2);

        if (homeLastU == 2) {
          homeData.pts = homeData.pts - 3;
        }
        if (homeLastU == 1) {
          homeData.pts = homeData.pts - 1;
        }

        if (!homePref || homeLastU != 0) {
          homeData.l = homeData.l + 1;
        }
        if (homeLastU == 1) {
          homeData.d = homeData.d - 1;
        }
        if (homeLastU == 2) {
          homeData.w = homeData.w - 1;
        }

        homeData.gd = homeData.gf - homeData.ga;

        if (!awayPref || awayLastU != 2) {
          awayData.w = awayData.w + 1;
        }
        if (awayLastU == 1) {
          awayData.d = awayData.d - 1;
        }
        if (awayLastU == 0) {
          awayData.l = awayData.l - 1;
        }

        awayData.pts = !awayPref
            ? awayData.pts + 3
            : awayLastU != null && awayLastU != 2
                ? awayLastU == 1
                    ? awayData.pts + 2
                    : awayData.pts + 3
                : awayData.pts;
        awayData.gd = awayData.gf - awayData.ga;
        if (!ended.value) {
          PrefUtils.setInt('$id-${home.docs.first.id}last-update', 0);
          PrefUtils.setInt('$id-${away.docs.first.id}last-update', 2);
        }
      }
      if (!ended.value) {
        PrefUtils.setString(id, json.encode(awayData.toJson()));
        PrefUtils.setString(id, json.encode(homeData.toJson()));
      } else {
        PrefUtils.remove(id);
        PrefUtils.remove(id);
        PrefUtils.remove('$id-${home.docs.first.id}last-update');
        PrefUtils.remove('$id-${away.docs.first.id}last-update');
      }
      // update home record
      await dbTable
          .doc(utilsModel.seasons.last)
          .collection('table')
          .doc(home.docs.first.id)
          .update(homeData.toJson());

      // update away record
      await dbTable
          .doc(utilsModel.seasons.last)
          .collection('table')
          .doc(away.docs.first.id)
          .update(awayData.toJson());
      update();
      homeController.clear();
      awayController.clear();
      pop(2);
      NotificationService.sendNotification(
        title: '${model.homeClub} Vs ${model.awayClub}',
        body: '${fixData.homeScore} - ${fixData.awayScore}',
        data: {'id': id},
      );
    } catch (e) {
      print('error = ${e.toString()}');
      pop();
      Get.snackbar('ERROR',
          'An error occurred. Check your internet connection and try again',
          backgroundColor: Colors.red);
    }
  }

  sendNotificaton(FixtureModel model, String id) {
    Get.dialog(Dialog(
      child: Container(
        height: getVerticalSize(120),
        padding: getPadding(top: 20, bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            const Text(
              'Are you sure you want to send a match day notification to all users?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  width: getHorizontalSize(100),
                  text: 'NO',
                  onTap: () => Get.back(),
                ),
                CustomButton(
                  width: getHorizontalSize(100),
                  text: 'YES',
                  onTap: () {
                    showProgressDialog();
                    try {
                      NotificationService.sendNotification(
                        title: 'Match Day',
                        body:
                            '${model.homeClub} Vs ${model.awayClub}    - ${model.dateTime.format('dd MMM yyy')}',
                        data: {'id': id},
                      );
                      pop(2);
                      Get.snackbar('SUCCESSFUL', 'Notification sent',
                          backgroundColor: Colors.green);
                    } catch (e) {
                      pop();
                      Get.snackbar(
                          'ERROR', 'Somthing went wrong. Try again later',
                          backgroundColor: Colors.red);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFixtures() {
    return dbFixtures
        .doc(utilsModel.seasons.last)
        .collection('fixtures')
        .orderBy('dateTime')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchTable() {
    return dbTable.doc(utilsModel.seasons.last).collection('table').snapshots();
  }

  List<TableModel> rankLeagueTable(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> teams) {
    // Sort the teams based on points and goal difference
    List<TableModel> list =
        teams.map((e) => TableModel.fromJson(e.data())).toList();
    list.sort((a, b) {
      if (a.pts != b.pts) {
        // Sort by points (descending)
        return b.pts - a.pts;
      } else if (a.pts == b.pts) {
        // Sort by goal difference (descending)
        if (a.gd != b.gd) {
          return b.gd - a.gd;
        }
        if (a.gf != b.gf) {
          return b.gf - a.gf;
        }
      }
      return a.club.toLowerCase().compareTo(b.club.toLowerCase());
    });

    return list;
  }

  final createFormKey = GlobalKey<FormState>();
  final addSeasonFormKey = GlobalKey<FormState>();

  createSeasonFixture() async {
    if (createFormKey.currentState!.validate()) {
      try {
        showProgressDialog();
        final db = await dbUtils.doc('utils000').get();
        if (db.exists) {
          utilsModel = UtilsModel.fromJson(db.data()!);
        }
        final currentSeason = await dbFixtures
            .doc(utilsModel.seasons.last)
            .collection('fixtures')
            .get();

        if (currentSeason.size > 0) {
          seasonStartController.text =
              (int.parse(utilsModel.seasons.last.toString().substring(0, 4)) +
                      1)
                  .toString();
          addSeason(false);
        }

        List<FixtureModel> generatedFixtures = await generateFixtures(
          startYear: int.parse(startYearController.text),
          startMonth: int.parse(startMonthController.text),
          startDay: int.parse(startDayController.text),
          endyear: int.parse(endYearController.text),
          endMonth: int.parse(endMonthController.text),
          endDay: int.parse(endDayController.text),
        );

        for (var element in generatedFixtures) {
          await dbFixtures
              .doc(utilsModel.seasons.last)
              .collection('fixtures')
              .add(element.toJson());
        }
        pop(2);
      } catch (e) {
        print(e.toString());
        pop();
        Get.snackbar('ERROR', 'Something went wrong');
      }
    }
  }

  final AuthController authController = AuthController.authInstance;

  addSeason([bool canPop = true]) async {
    if ((addSeasonFormKey.currentState?.validate() ?? true)) {
      try {
        if (canPop) showProgressDialog();
        String season =
            generateSeason(DateTime(int.parse(seasonStartController.text)));
        if (!utilsModel.seasons.contains(season)) {
          utilsModel.seasons.add(season);
        }
        await dbUtils.doc('utils000').update(utilsModel.toJson());
        for (var element in utilsModel.listOfTeams) {
          TableModel tableModel = TableModel(
            position: 0,
            club: element.name,
            logo: element.logo,
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
          await dbTable
              .doc(season)
              .collection('table')
              .add(tableModel.toJson());
        }
        seasonStartController.clear();

        if (canPop) pop(2);
      } catch (e) {
        if (canPop) pop();
        Get.snackbar('ERROR', 'Something went wrong');
      }
    }
  }
}
