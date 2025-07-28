import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../orders/domain/entities/order_entity.dart';

/// رسم بياني خطي لعرض الإيرادات حسب الوقت
///
/// هذا المكون يعرض الإيرادات اليومية بناءً على الطلبات المكتملة
/// يتم تجميع الإيرادات حسب الساعة (0-23) وعرضها في رسم بياني خطي
///
/// الميزات:
/// - عرض الإيرادات حسب الساعة على مدار 24 ساعة
/// - حساب تلقائي للحد الأقصى للإيرادات
/// - عرض تفاصيل الإيرادات عند اللمس
/// - دعم للفترات الزمنية المختلفة (يومي، أسبوعي، شهري)
class RevenueLineChart extends StatelessWidget {
  /// قائمة الطلبات المستخدمة لحساب الإيرادات
  final List<OrderEntity> orders;

  /// الفترة الزمنية للعرض (يومي، أسبوعي، شهري)
  final String timeRange; // 'daily', 'weekly', 'monthly'

  const RevenueLineChart({
    super.key,
    required this.orders,
    this.timeRange = 'daily',
  });

  @override
  Widget build(BuildContext context) {
    final revenueData = _calculateRevenueData();

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
            maxY: _getMaxRevenue(revenueData),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final hour = touchedSpot.x.toInt();
                    final revenue = revenueData[hour] ?? 0.0;
                    return LineTooltipItem(
                      ' \$${revenue.toStringAsFixed(2)}',
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
                  final revenue = revenueData[i] ?? 0.0;
                  return FlSpot(i.toDouble(), revenue);
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
                      Color(0xFFFF7A00).withValues(alpha: 0.2),
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

  /// حساب بيانات الإيرادات حسب الساعة
  ///
  /// يتم تجميع الإيرادات من الطلبات المكتملة فقط
  /// كل طلب يساهم في الإيرادات حسب ساعة إنشائه
  Map<int, double> _calculateRevenueData() {
    final Map<int, double> hourlyRevenue = {};

    // تهيئة الإيرادات لكل ساعة بـ 0
    for (int hour = 0; hour < 24; hour++) {
      hourlyRevenue[hour] = 0.0;
    }

    // حساب الإيرادات من الطلبات المكتملة
    for (final order in orders) {
      if (order.status == 'completed' || order.status == 'done') {
        final orderHour = order.createdAt.hour;
        hourlyRevenue[orderHour] =
            (hourlyRevenue[orderHour] ?? 0.0) + order.price;
      }
    }

    return hourlyRevenue;
  }

  /// حساب الحد الأقصى للإيرادات لتحديد مقياس الرسم البياني
  ///
  /// يتم إضافة هامش 20% فوق الحد الأقصى لتحسين العرض
  double _getMaxRevenue(Map<int, double> revenueData) {
    if (revenueData.isEmpty) return 6.0; // قيمة افتراضية

    final maxRevenue = revenueData.values.reduce((a, b) => a > b ? a : b);
    // إضافة هامش 20% فوق الحد الأقصى
    return maxRevenue * 1.2;
  }
}
