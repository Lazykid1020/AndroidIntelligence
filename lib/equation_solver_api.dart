import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<String?> solveEquationFromImage(Uint8List imageBytes, String mimeType) async {
  
  final uri = Uri.parse('http://192.168.0.101:3000/solve-equation'); // Replace with your actual server URL
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'imageBase64': base64Encode(imageBytes),
      'mimeType': mimeType,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['solution'];
  } else {
    return null;
  }
}

Future<Uint8List> convertToWhiteBackground(Uint8List imageBytes, int width, int height) async {
  final ui.Image originalImage = await decodeImageFromList(imageBytes);
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(pictureRecorder);

  final ui.Paint paint = ui.Paint();
  final ui.Paint whitePaint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);

  // Draw a white background
  canvas.drawRect(ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), whitePaint);

  // Draw the original image on top of the white background
  canvas.drawImage(originalImage, ui.Offset.zero, paint);

  final ui.Image finalImage = await pictureRecorder.endRecording().toImage(width, height);
  final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
