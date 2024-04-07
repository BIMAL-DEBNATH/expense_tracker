import 'package:flutter/material.dart';
import 'package:expense_tracker/Enum/category_enum.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formater = DateFormat.yMd(); //intl
const uuid = Uuid();

const categoryIcon = {
  CategoryEnum.food: Icons.lunch_dining,
  CategoryEnum.travel: Icons.flight_takeoff,
  CategoryEnum.leisure: Icons.movie,
  CategoryEnum.work: Icons.work,
};

class Expens {
  Expens({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final CategoryEnum category;

  String get formatterDate {
    return formater.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expens> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final CategoryEnum category;
  final List<Expens> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
