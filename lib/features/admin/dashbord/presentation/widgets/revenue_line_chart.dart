import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevenueLineChart extends StatelessWidget {
  const RevenueLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 24 * 50.w, // عرض الرسم البياني يغطي 24 ساعة
        height: 139.h,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9B9B9B),
                      fontWeight: FontWeight.bold,
                    );

                    // عشان نمنع التكرار اللي بيحصل حوالين أرقام عشرية زي 3.0 و3.00001
                    if (value % 3 != 0) return const SizedBox.shrink();

                    final hour = value.toInt();
                    final period = hour < 12 ? 'AM' : 'PM';
                    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
                    final formattedHour = displayHour.toString().padLeft(
                      2,
                      '0',
                    );

                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text('$formattedHour $period', style: style),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 23,
            minY: 0,
            maxY: 6,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    return LineTooltipItem(
                      ' \$500',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(24, (i) {
                  // بيانات وهمية متدرجة
                  double y = (i % 6 + 1).toDouble();
                  return FlSpot(i.toDouble(), y);
                }),
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFF7A00)],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 5,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: Color(0xFFFF7A00),
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF7A00).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
