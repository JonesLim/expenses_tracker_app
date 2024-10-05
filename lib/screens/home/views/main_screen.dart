import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;

  const MainScreen(this.expenses, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _sortState = 0; // 0: default, 1: highest to lowest, 2: lowest to highest, 3: date
  List<Expense> _sortedExpenses = [];

  @override
  void initState() {
    super.initState();
    // Sort by date in descending order by default
    _sortedExpenses = List.from(widget.expenses)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void _sortExpenses() {
    setState(() {
      if (_sortState == 0) {
        _sortedExpenses.sort((a, b) => b.amount.compareTo(a.amount));
        _sortState = 1; // Highest to lowest amount
      } else if (_sortState == 1) {
        _sortedExpenses.sort((a, b) => a.amount.compareTo(b.amount));
        _sortState = 2; // Lowest to highest amount
      } else if (_sortState == 2) {
        // Sort by date (newest to oldest)
        _sortedExpenses.sort((a, b) => b.date.compareTo(a.date));
        _sortState = 3; // Sort by date
      } else {
        // Reset to default state
        _sortedExpenses = List.from(widget.expenses)
          ..sort((a, b) => b.date.compareTo(a.date));
        _sortState = 0; // Default state
      }
    });
  }

  IconData _getSortIcon() {
    if (_sortState == 1) {
      return CupertinoIcons.arrow_up;
    } else if (_sortState == 2) {
      return CupertinoIcons.arrow_down;
    } 
    return CupertinoIcons.arrow_up_down;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        _sortedExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Stack(
                        alignment: Alignment.center,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.7),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                                Shadow(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  offset: Offset(-1.0, -1.0),
                                  blurRadius: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.settings),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Color(0xffd0cdd7),
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                          ),
                          Shadow(
                            color: Theme.of(context).colorScheme.onSurface,
                            offset: Offset(-1.0, -1.0),
                            blurRadius: 0.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      '\$ ${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                          ),
                          Shadow(
                            color: Theme.of(context).colorScheme.onSurface,
                            offset: Offset(-1.0, -1.0),
                            blurRadius: 0.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _sortExpenses,
                        child: Row(
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                  ),
                                  Shadow(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    offset: Offset(-1.0, -1.0),
                                    blurRadius: 0.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _sortExpenses, // Make icon clickable
                    child: Icon(_getSortIcon(), color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                itemCount: _sortedExpenses.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        color: Color(
                                            _sortedExpenses[i].category.color),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/categories/${_sortedExpenses[i].category.icon}.gif',
                                      scale: 7.0,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  _sortedExpenses[i].category.name,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${_sortedExpenses[i].amount}.00",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(_sortedExpenses[i].date),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color:
                                        Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
