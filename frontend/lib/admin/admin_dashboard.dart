import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_management.dart';
import 'item_management.dart';
import 'order_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // UI Configuration
  static const Color backgroundColor = Color(0xFFE2EEED);
  // static const Color primaryColor = Color.fromARGB(255, 174, 156, 115);
  static const Color totalOrdersColor = Color(0xFF5C6BC0); //Color(0xFF82BA53);
  static const Color pendingColor = Color(0xFFFFD54F); //Color(0xFF6CA9A3);
  static const Color completedColor = Color(0xFF81C784); //Color(0xFFFFDB58);
  static const Color failedColor = Color(0xFFE57373); //Color(0xFFD94D4D);
  static const Color textColor = Colors.black;
  static const Color loadingColor = Color.fromARGB(255, 83, 71, 42);
  static const Color errorColor = Colors.red;
  static const Color noDataColor = Colors.grey;

  // Data fields mapping
  static const String totalOrdersField = 'totalOrders';
  static const String pendingOrdersField = 'pendingOrders';
  static const String successfulOrdersField = 'successfulOrders';
  static const String failedOrdersField = 'failedOrders';
  static const String pendingPercentageField = 'pending';
  static const String successfulPercentageField = 'successful';
  static const String failedPercentageField = 'failed';

  // UI Text
  static const String dashboardTitle = 'Admin Dashboard';
  static const String orderSummaryTitle = 'Order Status Summary (Last 1 Month)';
  static const String orderOverviewTitle = 'Orders Overview (Last 1 Month)';
  static const String totalOrdersLabel = 'Total Orders';
  static const String pendingLabel = 'Pending';
  static const String completedLabel = 'Completed';
  static const String failedLabel = 'Failed';
  static const String adminManagementLabel = 'Admin Management';
  static const String itemManagementLabel = 'Item Management';
  static const String orderManagementLabel = 'Order Management';
  static const String retryLabel = 'Retry';
  static const String noDataLabel = 'No Data';
  static const String loadingFailedMessage = 'Failed to load order data';

  // State variables
  Map<String, dynamic> orderStats = {};
  Map<String, dynamic> orderPercentages = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  // API Configuration
  static const String baseUrl = 'https://sip-fresh-backend-new.vercel.app/api';
  static const String statisticsEndpoint = '/order/admin/statistics';
  static const String percentagesEndpoint =
      '/order/admin/order-status-percentages';

  Future<void> fetchOrderData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Fetch order statistics
      final statsResponse = await http.get(
        Uri.parse('$baseUrl$statisticsEndpoint'),
      );

      // Fetch order percentages
      final percentageResponse = await http.get(
        Uri.parse('$baseUrl$percentagesEndpoint'),
      );

      if (statsResponse.statusCode == 200 &&
          percentageResponse.statusCode == 200) {
        setState(() {
          orderStats = json.decode(statsResponse.body);
          orderPercentages = json.decode(percentageResponse.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = loadingFailedMessage;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(dashboardTitle),
        backgroundColor: const Color.fromARGB(255, 174, 156, 115),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchOrderData,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
              ),
            )
          else if (errorMessage.isNotEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: const TextStyle(color: errorColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchOrderData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 156, 115),
                    ),
                    child: const Text(retryLabel,
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    orderSummaryTitle,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusCard(
                          totalOrdersLabel,
                          orderStats[totalOrdersField]?.toString() ?? '0',
                          totalOrdersColor),
                      _buildStatusCard(
                          pendingLabel,
                          orderStats[pendingOrdersField]?.toString() ?? '0',
                          pendingColor),
                      _buildStatusCard(
                          completedLabel,
                          orderStats[successfulOrdersField]?.toString() ?? '0',
                          completedColor),
                      _buildStatusCard(
                          failedLabel,
                          orderStats[failedOrdersField]?.toString() ?? '0',
                          failedColor),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    orderOverviewTitle,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(height: 40),
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
                                      0,
                                      (orderStats[pendingOrdersField] ?? 0)
                                          .toDouble(),
                                      pendingColor),
                                  _buildBarGroup(
                                      1,
                                      (orderStats[successfulOrdersField] ?? 0)
                                          .toDouble(),
                                      completedColor),
                                  _buildBarGroup(
                                      2,
                                      (orderStats[failedOrdersField] ?? 0)
                                          .toDouble(),
                                      failedColor),
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
                                            const TextStyle(color: textColor),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return const Text(pendingLabel,
                                                style: TextStyle(
                                                    color: textColor));
                                          case 1:
                                            return const Text(completedLabel,
                                                style: TextStyle(
                                                    color: textColor));
                                          case 2:
                                            return const Text(failedLabel,
                                                style: TextStyle(
                                                    color: textColor));
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: textColor.withOpacity(0.2),
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
                                sections: _buildPieChartSections(),
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
                      backgroundColor: const Color.fromARGB(255, 174, 156, 115),
                    ),
                    child: const Text(
                      adminManagementLabel,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderManagementPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 156, 115),
                    ),
                    child: const Text(
                      orderManagementLabel,
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
                      backgroundColor: const Color.fromARGB(255, 174, 156, 115),
                    ),
                    child: const Text(
                      itemManagementLabel,
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                color: textColor,
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

  List<PieChartSectionData> _buildPieChartSections() {
    List<PieChartSectionData> sections = [];

    // Parse percentages and create sections
    double pendingPercentage = double.tryParse(
            orderPercentages[pendingPercentageField]
                    ?.toString()
                    .replaceAll('%', '') ??
                '0') ??
        0;
    double successfulPercentage = double.tryParse(
            orderPercentages[successfulPercentageField]
                    ?.toString()
                    .replaceAll('%', '') ??
                '0') ??
        0;
    double failedPercentage = double.tryParse(
            orderPercentages[failedPercentageField]
                    ?.toString()
                    .replaceAll('%', '') ??
                '0') ??
        0;

    // Add sections only if they have values > 0
    if (pendingPercentage > 0) {
      sections.add(_buildPieChartSection(
        pendingPercentage,
        pendingColor,
        '$pendingLabel\n${orderPercentages[pendingPercentageField] ?? '0%'}',
      ));
    }

    if (successfulPercentage > 0) {
      sections.add(_buildPieChartSection(
        successfulPercentage,
        completedColor,
        '$completedLabel\n${orderPercentages[successfulPercentageField] ?? '0%'}',
      ));
    }

    if (failedPercentage > 0) {
      sections.add(_buildPieChartSection(
        failedPercentage,
        failedColor,
        '$failedLabel\n${orderPercentages[failedPercentageField] ?? '0%'}',
      ));
    }

    // If no data, show a placeholder
    if (sections.isEmpty) {
      sections.add(_buildPieChartSection(
        100,
        noDataColor,
        '$noDataLabel\n100%',
      ));
    }

    return sections;
  }

  PieChartSectionData _buildPieChartSection(
      double value, Color color, String label) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 50,
      title: label,
      titleStyle: const TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      titlePositionPercentageOffset: 0.7,
    );
  }
}
