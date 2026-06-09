import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  try {
    final bytes = File('assets/images/original_wallet_cropped.png').readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image != null) {
      final pixel = image.getPixel(0, 0);
      print("CROP COLOR: r=${pixel.r}, g=${pixel.g}, b=${pixel.b}");
    }
  } catch(e) {
    print(e);
  }
}
