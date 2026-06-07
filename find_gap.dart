import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/nevarkfoods.png');
  final image = img.decodePng(file.readAsBytesSync());
  if (image == null) return;
  
  for (int x = 10; x < 276; x++) {
    bool hasPixels = false;
    for (int y = 5; y <= 88; y++) {
      final pixel = image.getPixel(x, y);
      if (pixel.a > 10) {
        hasPixels = true;
        break;
      }
    }
    if (!hasPixels) {
      print('Empty column found at x=$x');
    }
  }
}
