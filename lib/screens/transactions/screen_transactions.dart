import 'package:flutter/material.dart';
import 'package:money_management/db/transaction/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (ctx, List<TransactionModel> newList, _) {
          return Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: TransactionDB().balanceNotifier,
                    builder: (cotx, double balance, _) {
                      return Container(
                        color: Colors.purple,
                        margin:const  EdgeInsets.only(bottom: 15),
                        height: 25,
                        width: MediaQuery.of(ctx).size.width,
                        child: Center(
                          child: Text(
                            "BALANCE : $balance",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                Expanded(
                  child: ListView.separated(
                    itemCount: newList.length,
                    separatorBuilder: (ctx, index) => const SizedBox(
                      height: 5,
                    ),
                    itemBuilder: (ctx, index) {
                      final list = newList[index];
                      return Card(
                        elevation: 5,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          subtitle: Text(list.purpose),
                          title: Text(list.category.name),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return SimpleDialog(
                                  title: const Text(
                                      'Are you sure you want to Delete?'),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text('NO'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            TransactionDB.instance
                                                .deleteTransaction(list.id!);
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text('YES'),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          leading: Card(
                            elevation: 5,
                            color: Colors.purple,
                            child: Padding(
                              child: Text(
                                list.date.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              padding: const EdgeInsets.all(5),
                            ),
                          ),
                          trailing: Text(
                            list.type == CategoryType.income
                                ? '+ ${list.amount}'
                                : '- ${list.amount}',
                            style: TextStyle(
                              color: list.type == CategoryType.income
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          tileColor: Colors.grey.shade100,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
