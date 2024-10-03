import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
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
  _MyAppViewState createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xff5E6472),  
      end: const Color(0xffB5A5D4),  
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value ?? Colors.transparent,  
                _colorAnimation.value?.withOpacity(0.5) ?? Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Expense Tracker",
            theme: ThemeData(
              fontFamily: 'CustomFont',
              colorScheme: ColorScheme.light(
                surface: _colorAnimation.value ?? Colors.transparent,
                onSurface: const Color(0xff121212),
                primary: const Color(0xff5E6472),
                secondary: const Color(0xffB5A5D4),
                tertiary: const Color(0xff3D405B),
                outline: const Color(0xffb8d8d8),
              ),
            ),
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
                      userRepository: context.read<AuthenticationBloc>().userRepository,
                    ),
                    child: const WelcomeScreen(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
