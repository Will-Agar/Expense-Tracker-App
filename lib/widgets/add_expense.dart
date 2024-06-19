import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense(this.saveExpense, {super.key});

  final void Function(Expense expense) saveExpense;

  @override
  State<StatefulWidget> createState() {
    return _AddExpenseState();
  }
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;

  void _showErrorDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext buildContext) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please ensure you have entered a valid title, amount, date and category.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay!'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext buildContext) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please ensure you have entered a valid title, amount, date and category.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay!'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final title = _titleController.text.trim();
    final titleInvalid = title.isEmpty;
    final amount = double.tryParse(_amountController.text);
    final amountInvalid = amount == null || amount <= 0;
    final dateInvalid = _selectedDate == null;
    final categoryInvalid = _selectedCategory == null;

    if (titleInvalid || amountInvalid || dateInvalid || categoryInvalid) {
      _showErrorDialog();
    } else {
      final expense = Expense(
        title: title,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory!,
      );

      widget.saveExpense(expense);
      Navigator.pop(context);
    }
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _closeModal() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints
            .maxWidth; //use to make media queries dependent on parent constraints

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardSpace + 20),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: 'R ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Row(
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      DropdownButton(
                        hint: const Text('Category'),
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (Category category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _closeModal,
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save expense'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
