import 'package:flutter/material.dart';
import 'package:money_management/db/transaction/transaction_db.dart';
import 'package:money_management/screens/charts/widgets/expense_chart.dart';
import 'package:money_management/screens/charts/widgets/income_chart.dart';

class ScreenChart extends StatefulWidget {
  const ScreenChart({Key? key}) : super(key: key);

  @override
  State<ScreenChart> createState() => _ScreenChartState();
}

class _ScreenChartState extends State<ScreenChart> with SingleTickerProviderStateMixin{

  late TabController tabController;
  
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    TransactionDB.instance.refreshUI();
    return Column(
      children: [
        TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
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
              IncomeChart(),
              ExpenseChart(),
            ],
          ),
        ),
      ],
    );
  }
}
