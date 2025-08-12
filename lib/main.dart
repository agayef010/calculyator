import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == 'CE') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          String finalInput = input
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll(',', '.'); // Vergülü nöqtəyə çevirdik

          // Faiz işarəsini *0.01 kimi dəyişək
          finalInput = finalInput.replaceAllMapped(
            RegExp(r'(\d+(\.\d+)?)%'),
            (match) => '(${match.group(1)}*0.01)',
          );

          Parser p = Parser();
          Expression exp = p.parse(finalInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  Widget buildButton(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[850],
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['C', 'CE', ',', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['%', '0', '=', ''],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulyator  ' )
        ,actions: [
          Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Center(
        child: Text(
          'agayeff',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: const TextStyle(fontSize: 28, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(result, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: buttons.expand((e) => e).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final btn = buttons.expand((e) => e).toList()[index];
              if (btn == '') return const SizedBox.shrink();
              final isOperator = ['÷', '×', '-', '+', '=', '%'].contains(btn);
              final isDelete = btn == 'C' || btn == 'CE';
              return buildButton(
                btn,
                color: isOperator
                    ? Colors.orange
                    : isDelete
                        ? Colors.red
                        : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
