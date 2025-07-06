import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'admin_management.dart';
import 'item_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF423737),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFFEB711),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Space above first title
                const Text(
                  'Order Status Summary (Last 1 Month)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                    height: 30), // ✅ Added more space under 1st topic
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusCard(
                        'Total Orders', '30', const Color(0xFF81630C)),
                    _buildStatusCard('Pending', '10', const Color(0xFF137386)),
                    _buildStatusCard(
                        'Completed', '15', const Color(0xFF168308)),
                    _buildStatusCard('Canceled', '5', const Color(0xFF890303)),
                  ],
                ),
                const SizedBox(height: 40), // ✅ Added more space under card row
                const Text(
                  'Orders Overview (Last 1 Month)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                    height: 40), // ✅ Added more space under 2nd topic
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          height: 250,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                _buildBarGroup(
                                    0, 10, const Color(0xFF137386)), // Pending
                                _buildBarGroup(1, 15,
                                    const Color(0xFF168308)), // Completed
                                _buildBarGroup(
                                    2, 5, const Color(0xFF890303)), // Canceled
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    reservedSize: 28,
                                    getTitlesWidget: (value, meta) => Text(
                                      value.toInt().toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('Pending',
                                              style: TextStyle(
                                                  color: Colors.white));
                                        case 1:
                                          return const Text('Completed',
                                              style: TextStyle(
                                                  color: Colors.white));
                                        case 2:
                                          return const Text('Canceled',
                                              style: TextStyle(
                                                  color: Colors.white));
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white.withOpacity(0.2),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 40,
                              sections: [
                                _buildPieChartSection(
                                    10, const Color(0xFF137386), 'Pending\n10'),
                                _buildPieChartSection(15,
                                    const Color(0xFF168308), 'Completed\n15'),
                                _buildPieChartSection(
                                    5, const Color(0xFF890303), 'Canceled\n5'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminManagementPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEB711),
                    ),
                    child: const Text(
                      'Admin Management',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemManagementPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEB711),
                    ),
                    child: const Text(
                      'Item Management',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(
            horizontal: 8), // Increased spacing between cards
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  PieChartSectionData _buildPieChartSection(
      double value, Color color, String label) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 50,
      title: label,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      titlePositionPercentageOffset: 0.7, // Push label outward from slice
    );
  }
}
