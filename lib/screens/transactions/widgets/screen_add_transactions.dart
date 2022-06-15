import 'package:flutter/material.dart';
import 'package:money_management/db/category/category_db.dart';
import 'package:money_management/db/transaction/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

class ScreenAddTransactiions extends StatefulWidget {
  const ScreenAddTransactiions({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransactiions> createState() => _ScreenAddTransactiionsState();
}

class _ScreenAddTransactiionsState extends State<ScreenAddTransactiions> {
  DateTime? _selectedDate;
  CategoryType _categoryType = CategoryType.income;
  Object? _categories;
  CategoryModel? _selectedCategory;
  var date;
  String? parsedDate;
  ValueNotifier<List<CategoryModel>> _list =
      CategoryDB.instance.incomeCategoryListListner;
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _purposeController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Purpose',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = selectedDate;
                      date = DateTime.parse(_selectedDate.toString());
                      parsedDate = "${date.day}-${date.month}-${date.year}";
                    });
                  }
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                ),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : parsedDate!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _categoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _categoryType = newValue!;
                            _categories = null;
                            _list =
                                CategoryDB.instance.incomeCategoryListListner;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _categoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _categoryType = newValue!;
                            _categories = null;
                            _list =
                                CategoryDB.instance.expenseCategoryListListner;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton(
                hint: const Text('Categories'),
                value: _categories,
                items: _list.value.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.id,
                    onTap: () {
                      _selectedCategory = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categories = selectedValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (parsedDate == null) {
      return;
    }
    if (_selectedCategory == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: parsedDate!,
      type: _categoryType,
      category: _selectedCategory!,
    );

    TransactionDB.instance.addTransactions(_model);
    TransactionDB.instance.refreshUI();
    Navigator.of(context).pop();
  }
}
