import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/constants/color_constant.dart';
import 'package:sbc_league/core/utils/date_time_utils.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/fixture_model.dart';
import 'package:sbc_league/widgets/loader_widget.dart';

class FixturesWidget extends StatelessWidget {
  const FixturesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return SizedBox(
      // height: size.height / 1.2,
      child: SingleChildScrollView(
        padding: getPadding(left: 20, right: 20, top: 10, bottom: 50),
        controller: controller.scrollController,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.fetchFixtures(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              return Column(
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      snapshot.data == null)
                    const Loader(),
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.size > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        FixtureModel model = FixtureModel.fromJson(
                            snapshot.data!.docs[index].data());
                        return InkWell(
                            onTap: () {
                              controller.onTap(
                                  model, snapshot.data!.docs[index].id);
                            },
                            child: fixtureCard(model));
                      },
                    ),
                  if (!snapshot.hasData || !(snapshot.data!.size > 0))
                    const Center(child: Text('No fixtures yet')),
                ],
              );
            }),
      ),
    );
  }

  Widget fixtureCard(FixtureModel model) {
    return Container(
      height: getVerticalSize(80),
      width: double.maxFinite,
      margin: getMargin(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorConstant.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: getPadding(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      text(model.homeClub, getHorizontalSize(150)),
                      const Spacer(),
                      if (model.dateTime.isBefore(DateTime.now()))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: getPadding(right: 8),
                              child: text(model.homeScore.toString()),
                            ),
                            if (model.homeScore > model.awayScore) winIcon(),
                            if ((model.homeScore != model.awayScore &&
                                    model.awayScore > model.homeScore) ||
                                model.homeScore == model.awayScore)
                              winSizedBox()
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: getVerticalSize(10)),
                  Row(
                    children: [
                      text(model.awayClub, getHorizontalSize(150)),
                      const Spacer(),
                      if (model.dateTime.isBefore(DateTime.now()))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: getPadding(right: 8),
                              child: text(model.awayScore.toString()),
                            ),
                            if (model.awayScore > model.homeScore) winIcon(),
                            if ((model.homeScore != model.awayScore &&
                                    model.homeScore > model.awayScore) ||
                                model.homeScore == model.awayScore)
                              winSizedBox()
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(60),
            child: VerticalDivider(width: 1, color: ColorConstant.dividerColor),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (model.played) text('FT'),
                text(model.dateTime.format('dd MMM, yy')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget winIcon() => SizedBox(
        width: getHorizontalSize(12),
        child: const Icon(Icons.arrow_left_rounded),
      );

  Widget winSizedBox() => SizedBox(width: getHorizontalSize(12));

  Widget text(String text, [double? width]) =>
      SizedBox(width: width, child: Text(text, maxLines: 2));
}
