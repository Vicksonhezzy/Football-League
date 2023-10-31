import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/constants/logos.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/models/table_model.dart';
import 'package:sbc_league/widgets/divider.dart';
import 'package:sbc_league/widgets/last5_widget.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return SizedBox(
      height: size.height / 1.1,
      width: size.width,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.fetchTable(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            Rx<bool> haslast5 = false.obs;
            List<TableModel> table = [];
            if (snapshot.hasData && snapshot.data != null) {
              table = controller.rankLeagueTable(snapshot.data!.docs);
              haslast5.value = table.any((element) => element.last5.isNotEmpty);
            }
            return SingleChildScrollView(
              padding: getPadding(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(left: 40),
                          child: const Text("Club"),
                        ),
                        const CustomDivider(margin: EdgeInsets.zero),
                        Column(
                          children: [
                            // if (snapshot.connectionState ==
                            //         ConnectionState.waiting &&
                            //     snapshot.data == null)
                            //   const Loader(),
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.size > 0)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: table.length,
                                padding: getPadding(top: 10, bottom: 10),
                                itemBuilder: (context, index) {
                                  TableModel model = table[index];
                                  return clubName(model, index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const CustomDivider(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width / 2,
                    child: SingleChildScrollView(
                      controller: controller.tableScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTableHeader(haslast5.value),
                          CustomDivider(
                            width: size.width,
                            margin: EdgeInsets.zero,
                          ),
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.size > 0)
                            SizedBox(
                              width: size.width,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: getPadding(top: 10),
                                itemCount: table.length,
                                itemBuilder: (context, index) {
                                  TableModel model = table[index];
                                  return _buildTableRow(model, haslast5.value);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const CustomDivider(padRight: true),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildTableHeader(bool haslast5) {
    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          expandedheader("MP"),
          expandedheader("W"),
          expandedheader("D"),
          expandedheader("L"),
          expandedheader("Pts", bold: true),
          expandedheader("GF"),
          expandedheader("GA"),
          expandedheader("GD"),
          if (haslast5)
            Container(
              margin: getMargin(left: 15),
              width: getHorizontalSize(90),
              child: const Text(
                'Last 5',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget clubName(TableModel model, int pos) {
    return SizedBox(
      height: getVerticalSize(15),
      child: Row(
        children: [
          expandedChild(pos + 1),
          Expanded(
            flex: 1,
            child: Image.asset(ClubLogos.getLogo(model.logo)),
          ),
          expandedheader(model.club, flex: 3),
        ],
      ),
    );
  }

  Widget _buildTableRow(TableModel model, bool haslast5) {
    return SizedBox(
      width: size.width,
      height: getVerticalSize(15),
      child: Row(
        children: [
          expandedChild(model.mp),
          expandedChild(model.w),
          expandedChild(model.d),
          expandedChild(model.l),
          expandedChild(model.pts, true),
          expandedChild(model.gf),
          expandedChild(model.ga),
          expandedChild(model.gd),
          if (haslast5)
            Container(
              margin: getMargin(left: 15),
              width: getHorizontalSize(90),
              child: Last5Widget(last5: model.last5),
            ),
        ],
      ),
    );
  }

  Widget expandedheader(String text, {int? flex, bool bold = false}) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        margin: getMargin(left: 5, right: 5),
        child: Text(
          text,
          style: TextStyle(fontWeight: bold ? FontWeight.w600 : null),
          textAlign: flex == null ? TextAlign.center : TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget expandedChild(int text, [bool bold = false]) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: getMargin(left: 5, right: 5),
        child: Text(
          text.toString(),
          style: TextStyle(fontWeight: bold ? FontWeight.w600 : null),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
