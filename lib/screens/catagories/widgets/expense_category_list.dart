import 'package:flutter/material.dart';
import 'package:money_management/db/category/category_db.dart';
import 'package:money_management/models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListListner,
      builder: (ctx, List<CategoryModel> newList,_){
        return Container(
      padding: EdgeInsets.all(10),
      child: ListView.separated(
        itemCount: newList.length,
        separatorBuilder: (ctx, index) => const SizedBox(
          height: 5,
        ),
        itemBuilder: (ctx, index) {
          final category = newList[index];
          return Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: ListTile(
              title: Text(
                category.name,
              ),
              trailing: IconButton(
                onPressed: () {
                  CategoryDB.instance.deleteCategory(category.id);
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
              tileColor: Colors.grey.shade100,
            ),
          );
        },
      ),
    );
      },
    );
  }
}
