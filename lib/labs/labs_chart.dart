
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';



// API Service Class
class LabApiService {
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getAllLabsItemsByTestValueAndDate(
      String labCode, String testCode) async {
    final url =
        'http://localhost:9997/labs-integration-with-emergency/api/v1/labs-w-emergency/test-values-last/$labCode/$testCode';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        debugPrint("API Response: ${response.data}");

        // Handle different response formats
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map<String, dynamic>) {
          return [response.data as Map<String, dynamic>];
        } else {
          debugPrint('Unexpected response format');
          return [];
        }
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching tools: $e');
      throw Exception('Failed to load tools: $e');
    }
  }
}

// Data Models
class LabDataPoint {
  final DateTime date;
  final double value;
  final String? unit;
  final String? referenceRange;
  final bool? isAbnormal;

  LabDataPoint({
    required this.date,
    required this.value,
    this.unit,
    this.referenceRange,
    this.isAbnormal,
  });

  factory LabDataPoint.fromMap(Map<String, dynamic> map) {
    return LabDataPoint(
      date: _parseDate(map['date'] ?? map['testDate'] ?? map['timestamp']),
      value: _parseDouble(map['value'] ?? map['testValue'] ?? map['result']),
      unit: map['unit'] ?? map['unitOfMeasure'],
      referenceRange: map['referenceRange'] ?? map['normalRange'],
      isAbnormal: map['isAbnormal'] ?? map['abnormal'],
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is DateTime) return dateValue;
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        debugPrint('Error parsing date: $dateValue');
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        debugPrint('Error parsing double: $value');
        return 0.0;
      }
    }
    return 0.0;
  }
}

// Chart Configuration
class LabChartConfig {
  final String? title;
  final String? subtitle;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final Color primaryColor;
  final Color? abnormalColor;
  final bool showGrid;
  final bool showLegend;
  final bool animate;
  final bool showReferenceLines;
  final EdgeInsets padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double height;
  final double? width;

  const LabChartConfig({
    this.title,
    this.subtitle,
    this.xAxisLabel = 'Date',
    this.yAxisLabel = 'Value',
    this.primaryColor = Colors.blue,
    this.abnormalColor = Colors.red,
    this.showGrid = true,
    this.showLegend = true,
    this.animate = true,
    this.showReferenceLines = false,
    this.padding = const EdgeInsets.all(16.0),
    this.titleStyle,
    this.subtitleStyle,
    this.height = 300,
    this.width,
  });
}

// Reusable Lab Chart Widget
class LabChart extends StatelessWidget {
  final List<LabDataPoint> dataPoints;
  final LabChartConfig config;
  final String? labCode;
  final String? testCode;

  const LabChart({
    Key? key,
    required this.dataPoints,
    this.config = const LabChartConfig(),
    this.labCode,
    this.testCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Container(
        height: config.height,
        width: config.width,
        padding: config.padding,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.no_sim, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: config.height,
      width: config.width,
      padding: config.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (config.title != null) _buildTitle(),
          if (config.subtitle != null) _buildSubtitle(),
          if (config.title != null || config.subtitle != null)
            const SizedBox(height: 16),
          Expanded(child: _buildChart()),
          if (config.showLegend) _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      config.title!,
      style: config.titleStyle ??
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      config.subtitle!,
      style: config.subtitleStyle ??
          TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
    );
  }

  Widget _buildChart() {
    final sortedPoints = List<LabDataPoint>.from(dataPoints)
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sortedPoints.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final point = entry.value;
      return FlSpot(index, point.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: config.showGrid),
        titlesData: _buildTitlesData(sortedPoints),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: config.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: config.primaryColor.withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final point = sortedPoints[index.toInt()];
                final color = point.isAbnormal == true
                    ? (config.abnormalColor ?? Colors.red)
                    : config.primaryColor;
                return FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < sortedPoints.length) {
                  final point = sortedPoints[index];
                  return LineTooltipItem(
                    '${_formatDate(point.date)}\n'
                    'Value: ${point.value.toStringAsFixed(2)}'
                    '${point.unit != null ? ' ${point.unit}' : ''}'
                    '${point.isAbnormal == true ? '\n⚠️ Abnormal' : ''}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
      duration:
          config.animate ? const Duration(milliseconds: 300) : Duration.zero,
    );
  }

  FlTitlesData _buildTitlesData(List<LabDataPoint> sortedPoints) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: config.yAxisLabel != null
            ? Text(
                config.yAxisLabel!,
                style: const TextStyle(fontSize: 12),
              )
            : null,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: config.xAxisLabel != null
            ? Text(
                config.xAxisLabel!,
                style: const TextStyle(fontSize: 12),
              )
            : null,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: (sortedPoints.length / 5).ceilToDouble(),
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < sortedPoints.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _formatDate(sortedPoints[index].date),
                  style: const TextStyle(fontSize: 9),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          _buildLegendItem('Normal', config.primaryColor),
          const SizedBox(width: 16),
          if (config.abnormalColor != null)
            _buildLegendItem('Abnormal', config.abnormalColor!),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

// Main Page with Chart Integration
class LabChartHomePage extends StatefulWidget {
  const LabChartHomePage({Key? key}) : super(key: key);

  @override
  State<LabChartHomePage> createState() => _LabChartHomePageState();
}

class _LabChartHomePageState extends State<LabChartHomePage> {
  final LabApiService _apiService = LabApiService();
  final TextEditingController _labCodeController = TextEditingController();
  final TextEditingController _testCodeController = TextEditingController();

  List<LabDataPoint> _chartData = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Set default values for testing
    _labCodeController.text = '11';
    _testCodeController.text = '84';
  }

  @override
  void dispose() {
    _labCodeController.dispose();
    _testCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadChartData() async {
    if (_labCodeController.text.isEmpty || _testCodeController.text.isEmpty) {
      setState(() {
        _error = 'Please enter both lab code and test code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.getAllLabsItemsByTestValueAndDate(
        _labCodeController.text.trim(),
        _testCodeController.text.trim(),
      );

      final chartData = data.map((item) => LabDataPoint.fromMap(item)).toList();

      setState(() {
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Test Results Chart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputSection(),
            const SizedBox(height: 24),
            _buildChartSection(),
            const SizedBox(height: 24),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lab Test Parameters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _labCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Lab Code',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 11',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _testCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Test Code',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 84',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _loadChartData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Loading...' : 'Load Chart Data'),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      child: LabChart(
        dataPoints: _chartData,
        config: LabChartConfig(
          title: 'Lab Test Results Over Time',
          subtitle: _labCodeController.text.isNotEmpty &&
                  _testCodeController.text.isNotEmpty
              ? 'Lab: ${_labCodeController.text} | Test: ${_testCodeController.text}'
              : null,
          height: 400,
          primaryColor: Colors.blue,
          abnormalColor: Colors.red,
          showGrid: true,
          showLegend: true,
          animate: true,
        ),
        labCode: _labCodeController.text,
        testCode: _testCodeController.text,
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chart Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total data points: ${_chartData.length}'),
            if (_chartData.isNotEmpty) ...[
              Text(
                  'Date range: ${_formatDate(_chartData.first.date)} - ${_formatDate(_chartData.last.date)}'),
              Text('Unit: ${_chartData.first.unit ?? 'N/A'}'),
              if (_chartData.any((p) => p.isAbnormal == true))
                const Text('⚠️ Contains abnormal values',
                    style: TextStyle(color: Colors.orange)),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
