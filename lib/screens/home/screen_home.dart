
import 'package:flutter/material.dart';
import 'package:money_management/screens/catagories/screen_catagories.dart';
import 'package:money_management/screens/catagories/widgets/category_add_popup.dart';
import 'package:money_management/screens/charts/screen_charts.dart';
import 'package:money_management/screens/home/widgets/bottom_navigation_bar.dart';
import 'package:money_management/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);
  static ValueNotifier bottomNavigationNotifier = ValueNotifier(0);
  
  final List<Widget> _pages = [
    const ScreenTransaction(),
    const ScreenCatagories(),
    const ScreenChart(),
  ];

  @override
  Widget build(BuildContext context) {
    bool visible = true;
    return Scaffold(
      bottomNavigationBar: const MoneyManagementBottomNavigationBar(),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: bottomNavigationNotifier,
        builder: (ctx, dynamic newValue, _) {
          return Visibility(
            visible: visible,
            child: FloatingActionButton(
              onPressed: (() {
                if (bottomNavigationNotifier.value == 0) {
                  Navigator.of(context).pushNamed('addTransaction');
                } else if(bottomNavigationNotifier.value == 1) {
                  showCategoryAddPopup(context);
                }
              }),
              child: const Icon(
                Icons.add,
              ),
            ),
          );
        }
      ),
      appBar: AppBar(
        title: const Text(
          'Money Management',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: bottomNavigationNotifier,
        builder: (ctx, dynamic newValue, _) {
          if (bottomNavigationNotifier.value == 2) {
              visible = false;
            }else{
              visible = true;
            }
          return _pages[bottomNavigationNotifier.value];
        },
      )),
    );
  }
}
