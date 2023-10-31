import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/controllers/home_controller.dart';
import 'package:sbc_league/core/utils/size_utils.dart';
import 'package:sbc_league/widgets/app_bar.dart';
import 'package:sbc_league/widgets/fixtures_widget.dart';
import 'package:sbc_league/widgets/table_widget.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  final Rx<int> _index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titleSpacing: 0,
            elevation: 0,
            pinned: true,
            expandedHeight: 50,
            // title: const CustomAppBar(),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Obx(
                () => TabBar(
                  controller: controller.tabController.value,
                  onTap: (value) {
                    _index.value = value;
                  },
                  indicatorColor: Colors.transparent,
                  labelPadding: getPadding(bottom: 10),
                  tabs: [
                    tab('Table', 0),
                    tab('Fixtures', 1),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: size.height / 1.1,
                  child: TabBarView(
                    controller: controller.tabController.value,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      TableWidget(),
                      FixturesWidget(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomAppBar(),
    );
  }

  Widget tab(String text, int index) => Obx(() => Container(
        padding: getPadding(left: 8, right: 8, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: _index.value == index ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ));
}
