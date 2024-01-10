// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:new_lesson/service/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController kitir1 = TextEditingController();
  final TextEditingController kirit2 = TextEditingController();
  final GlobalKey<ScaffoldState> _yagona  = GlobalKey<ScaffoldState>();
  List<int> hisobla = [];
  List<String> uzgarishlar = [];
  void _natijaSaqlash(int result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastResult', result);
  }

  void _oddiylik(int Function(int, int) operation, String operationName) {
    final user1 = kitir1.text;
    final user2 = kirit2.text;
    final number1 = int.tryParse(user1) ?? 0;
    final number2 = int.tryParse(user2) ?? 0;
    final result = operation(number1, number2);
    _natijaSaqlash(result);
    setState(() {
      hisobla.add(result);
      uzgarishlar.add('Performed $operationName operation');
    });

    ScaffoldMessenger.of(_yagona.currentContext!).showSnackBar(
      SnackBar(
        content: Text('Result: $result'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.blue),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(_yagona.currentContext!).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget buildActionButtons(TextEditingController controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildActionButton(controller, Icons.add, () {
            _oddiylik((a, b) => a + b, 'addition');
          }),
          buildActionButton(controller, Icons.remove, () {
            _oddiylik((a, b) => a - b, 'subtraction');
          }),
          buildActionButton(controller, Icons.close, () {
            _oddiylik((a, b) => a * b, 'multiplication');
          }),
          buildActionButton(controller, Icons.percent, () {
            _oddiylik((a, b) => a % b, '');
          }),
          Column(
            children: [
              ElevatedButton(onPressed: (){}, child: const Icon(Icons.add)),
              ElevatedButton(onPressed: (){}, child: const Icon(Icons.remove)),
              ElevatedButton(onPressed: (){}, child: const Icon(Icons.close)),
              ElevatedButton(onPressed: (){}, child: const Icon(Icons.delete)),
            ],
          ),
          Column(
            children: [
              ElevatedButton(onPressed: (){}, child: const Text('1')),
              ElevatedButton(onPressed: (){}, child: const Text('4')),
              ElevatedButton(onPressed: (){}, child: const Text('7')),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder:
                        (context)
                    => HistoryPage(allChanges: uzgarishlar)));},
                  child: const Text(' History '))
            ],
          ),
          Column(
            children: [
              ElevatedButton(onPressed: (){}, child: const Text('2')),
              ElevatedButton(onPressed: (){}, child: const Text('5')),
              ElevatedButton(onPressed: (){}, child: const Text('8')),
              ElevatedButton(onPressed: (){}, child: const Text('00')),
            ],
          ),
          Column(
            children: [
              ElevatedButton(onPressed: (){}, child: const Text('3')),
              ElevatedButton(onPressed: (){}, child: const Text('6')),
              ElevatedButton(onPressed: (){}, child: const Text('9')),
              ElevatedButton(
                onPressed: () {
                  _showHistory();
                  _printAllChanges();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(
      TextEditingController controller, IconData icon, Function() onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _yagona,
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: kitir1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'First number',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: kirit2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Second number',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              buildActionButtons(kirit2),
              const SizedBox(height: 20),



            ],
          ),
        ),
      ),
    );
  }

  void _showHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastResult = prefs.getInt('lastResult');
    List<int> calculationHistory = [...hisobla];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Calculation History'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (lastResult != null)
                  Text('Last Result: $lastResult'),
                ...calculationHistory.map((result) => Text('Result: $result'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _natijaSaqlash(lastResult!);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _printAllChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastResult = prefs.getInt('lastResult');

    print('All Changes:');

    if (lastResult != null) {
      print('- Last Result: $lastResult');
    }

    for (String change in uzgarishlar) {
      print('- $change');
    }
  }
}

