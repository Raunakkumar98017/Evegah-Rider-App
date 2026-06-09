import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  try {
    final bytes = File(r'C:\Users\Moksh Patel\.gemini\antigravity-ide\brain\d41515ca-b237-430e-a4c6-95682214d2d0\media__1781014947181.png').readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image != null) {
      // Find the actual card by looking for dark pixels
      int minX = image.width, minY = image.height, maxX = 0, maxY = 0;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final p = image.getPixel(x, y);
          // if not close to white or transparent
          if (p.r < 240 && p.g < 240 && p.b < 240 && p.a > 10) {
            if (x < minX) minX = x;
            if (y < minY) minY = y;
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;
          }
        }
      }
      
      print("Card bounds: ($minX, $minY) to ($maxX, $maxY)");
      int cardWidth = maxX - minX;
      int cardHeight = maxY - minY;
      
      // We crop the right 40% of the card
      int cropWidth = (cardWidth * 0.45).toInt();
      int startX = maxX - cropWidth;
      
      final cropped = img.copyCrop(image, x: startX, y: minY, width: cropWidth, height: cardHeight);
      
      File('assets/images/wallet_exact.png').writeAsBytesSync(img.encodePng(cropped));
      
      // Get the background color from the left side of the crop
      final bgPixel = cropped.getPixel(0, cropped.height ~/ 2);
      print("CARD COLOR: r=${bgPixel.r}, g=${bgPixel.g}, b=${bgPixel.b}");
      print("Cropped perfectly!");
    }
  } catch(e) {
    print(e);
  }
}
