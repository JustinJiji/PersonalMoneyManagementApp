import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions{
  Future<void> addTransactions(TransactionModel value); 
  Future<List<TransactionModel>> getTransactions();
  Future<double> getBalance();
  Future<void> refreshUI();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions{

  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB(){
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);
  ValueNotifier<double> balanceNotifier = ValueNotifier(0);

  @override
  Future<void> addTransactions(TransactionModel value) async{
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _transactionDB.put(value.id,value);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _transactionDB.values.toList();
  }

  @override
  Future<void> refreshUI() async{
    final _list = await getTransactions();
    final _balance = await getBalance();
    balanceNotifier.value = _balance;
    balanceNotifier.notifyListeners();
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async{
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDB.delete(id);
    refreshUI();
  }

  @override
  Future<double> getBalance() async {
    double _balance = 0;
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _list = _transactionDB.values.toList();
    for(int i = 0; i < _list.length; i++){
      if(_list[i].type == CategoryType.income) {
        _balance = _balance + _list[i].amount;
      } else {
        _balance = _balance - _list[i].amount;
      }
    }
    return _balance;
  }

  
} 