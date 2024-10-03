import 'dart:ui';
import 'package:expenses_tracker/screens/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expenses_tracker/screens/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expenses_tracker/screens/authentication/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:expenses_tracker/screens/authentication/views/sign_in_screen.dart';
import 'package:expenses_tracker/screens/authentication/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lordicon/lordicon.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late IconController iconController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    iconController = IconController.assets('assets/json/coin.json');
    iconController.addStatusListener((status) {
      if (status == ControllerStatus.ready) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    iconController.dispose(); 
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(20, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      iconController
                          .playFromBeginning(); 
                    },
                    child: SizedBox(
                      height: 500,
                      width: 500,
                      child: IconViewer(
                        controller: iconController, 
                        height: 500,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TabBar(
                            controller: tabController,
                            unselectedLabelColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            labelColor: Theme.of(context).colorScheme.onSurface,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding

                            tabs: const [
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              BlocProvider<SignInBloc>(
                                create: (context) => SignInBloc(
                                    userRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository),
                                child: const SignInScreen(),
                              ),
                              BlocProvider<SignUpBloc>(
                                create: (context) => SignUpBloc(
                                    userRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository),
                                child: const SignUpScreen(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
