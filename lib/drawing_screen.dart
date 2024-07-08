import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'equation_solver_api.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> _submitDrawing() async {
    if (_controller.isNotEmpty) {
      final drawing = await _controller.toPngBytes();
      if (drawing != null) {
        final equation = await solveEquationFromImage(drawing, 'image/png');
        if (equation != null) {
          _showResultDialog(equation);
        } else {
          _showErrorDialog('Failed to solve the equation.');
        }
      }
    }
  }

  void _showResultDialog(String equation) {
    // Split the equation into steps based on newline characters
    final steps = equation.split('\n');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Solved Equation'),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps.map((step) {
                return Math.tex(
                  step.trim(),
                  textStyle: TextStyle(fontSize: 20),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw Equation'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitDrawing,
          ),
        ],
      ),
      body: Signature(
        controller: _controller,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.clear(),
        child: Icon(Icons.clear),
      ),
    );
  }
}
