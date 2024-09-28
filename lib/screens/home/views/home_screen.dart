import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/views/add_expense_screen.dart';
import 'package:expenses_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expenses_tracker/screens/home/views/main_screen.dart';
import 'package:expenses_tracker/screens/stats/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unSelectedItem = Colors.grey;

  // @override
  // void initState() {
  //   selectedItem = Theme.of(context).colorScheme.primary;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
          // appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              backgroundColor: const Color(0xfffbfbf2),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 3,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home,
                        color: index == 0 ? selectedItem : unSelectedItem),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.graph_square_fill,
                        color: index == 1 ? selectedItem : unSelectedItem),
                    label: "Graph"),
              ]),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var newExpense = await Navigator.push(
                context,
                MaterialPageRoute<Expense>(
                  builder: (BuildContext context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => CreateCategoryBloc(
                          FirebaseExpenseRepo(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) =>
                            GetCategoriesBloc(FirebaseExpenseRepo())
                              ..add(GetCategories()),
                      ),
                      BlocProvider(
                        create: (context) => CreateExpenseBloc(
                          FirebaseExpenseRepo(),
                        ),
                      ),
                    ],
                    child: const AddExpenseScreen(),
                  ),
                ),
              );
              if (newExpense != null) {
                setState(() {
                  state.expenses.insert(0, newExpense);
                });
              }
            },
            shape: const CircleBorder(),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  transform: const GradientRotation(pi / 4),
                ),
              ),
              child: const Icon(CupertinoIcons.add),
            ),
          ),

          body: index == 0 ? MainScreen(state.expenses) : const StatScreen(),
        );
      } else {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      }
    });
  }
}
