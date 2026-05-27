import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/logo.png');
  final image = img.decodePng(file.readAsBytesSync());
  if (image == null) return;
  
  // The original image bounds are minX=10, maxX=276, minY=5, maxY=88
  // The leaves are on the left. We will crop from x=10, y=0 to width=85, height=94
  final cropped = img.copyCrop(image, x: 10, y: 0, width: 85, height: 94);
  
  // Create a new image for the app icon (needs to be perfectly square)
  final result = img.Image(width: 144, height: 144);
  
  // Fill with dark green primary color #2E4D3E
  img.fill(result, color: img.ColorRgb8(46, 77, 62)); 
  
  // Draw the cropped leaves centered
  img.compositeImage(result, cropped, dstX: 29, dstY: 25);
  
  File('assets/images/app_icon.png').writeAsBytesSync(img.encodePng(result));
  print('Done new crop.');
}
