import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/animated_backgroud.dart';
import 'package:expenses_tracker/screens/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expenses_tracker/screens/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expenses_tracker/screens/authentication/views/welcome_screen.dart';
import 'package:expenses_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expenses_tracker/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  Color? _animatedSurfaceColor = const Color(0xffb8d8d8);

  void _updateSurfaceColor(Color? color) {
    setState(() {
      _animatedSurfaceColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        fontFamily: 'CustomFont',
        colorScheme: ColorScheme.light(
          surface: _animatedSurfaceColor ?? const Color(0xffb8d8d8),
          onSurface: const Color(0xff121212),
          primary: const Color(0xff5E6472),
          secondary: const Color(0xffB5A5D4),
          tertiary: const Color(0xff3D405B),
          outline: const Color(0xff596475),
        ),
      ),
      home: Stack(
        children: [
          AnimatedBackground(onColorChanged: _updateSurfaceColor),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return BlocProvider(
                  create: (context) => GetExpensesBloc(FirebaseExpenseRepo())
                    ..add(GetExpenses()),
                  child: const HomeScreen(),
                );
              } else {
                return BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: const WelcomeScreen(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
