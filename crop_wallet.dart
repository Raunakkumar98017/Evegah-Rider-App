import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  try {
    final bytes = File(r'C:\Users\Moksh Patel\.gemini\antigravity-ide\brain\d41515ca-b237-430e-a4c6-95682214d2d0\media__1781014947181.png').readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image != null) {
      // The image is the full wallet card. We crop the right side where the wallet is.
      // Let's print dimensions first.
      print("Width: ${image.width}, Height: ${image.height}");
      
      // Let's crop a box from the right side.
      // Assuming the wallet is in the right half.
      int cropWidth = image.width ~/ 2.5;
      int cropHeight = image.height;
      int startX = image.width - cropWidth;
      int startY = 0;
      
      final cropped = img.copyCrop(image, x: startX, y: startY, width: cropWidth, height: cropHeight);
      
      // Save it
      File('assets/images/original_wallet_cropped.png').writeAsBytesSync(img.encodePng(cropped));
      print("Cropped successfully!");
    }
  } catch(e) {
    print(e);
  }
}
