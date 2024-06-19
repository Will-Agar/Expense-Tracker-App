import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(this.expenses, this.removeExpense, {super.key});

  final List<Expense> expenses;
  final void Function(int index) removeExpense;

  Widget buildExpenseWidget(BuildContext context, int index) {
    return Dismissible(
      key: ValueKey(expenses[index]),
      onDismissed: (DismissDirection dismiss) {
        removeExpense(index);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error.withOpacity(0.5),
        margin: EdgeInsets.symmetric(
          horizontal: Theme.of(context).cardTheme.margin!.horizontal,
        ),
      ),
      child: ExpenseItem(expenses[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => buildExpenseWidget(context, index),
    );
  }
}
