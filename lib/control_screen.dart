import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothConnection? connection;

  const ControlScreen({
    super.key,
    required this.connection,
  });

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

final List<Color> colors = [
  Colors.purpleAccent,
  Colors.teal,
  Colors.blue,
  Colors.pinkAccent,
  Colors.deepOrangeAccent,
  Colors.green,
  Colors.yellow.shade700,
  Colors.redAccent,
  Colors.indigoAccent,
  Colors.lime,
  Colors.purpleAccent,
  Colors.amber
];

const List<Icon> icons = [
  Icon(
    Icons.linear_scale,
    color: Colors.white,
    size: 60,
  ),
  Icon(
    Icons.leak_add,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.link,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.memory,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.meeting_room,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.nat_sharp,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.nature_people,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.nature,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.label_important,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.note,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.nfc,
    color: Colors.white,
    size: 40,
  ),
  Icon(
    Icons.multitrack_audio,
    color: Colors.white,
    size: 40,
  ),
];

const List<String> labels = [
  'MOV_CON_1',
  'PICK_BEAM_1',
  'MOV_CON_2',
  'PICK_BEAM_2',
  'MOV_CON_3',
  'PICK_BEAM_3',
  'MOV_CON_4',
  'PICK_BEAM_4',
  'PICK_BEAM_5',
  'PICK_BEAM_6',
  'PICK_BEAM_7',
  'PICK_BEAM_8',
];

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Functions'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust for your desired number of columns
          mainAxisSpacing: 0, // Spacing between rows
          crossAxisSpacing: 0, // Spacing between columns
        ),
        itemBuilder: (context, index) {
          print("index: $index");
          return Padding(
            padding: const EdgeInsets.all(8.0), // Adjust padding as needed
            child: Action(colorIndex: index), // Your grid item widget
          );
        },
        itemCount: 12,
      ),
    );
  }
}

class Action extends StatelessWidget {
  final int colorIndex;

  const Action({
    super.key,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            color: colors[colorIndex],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                icons[colorIndex],
                Text(
                  labels[colorIndex],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
