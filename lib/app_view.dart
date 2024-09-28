import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expenses_tracker/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        fontFamily: 'CustomFont',
        colorScheme: const ColorScheme.light(
          surface: Color(0xffb8d8d8),
          onSurface: Color(0xff121212),
          primary: Color(0xff5E6472),
          secondary: Color(0xffB5A5D4),
          tertiary: Color(0xff3D405B),
          outline: Color(0xff596475),
        ),
      ),
      home: BlocProvider(
        create: (context) => GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
        child: const HomeScreen(),
      ),
    );
  }
}
