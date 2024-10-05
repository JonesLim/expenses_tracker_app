import 'package:expenses_tracker/screens/stats/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      final repository = FirebaseExpenseRepo();
      expenses = await repository.getExpenses();
    } catch (e) {
      print("Error fetching expenses: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Text(
              'Transactions',
              style: TextStyle(
                fontSize: 22.0,
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
            const SizedBox(height: 30.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 700.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : MyChart(expenses),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
