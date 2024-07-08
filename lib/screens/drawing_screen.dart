import 'package:flutter/material.dart';
import 'package:appleintelligence/widgets/drawing_painter.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handwriting Solver'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(renderBox.globalToLocal(details.globalPosition));
          });
        },
        // onPanEnd: (details) {
        //   points.add(null); // Add null to indicate end of drawing
        // },
        child: CustomPaint(
          painter: DrawingPainter(points.cast<Offset>()),
          child: Container(), // This is needed for gesture detection to work
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle submission to API
          // Implement API call and navigation to result screen
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
