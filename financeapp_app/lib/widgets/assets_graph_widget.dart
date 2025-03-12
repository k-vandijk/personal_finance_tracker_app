import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Configurable Constants
const int numGhostPoints = 8;
const double lineCurveSmoothness = 0.4;
const double lineThickness = 4.0;
const double labelFontSize = 13.0;
const int numDateLabels = 4;
const int numValueLabels = 4; // 8
const Color axisLabelColor = Colors.white;

class _AnchorPoint {
  final DateTime date;
  final double value;
  _AnchorPoint(this.date, this.value);
}

class AssetsGraphWidget extends StatelessWidget {
  final List<AssetDTO> assets;
  const AssetsGraphWidget({super.key, required this.assets});

  double _computeValueAt(DateTime date) {
    double total = 0;
    for (final asset in assets) {
      if ((asset.purchaseDate.isBefore(date) || asset.purchaseDate.isAtSameMomentAs(date)) &&
          (asset.saleDate == null || asset.saleDate!.isAfter(date))) {
        total += asset.purchasePrice;
      }
    }
    return total;
  }

  List<_AnchorPoint> _computeAnchorPoints() {
    final startDate = assets.map((e) => e.purchaseDate).reduce((a, b) => a.isBefore(b) ? a : b);
    final endDate = assets.fold<DateTime>(
      DateTime.now(),
      (prev, asset) {
        final assetEnd = asset.saleDate ?? DateTime.now();
        return assetEnd.isAfter(prev) ? assetEnd : prev;
      },
    );
    final dates = <DateTime>{};
    for (final asset in assets) {
      dates.add(asset.purchaseDate);
      if (asset.saleDate != null) dates.add(asset.saleDate!);
    }
    dates.add(startDate);
    dates.add(endDate);
    final sortedDates = dates.toList()..sort();
    return sortedDates.map((d) => _AnchorPoint(d, _computeValueAt(d))).toList();
  }

  List<FlSpot> _computeGhostPoints() {
    final anchors = _computeAnchorPoints();
    final startDate = anchors.first.date;
    final totalDays = anchors.last.date.difference(startDate).inDays.toDouble();
    final ghostPoints = <FlSpot>[];
    for (var i = 0; i < numGhostPoints; i++) {
      final fraction = i / (numGhostPoints - 1);
      final x = fraction * totalDays;
      final ghostDate = startDate.add(Duration(days: x.round()));

      _AnchorPoint? lower, upper;
      for (var j = 0; j < anchors.length; j++) {
        if (anchors[j].date.isAfter(ghostDate)) {
          upper = anchors[j];
          lower = j > 0 ? anchors[j - 1] : anchors[j];
          break;
        }
      }
      lower ??= anchors.last;
      upper ??= anchors.last;
      double interpolatedValue;
      if (upper.date == lower.date) {
        interpolatedValue = lower.value;
      } else {
        final totalInterval = upper.date.difference(lower.date).inDays.toDouble();
        final intervalPassed = ghostDate.difference(lower.date).inDays.toDouble();
        final interpFraction = intervalPassed / totalInterval;
        final curvedFraction = interpFraction * interpFraction * (3 - 2 * interpFraction);
        interpolatedValue = lower.value + curvedFraction * (upper.value - lower.value);
      }
      ghostPoints.add(FlSpot(x, interpolatedValue));
    }
    return ghostPoints;
  }

  String _formatDateLabel(double x) {
    final startDate = assets.map((e) => e.purchaseDate).reduce((a, b) => a.isBefore(b) ? a : b);
    final labelDate = startDate.add(Duration(days: x.round()));
    return "${labelDate.month.toString().padLeft(2, '0')}/${labelDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    final spots = _computeGhostPoints();
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final maxY = spots.map((e) => e.y).fold(0.0, (prev, e) => e > prev ? e : prev);
    return Padding(
      padding: const EdgeInsets.only(left: 42, right: 6), // 42 - 36 (for the right axis labels)
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: maxY / numValueLabels,
                  maxIncluded: false,
                  getTitlesWidget: (value, meta) {
                    if (value.round() == 0) return Container();
                    return Text(
                      formatCurrencyShort(value),
                      style: const TextStyle(
                        fontSize: labelFontSize,
                        color: axisLabelColor,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxX - minX) / (numDateLabels - 1),
                  getTitlesWidget: (value, meta) {
                    return Text(
                      _formatDateLabel(value),
                      style: const TextStyle(
                        fontSize: labelFontSize,
                        color: axisLabelColor,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: lineCurveSmoothness,
                dotData: const FlDotData(show: false),
                color: Theme.of(context).colorScheme.tertiary.withAlpha(200),
                barWidth: lineThickness,
              ),
            ],
            minX: minX,
            maxX: maxX,
            minY: 0,
            maxY: maxY * 1.1,
          ),
        ),
      ),
    );
  }
}
