import 'package:flutter/material.dart';
import 'package:money_management/screens/home/screen_home.dart';

class MoneyManagementBottomNavigationBar extends StatelessWidget {
  const MoneyManagementBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScreenHome.bottomNavigationNotifier,
        builder: (ctx, dynamic updatedValue, _) {
          return BottomNavigationBar(
            currentIndex: updatedValue,
            onTap: (newValue) =>
                ScreenHome.bottomNavigationNotifier.value = newValue,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.pie_chart,
                ),
                label: 'Chart',
              ),
            ],
          );
        });
  }
}
