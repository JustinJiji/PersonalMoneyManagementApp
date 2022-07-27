import 'package:flutter/material.dart';
import 'package:money_management/db/transaction/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:pie_chart/pie_chart.dart';

class IncomeChart extends StatelessWidget {
  const IncomeChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> _incomeMap = {};

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (ctx, List<TransactionModel> _list, _) {
        for (int i = 0; i < _list.length; i++) {
          if (_list[i].category.type == CategoryType.income) {
            _incomeMap.addEntries(
                [MapEntry(_list[i].category.name, _list[i].amount)]);
          }
        }

        return (_incomeMap.isEmpty) ? const SizedBox() : PieChart(
          dataMap: _incomeMap,
          chartRadius: 310,
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValuesOutside: true
          ),
          legendOptions: const LegendOptions(
            legendPosition: LegendPosition.bottom,
          ),
        );
      },
    );
  }
}
