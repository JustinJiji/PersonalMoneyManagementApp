import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions{
  Future<void> addTransactions(TransactionModel value); 
  Future<List<TransactionModel>> getTransactions();
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

  
} 