import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/nevarkfoods.png');
  final image = img.decodePng(file.readAsBytesSync());
  if (image == null) return;
  
  // Crop the leaves
  final cropped = img.copyCrop(image, x: 10, y: 0, width: 85, height: 94);
  
  // Save as transparent png
  File('assets/images/leaf_watermark.png').writeAsBytesSync(img.encodePng(cropped));
  print('Done watermark crop.');
}
