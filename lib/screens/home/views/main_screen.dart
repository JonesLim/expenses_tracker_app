import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  final List<Expense> expenses;
  const MainScreen(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Theme.of(context).colorScheme.outline,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text(
                          "Gabrielle",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.settings)),
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
                      offset: Offset(5.0, 5.0)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const Text(
                    '\$ 6666.00',
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: const BoxDecoration(
                                color: Colors.white54,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.arrow_down,
                                  size: 12.0,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '\$ 666.00',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: const BoxDecoration(
                                color: Colors.white54,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.arrow_up,
                                  size: 12.0,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '\$ 666.00',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Color(expenses[i].category.color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/categories/${expenses[i].category.icon}.gif',
                                        scale: 2.0,
                                        color: Colors.white,
                                      ),

                                      // const Icon(
                                      //   Icons.fastfood,
                                      //   color: Colors.white,
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    expenses[i].category.name,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$${expenses[i].amount}.00",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(expenses[i].date),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
