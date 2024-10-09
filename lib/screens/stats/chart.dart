import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';

class MyChart extends StatefulWidget {
  final List<Expense> expenses;

  const MyChart(this.expenses, {super.key});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<double> chartData = [];
  int numberOfDays = 30;
  double maxExpenseValue = 10000;

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _updateChartDataForMonth(selectedDate);

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(
            "Select Month: ${selectedDate.month}/${selectedDate.year}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
               shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                offset: const Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
              Shadow(
                color: Theme.of(context).colorScheme.onSurface,
                offset: const Offset(-1.0, -1.0),
                blurRadius: 0.0,
              ),
            ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 3.0,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return BarChart(
                      mainBarData(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    showMonthPicker(
      context,
      onSelected: (month, year) {
        setState(() {
          selectedDate = DateTime(year, month);
          _updateChartDataForMonth(selectedDate);
        });
      },
      initialSelectedMonth: selectedDate.month,
      initialSelectedYear: selectedDate.year,
      firstYear: 2000,
      lastYear: 2025,
      firstEnabledMonth: 1,
      lastEnabledMonth: 12,
      selectButtonText: 'OK',
      cancelButtonText: 'Cancel',
      highlightColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.outline,
      contentBackgroundColor: Colors.white.withOpacity(0.5),
      dialogBackgroundColor: Colors.grey[200],
    );
  }

  void _updateChartDataForMonth(DateTime date) {
    numberOfDays = DateTime(date.year, date.month + 1, 0).day;
    chartData = getExpensesForMonth(date.year, date.month);

    maxExpenseValue = chartData.isNotEmpty ? chartData.reduce(max) : 100.0;

    if (maxExpenseValue == 0) {
      maxExpenseValue = 100.0;
    }
  }

  List<double> getExpensesForMonth(int year, int month) {
    List<double> dailyTotals = List.filled(numberOfDays, 0.0);

    for (var expense in widget.expenses) {
      DateTime expenseDate = expense.date;
      if (expenseDate.year == year && expenseDate.month == month) {
        int dayIndex = expenseDate.day - 1;
        dailyTotals[dayIndex] += expense.amount;
      }
    }

    return dailyTotals;
  }

  BarChartGroupData makeGroupData(int x, double y) {
    double normalizedY = y / maxExpenseValue * maxExpenseValue;

    if (y == 0) {
      return BarChartGroupData(x: x, barRods: [
        BarChartRodData(
          toY: 0,
          width: 20.0,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxExpenseValue,
            color: Colors.grey[300],
          ),
        ),
      ]);
    }

    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: normalizedY,
        gradient: LinearGradient(
          colors: [
            _colorAnimation.value ?? Colors.green,
            _colorAnimation.value?.withOpacity(0.7) ??
                Colors.red.withOpacity(0.7),
          ],
          transform: const GradientRotation(pi / 40),
        ),
        width: 20.0,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: maxExpenseValue,
          color: Colors.grey[300],
        ),
      ),
    ]);
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(chartData.length, (i) {
      return makeGroupData(i, chartData[i]);
    }).toList();
  }

  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38.0,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38.0,
            getTitlesWidget: getLeftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(
        show: false,
      ),
      barGroups: showingGroups(),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '\$ ${rod.toY.toStringAsFixed(2)}',
              TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff121212),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
    );
    String text = (value.toInt() + 1).toString().padLeft(2, '0');
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16.0,
      child: Text(text, style: style),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff121212),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
    );

    String text;
    if (value == 0) {
      text = '\$ 0';
    } else if (value == maxExpenseValue / 4) {
      text = '\$ ${(maxExpenseValue / 4).toStringAsFixed(0)}';
    } else if (value == maxExpenseValue / 2) {
      text = '\$ ${(maxExpenseValue / 2).toStringAsFixed(0)}';
    } else if (value == (3 * maxExpenseValue) / 4) {
      text = '\$ ${(3 * maxExpenseValue / 4).toStringAsFixed(0)}';
    } else if (value == maxExpenseValue) {
      text = '\$ ${(maxExpenseValue).toStringAsFixed(0)}';
    } else {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1.0,
      child: Text(
        text,
        style: style,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
