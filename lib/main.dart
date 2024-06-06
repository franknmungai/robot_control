import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:robot_control/control_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Robot Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _connect().then((value) => print('Connection process complete'));
  }

  List<String> labels = [
    'Gripper',
    'Wrist-Pitch',
    'Wrist-Roll',
    'Elbow',
    'Shoulder',
    'Base',
    '',
    '',
    '',
    '',
    'Base',
    'Shoulder',
    'Elbow',
    'Wrist-Roll',
    'Wrist Pitch',
    'Gripper',
  ];

  // gripper = 5, wrist = 4..... base = 0
  List<int> channel1 = [0, 1, 2, 3, 4, 5];

  // gripper = 15, wrist1 = 14.... base = 10
  List<int> channel2 = [15, 14, 13, 12, 11, 10];

  List<double> angles = [0, 0, 0, 0, 90, 90, 0, 0, 0, 0, 90, 90, 0, 0, 0, 0];

  final String address = "00:20:10:08:D2:3B";
  BluetoothConnection? connection;

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> requestPermission() async {
    var status = await Permission.bluetooth.request();
    if (status == PermissionStatus.granted) {
      print('Bluetooth Permission Granted');
    } else {
      print('Bluetooth Permission Denied');
    }
  }

  String connectionState = 'Not Connected';

  Future<void> _connect() async {
    setState(() {
      connectionState = 'Connecting...';
    });

    await requestPermission(); // Request permission before connecting
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to Bluetooth device: $address');

      setState(() {
        connectionState = 'Bluetooth Connected';
      });
    } catch (error) {
      print('Connection error: ${error.toString()}');
    }
  }

  Future<void> _sendData(String data) async {
    if (connection != null) {
      connection?.output
          .add(Uint8List.fromList(data.codeUnits)); // Convert to Uint8List
      await connection?.output.allSent;
      print('Data sent: $data');
    } else {
      print('Connection not available!');
    }
  }

  bool robot1Active = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                // Navigate to the second screen (replace "SecondScreen" with your actual class name)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ControlScreen(connection: connection),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: robot1Active
                            ? () {
                                setState(() {
                                  robot1Active = false;
                                });
                              }
                            : null,
                        child: const Text('Robot 1'),
                      ),
                      ElevatedButton(
                        onPressed: !robot1Active
                            ? () {
                                setState(() => robot1Active = true);
                              }
                            : null,
                        child: const Text('Robot 2'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    connectionState,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Controlling Robot ${robot1Active ? '1' : '2'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i in robot1Active ? channel1 : channel2)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${labels[i]}: ${angles[i].roundToDouble()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Slider(
                              value: angles[i],
                              min: 0.0,
                              max: 180.0,
                              onChanged: (value) {
                                setState(() {
                                  angles[i] = value;
                                  //transmitValue(value); // Transmit new value
                                });

                                _sendData("$i-${value.round()}\n\r");
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .purple[100], // Set background color
                                      borderRadius: BorderRadius.circular(
                                        30.0,
                                      ), // Set border radius
                                    ),
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (angles[i] > 0) angles[i] -= 1;
                                          });

                                          _sendData(
                                              "$i-${angles[i].round()}\n\r");
                                        },
                                        onLongPress: () async {
                                          setState(() {
                                            if (angles[i] > 0) angles[i] -= 1;
                                          });

                                          await _sendData(
                                              "$i-${angles[i].round()}\n\r");

                                          await Future.delayed(
                                              const Duration(microseconds: 50));
                                        },
                                        child: const Text(
                                          '-',
                                          style: TextStyle(
                                            // fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: IconButton.filledTonal(
                                      onPressed: () {
                                        setState(() {
                                          if (angles[i] < 180) angles[i] += 1;
                                        });
                                        _sendData(
                                            "$i-${angles[i].round()}\n\r");
                                      },
                                      icon: const Icon(Icons.add),
                                      iconSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 8.0)
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
