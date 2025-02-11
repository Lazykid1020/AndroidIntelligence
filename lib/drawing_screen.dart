// import 'package:flutter/material.dart';
// import 'package:signature/signature.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'equation_solver_api.dart';

// class DrawingScreen extends StatefulWidget {
//   @override
//   _DrawingScreenState createState() => _DrawingScreenState();
// }

// class _DrawingScreenState extends State<DrawingScreen> {
//   final SignatureController _controller = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.white,
//   );

//   String? _solvedEquation;

//   Future<void> _submitDrawing() async {
//     if (_controller.isNotEmpty) {
//       final drawing = await _controller.toPngBytes();
//       if (drawing != null) {
//         final equation = await solveEquationFromImage(drawing, 'image/png');
//         if (equation != null) {
//           setState(() {
//             _solvedEquation = equation;
//           });
//         } else {
//           _showErrorDialog('Failed to solve the equation.');
//         }
//       }
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Draw Equation'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: _submitDrawing,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Signature(
//             controller: _controller,
//             backgroundColor: Colors.white,
//             height: 450,
//           ),
//           SizedBox(height: 20),
//           if (_solvedEquation != null)
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: _solvedEquation!
//                       .replaceAll('\$', " ")
//                       .split('\n')
//                       .map((step) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Math.tex(
//                         step.trim(),
//                         textStyle: TextStyle(fontSize: 20),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => {_controller.clear()},
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }
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

  String? _solvedEquation;

  Future<void> _submitDrawing() async {
    if (_controller.isNotEmpty) {
      final drawing = await _controller.toPngBytes();
      if (drawing != null) {
        final equation = await solveEquationFromImage(drawing, 'image/png');
        if (equation != null) {
          setState(() {
            _solvedEquation = equation;
          });
        } else {
          _showErrorDialog('Failed to solve the equation.');
        }
      }
    }
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

  void _clearDrawing() {
    setState(() {
      _controller.clear();
      _solvedEquation = null;
    });
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
      body: Column(
        children: [
          Signature(
            controller: _controller,
            backgroundColor: Colors.white,
            height: 450,
          ),
          SizedBox(height: 20),
          if (_solvedEquation != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _solvedEquation!
                      .replaceAll('\$', " ")
                      .split('\n')
                      .map((step) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Math.tex(
                        step.trim(),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearDrawing,
        child: Icon(Icons.clear),
      ),
    );
  }
}
