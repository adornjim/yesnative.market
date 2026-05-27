import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/logo.png');
  final image = img.decodePng(file.readAsBytesSync());
  if (image == null) return;
  
  int minX = image.width;
  int maxX = 0;
  int minY = image.height;
  int maxY = 0;
  
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      if (pixel.a > 10) { // not fully transparent
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  
  print('Content bounds: minX=$minX, maxX=$maxX, minY=$minY, maxY=$maxY');
}
