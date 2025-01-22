// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:image/image.dart' as img;

Future<bool> checkIfLandscape(List<FFUploadedFile> photoList) async {
  // Iterate through the list and check if any photo is landscape; if so, return true
  for (var photo in photoList) {
    // Ensure photo.bytes is not null before decoding
    if (photo.bytes != null) {
      final image = img.decodeImage(photo.bytes!);
      // Ensure the decoded image is not null before checking dimensions
      if (image != null && image.width > image.height) {
        return true;
      }
    }
  }
  return false; // Returns false if no landscape photos are found
}
