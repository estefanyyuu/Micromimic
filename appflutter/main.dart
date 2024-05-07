import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Micromimic App',
      home: MicromimicScreen(),
    );
  }
}

class MicromimicScreen extends StatefulWidget {
  const MicromimicScreen({super.key});

  @override
  _MicromimicScreenState createState() => _MicromimicScreenState();
}

class _MicromimicScreenState extends State<MicromimicScreen> {
  List<double> temperatureValues = [0]; // Initialize with a default value
  String inputValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micromimic App'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medición de Temperatura',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Temperature',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            inputValue = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (inputValue.isNotEmpty) {
                            setState(() {
                              temperatureValues.add(double.parse(inputValue));
                              if (temperatureValues.length > 5) {
                                temperatureValues.removeAt(0);
                              }
                              inputValue = '';
                            });
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Historical Values (Newest 5):',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: temperatureValues.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(temperatureValues[index].toString()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(fontSize: 10, color: Colors.black),
                            getTitles: (value) {
                              // Customizing X axis titles (bottom)
                              switch (value.toInt()) {
                                case 0:
                                  return '0';
                                case 1:
                                  return '1';
                                case 2:
                                  return '2';
                                case 3:
                                  return '3';
                                case 4:
                                  return '4';
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(fontSize: 10, color: Colors.black),
                            getTitles: (value) {
                              // Customizing Y axis titles (left)
                              return value.toInt().toString();
                            },
                          ),
                        ),
                        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                        lineBarsData: [
                          LineChartBarData(
                            spots: temperatureValues.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value);
                            }).toList(),
                            isCurved: true,
                            colors: [Colors.blue],
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getTemperatureStatus(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTemperatureStatus() {
    if (temperatureValues.isNotEmpty) {
      double lastTemperature = temperatureValues.last;
      if (lastTemperature < 35) {
        return 'Hipotermia';
      } else if (lastTemperature > 37) {
        return 'Fiebre';
      } else {
        return 'Normal';
      }
    } else {
      return 'No data';
    }
  }
}