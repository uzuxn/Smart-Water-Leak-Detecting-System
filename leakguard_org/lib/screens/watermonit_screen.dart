import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterMonitoringScreen extends StatelessWidget {
  const WaterMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Water Monitoring"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Water Usage Graph
            const Text(
              "24h Water Consumption",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildWaterUsageGraph(),
            const SizedBox(height: 16),

            // Live Flow Rate & System Efficiency
            Row(
              children: [
                Expanded(child: _buildFlowRateCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildSystemHealthCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Water Usage Graph (Dummy Data)
  Widget _buildWaterUsageGraph() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 10),
                const FlSpot(1, 20),
                const FlSpot(2, 15),
                const FlSpot(3, 25),
                const FlSpot(4, 30),
                const FlSpot(5, 18),
                const FlSpot(6, 22),
              ],
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  // Flow Rate Widget
  Widget _buildFlowRateCard() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Live Flow Rate",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "2.5 L/min",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // System Efficiency Widget
  Widget _buildSystemHealthCard() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "System Efficiency",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "98%",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
