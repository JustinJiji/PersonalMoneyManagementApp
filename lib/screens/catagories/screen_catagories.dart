import 'package:flutter/material.dart';
import 'package:money_management/db/category/category_db.dart';
import 'package:money_management/screens/catagories/widgets/expense_category_list.dart';
import 'package:money_management/screens/catagories/widgets/income_category_list.dart';

class ScreenCatagories extends StatefulWidget {
  const ScreenCatagories({Key? key}) : super(key: key);

  @override
  State<ScreenCatagories> createState() => _ScreenCatagoriesState();
}

class _ScreenCatagoriesState extends State<ScreenCatagories>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: 'Income',
            ),
            Tab(
              text: 'Expense',
            ),
          ],
          controller: tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              IncomeCategoryList(),
              ExpenseCategoryList(),
            ],
          ),
        ),
      ],
    );
  }
}
