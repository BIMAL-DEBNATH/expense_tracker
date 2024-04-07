import 'package:expense_tracker/Enum/category_enum.dart';
import 'package:expense_tracker/Model/expens.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_List/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expens> _registeredExpenses = [
    Expens(
        title: 'flutter course',
        amount: 19.99,
        date: DateTime.now(),
        category: CategoryEnum.work),
    Expens(
        title: 'cinema',
        amount: 15.00,
        date: DateTime.now(),
        category: CategoryEnum.leisure)
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, //for camera
      isScrollControlled: true,
      context: context,
      builder: (ctn) => NewExpense(
        addNewExpese: _addExpenses,
      ),
    );
  }

  void _addExpenses(Expens expens) {
    setState(() {
      _registeredExpenses.add(expens);
    });
  }

  void _expenseRemove(Expens expens) {
    final removeIndex = _registeredExpenses.indexOf(expens);
    setState(() {
      _registeredExpenses.remove(expens);
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); //undo remove imediatlly before other one
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deteted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                _registeredExpenses.insert(removeIndex, expens);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContains = const Center(
      child: Text('No Expenses found, try to add some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContains = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _expenseRemove,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpeseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  //for column under column
                  child: mainContains,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ), //row behevior to take as much as space it and child(chart) infinity also same thing so there is conflict.
                Expanded(
                  //for column under column
                  child: mainContains,
                )
              ],
            ),
    );
  }
}
