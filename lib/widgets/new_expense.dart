import 'package:expense_tracker/Enum/category_enum.dart';
import 'package:expense_tracker/Model/expens.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addNewExpese});
  final void Function(Expens expens) addNewExpese;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  /* var _enterTitle = '';
  void _saveTitleInput(String inputValue) {
    _enterTitle = inputValue;
  }*/

  final _titleController = TextEditingController(); //this create obj
  final _amountController = TextEditingController();
  @override
  void dispose() {
    //this is like garbag collection
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  DateTime? _selectedDate;
  CategoryEnum _selectedCategory = CategoryEnum.leisure;

  void _submitExpenseData() {
    final amount = double.tryParse(_amountController.text);
    final amountIsInvalid = amount == null || amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input!'),
          content: const Text(
              'Make sure you enter correct Title, Amount, Date and Category...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okey'),
            )
          ],
        ),
      );
      return;
    }
    widget.addNewExpese(Expens(
        title: _titleController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      //this is Future dataType
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
       height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, keyboardSpace + 16), //16, 48, 16, keyboardSpace + 16
          child: Column(
            children: [
              TextField(
                //onChanged: _titleController,
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    // for take space as get not holl
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  Expanded(
                    //for row under row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formater.format(_selectedDate!),
                        ), // ! forsay not null
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: CategoryEnum.values
                        .map(
                          (caterory) => DropdownMenuItem(
                            value: caterory,
                            child: Text(caterory.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      // it need fun as input
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: const Text('Expense saved'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
