import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/views/category_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController expenseCotroller = TextEditingController();
  TextEditingController categoryCotroller = TextEditingController();
  TextEditingController dateCotroller = TextEditingController();
  // DateTime selectDate = DateTime.now();
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    dateCotroller.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Add Expenses',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: expenseCotroller,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                FontAwesomeIcons.dollarSign,
                                size: 16.0,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      TextFormField(
                        controller: categoryCotroller,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () {},
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: expense.category == Category.empty
                              ? Colors.white
                              : Color(expense.category.color),
                          prefixIcon: expense.category == Category.empty
                              ? Icon(
                                  FontAwesomeIcons.list,
                                  size: 16.0,
                                  color: Theme.of(context).colorScheme.surface,
                                )
                              : Image.asset(
                                  'assets/categories/${expense.category.icon}.gif',
                                  scale: 2.0,
                                ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              var newCategory =
                                  await getCategoryCreation(context);
                              print(newCategory);
                              setState(() {
                                state.categories.insert(0, newCategory);
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.plus,
                              size: 16.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          // label: Text('Category'),
                          hintText: 'Category',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12.0),
                          ),
                        ),
                        // color: Colors.red,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: state.categories.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, int i) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        expense.category = state.categories[i];
                                        categoryCotroller.text =
                                            expense.category.name;
                                      });
                                    },
                                    leading: Image.asset(
                                      'assets/categories/${state.categories[i].icon}.gif',
                                      scale: 2.0,
                                    ),
                                    title: Text(state.categories[i].name),
                                    tileColor: Color(state.categories[i].color),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                );
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: dateCotroller,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: expense.date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (newDate != null) {
                            setState(() {
                              dateCotroller.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                              // selectDate = newDate;
                              expense.date = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              FontAwesomeIcons.clock,
                              size: 16.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            hintText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    expense.amount =
                                        int.parse(expenseCotroller.text);
                                  });

                                  context
                                      .read<CreateExpenseBloc>()
                                      .add(CreateExpense(expense));
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
