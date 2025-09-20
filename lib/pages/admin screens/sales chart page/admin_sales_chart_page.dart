import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/fl%20chart%20riverpod/fl_chart_riverpod.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/admin_app_bar.dart';

class AdminSalesChart extends ConsumerStatefulWidget {
  const AdminSalesChart({super.key});

  @override
  ConsumerState<AdminSalesChart> createState() => _AdminSalesChartState();
}

class _AdminSalesChartState extends ConsumerState<AdminSalesChart> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(flChartProvider.notifier).initialize();
        ref.read(flChartProvider.notifier).getData(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar('Sales Statistics'),
      body: Center(
        child: Consumer(
          builder: (context, x, child) {
            var flChartProvi = x.watch(flChartProvider);

            if (flChartProvi.isLoading) {
              return const SizedBox();
            } else if (flChartProvi.isError) {
              return Text(flChartProvi.error);
            } else {
              var value = flChartProvi;
              int total = value.bata + value.ndure + value.servis + value.stylo;
              var style = const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              );
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: flChartProvi.bata.toDouble(),
                              color: Colors.red,
                              radius: 30,
                              title:
                                  '${((value.bata / total) * 100).toStringAsFixed(0)}%',
                              titleStyle: style,
                            ),

                            PieChartSectionData(
                              value: flChartProvi.servis.toDouble(),
                              color: Colors.blue,
                              title:
                                  '${((value.servis / total) * 100).toStringAsFixed(0)}%',
                              titleStyle: style,
                            ),
                            PieChartSectionData(
                              value: flChartProvi.stylo.toDouble(),
                              color: Colors.green,
                              radius: 30,
                              title:
                                  '${((value.stylo / total) * 100).toStringAsFixed(0)}%',
                              titleStyle: style,
                            ),
                            PieChartSectionData(
                              value: flChartProvi.ndure.toDouble(),
                              color: Colors.orange,
                              title:
                                  '${((value.ndure / total) * 100).toStringAsFixed(0)}%',
                              titleStyle: style,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: 200,
                      width: 200,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _colorsWithName(
                            'NDURE (${((value.ndure / total) * 100).toStringAsFixed(0)}%)',
                            Colors.orange,
                          ),
                          _colorsWithName(
                            'Bata  (${((value.bata / total) * 100).toStringAsFixed(0)}%)',
                            Colors.red,
                          ),
                          _colorsWithName(
                            'Servis  (${((value.servis / total) * 100).toStringAsFixed(0)}%)',
                            Colors.blue,
                          ),
                          _colorsWithName(
                            'Stylo  (${((value.stylo / total) * 100).toStringAsFixed(0)}%)',
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _colorsWithName(String title, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Flexible(child: Container(height: 20, width: 20, color: color)),
        Flexible(
          child: Text(
            '  $title',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
