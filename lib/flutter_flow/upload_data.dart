import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:video_player/video_player.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow_util.dart';

const allowedFormats = {'image/png', 'image/jpeg', 'video/mp4', 'image/gif'};

// Android-specific image picker with proper limit enforcement
Future<List<XFile>> _pickMultipleImagesAndroid({
  required ImagePicker picker,
  required double? maxWidth,
  required double? maxHeight,
  required int? imageQuality,
  required int limit,
}) async {
  print(
      '[IMAGE_LIMIT] 🤖 Android native picker: Attempting to use proper limit enforcement');

  try {
    // First, try using the enhanced Android implementation
    final List<XFile> images = await _tryAndroidNativePicker(
      picker: picker,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
    );

    print(
        '[IMAGE_LIMIT] 🤖 Android native picker returned ${images.length} images');

    // Double-check the limit enforcement
    if (images.length > limit) {
      print(
          '[IMAGE_LIMIT] ⚠️ Android picker exceeded limit, manually enforcing');
      return images.take(limit).toList();
    }

    return images;
  } catch (e) {
    print('[IMAGE_LIMIT] ❌ Android native picker error: $e');
    rethrow;
  }
}

// Enhanced Android picker that uses platform channel for native limit enforcement
Future<List<XFile>> _tryAndroidNativePicker({
  required ImagePicker picker,
  required double? maxWidth,
  required double? maxHeight,
  required int? imageQuality,
  required int limit,
}) async {
  print(
      '[IMAGE_LIMIT] 🔧 Trying Android native picker with platform channel limit: $limit');

  try {
    // First try using platform channel for native Android picker
    final List<String>? imagePaths = await _callNativeAndroidPicker(limit);

    if (imagePaths != null && imagePaths.isNotEmpty) {
      print(
          '[IMAGE_LIMIT] � Native Android platform channel returned ${imagePaths.length} images');

      // Convert paths/URIs to XFile objects - FIX: Ensure proper file reading
      final List<XFile> images = [];
      for (String path in imagePaths) {
        try {
          // Create XFile and verify it can be read
          final XFile xfile = XFile(path);

          // Test if we can read the file to ensure it's valid
          try {
            final bytes = await xfile.readAsBytes();
            if (bytes.isNotEmpty) {
              images.add(xfile);
              print(
                  '[IMAGE_LIMIT] ✅ Successfully validated image: $path (${bytes.length} bytes)');
            } else {
              print('[IMAGE_LIMIT] ⚠️ Skipping empty image: $path');
            }
          } catch (readError) {
            print('[IMAGE_LIMIT] ⚠️ Direct read failed for $path: $readError');
            // Try using native Android content URI reader as fallback
            try {
              print(
                  '[IMAGE_LIMIT] 🔄 Attempting native content URI reader for: $path');
              final nativeBytes = await _readContentUriNative(path);
              if (nativeBytes != null && nativeBytes.isNotEmpty) {
                // Create a new XFile with the validated bytes
                images.add(xfile);
                print(
                    '[IMAGE_LIMIT] ✅ Native reader success: $path (${nativeBytes.length} bytes)');
              } else {
                print(
                    '[IMAGE_LIMIT] ⚠️ Native reader returned empty for: $path');
              }
            } catch (nativeError) {
              print(
                  '[IMAGE_LIMIT] ❌ Native reader also failed for $path: $nativeError');
            }
          }
        } catch (e) {
          print('[IMAGE_LIMIT] ⚠️ Failed to validate image: $path, error: $e');
        }
      }

      print(
          '[IMAGE_LIMIT] ✅ Successfully validated ${images.length} images out of ${imagePaths.length}');
      return images;
    } else {
      print(
          '[IMAGE_LIMIT] ⚠️ Native platform channel returned empty, falling back to image_picker');
      throw Exception('Native picker returned empty result');
    }
  } catch (e) {
    print('[IMAGE_LIMIT] ❌ Native platform channel failed: $e');
    print('[IMAGE_LIMIT] 🔄 Falling back to image_picker with limit parameter');

    // Fallback to image_picker with limit
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      requestFullMetadata: true,
      imageQuality: imageQuality,
      limit: limit,
    );

    print(
        '[IMAGE_LIMIT] 📱 Fallback image_picker completed with ${images.length} images');
    return images;
  }
}

// Read content URI bytes using native Android method
Future<Uint8List?> _readContentUriNative(String uri) async {
  print('[IMAGE_LIMIT] 📱 Calling native Android content URI reader for: $uri');

  try {
    const platform = MethodChannel('com.ispeedpix2pdf.native_picker');
    final result = await platform.invokeMethod('readContentUri', {
      'uri': uri,
    });

    if (result != null) {
      final Uint8List bytes = Uint8List.fromList(result.cast<int>());
      print(
          '[IMAGE_LIMIT] 🎯 Native Android content URI reader returned ${bytes.length} bytes');
      return bytes;
    } else {
      print('[IMAGE_LIMIT] ❌ Native Android content URI reader returned null');
      return null;
    }
  } catch (e) {
    print('[IMAGE_LIMIT] ❌ Native content URI reader error: $e');
    return null;
  }
}

// Call native Android picker using platform channel
Future<List<String>?> _callNativeAndroidPicker(int limit) async {
  print(
      '[IMAGE_LIMIT] � Calling native Android picker via platform channel with limit: $limit');

  try {
    const platform = MethodChannel('com.ispeedpix2pdf.native_picker');
    final List<dynamic>? result =
        await platform.invokeMethod('pickMultipleImages', {
      'limit': limit,
    });

    if (result != null) {
      final List<String> imagePaths = result.cast<String>();
      print(
          '[IMAGE_LIMIT] 🎯 Native Android picker returned ${imagePaths.length} images via platform channel');
      return imagePaths;
    } else {
      print('[IMAGE_LIMIT] ❌ Native Android picker returned null');
      return null;
    }
  } catch (e) {
    print('[IMAGE_LIMIT] ❌ Platform channel error: $e');
    return null;
  }
}

class SelectedFile {
  const SelectedFile({
    this.storagePath = '',
    this.filePath,
    required this.bytes,
    this.dimensions,
    this.blurHash,
  });
  final String storagePath;
  final String? filePath;
  final Uint8List bytes;
  final MediaDimensions? dimensions;
  final String? blurHash;
}

class MediaDimensions {
  const MediaDimensions({
    this.height,
    this.width,
  });
  final double? height;
  final double? width;
}

enum MediaSource {
  photoGallery,
  videoGallery,
  camera,
}

Future<List<SelectedFile>?> selectMediaWithSourceBottomSheet({
  required BuildContext context,
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  required bool allowPhoto,
  bool allowVideo = false,
  String pickerFontFamily = 'Roboto',
  Color textColor = const Color(0xFF111417),
  Color backgroundColor = const Color(0xFFF5F5F5),
  bool includeDimensions = false,
  bool includeBlurHash = false,
  int remainingTime = 0,
}) async {
  final createUploadMediaListTile =
      (String label, MediaSource mediaSource) => ListTile(
            title: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                pickerFontFamily,
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            tileColor: backgroundColor,
            dense: false,
            onTap: () => Navigator.pop(
              context,
              mediaSource,
            ),
          );

  final mediaSource = await showModalBottomSheet<MediaSource>(
      context: context,
      backgroundColor: backgroundColor,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: ListTile(
                  title: Text(
                    'Choose Source',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      pickerFontFamily,
                      color: textColor.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  tileColor: backgroundColor,
                  dense: false,
                ),
              ),
              const Divider(),
            ],
            if (allowPhoto && allowVideo) ...[
              createUploadMediaListTile(
                'Gallery (Photo)',
                MediaSource.photoGallery,
              ),
              const Divider(),
              createUploadMediaListTile(
                'Gallery (Video)',
                MediaSource.videoGallery,
              ),
            ] else if (allowPhoto)
              createUploadMediaListTile(
                'Gallery',
                MediaSource.photoGallery,
              )
            else
              createUploadMediaListTile(
                'Gallery',
                MediaSource.videoGallery,
              ),
            if (!kIsWeb) ...[
              const Divider(),
              createUploadMediaListTile('Camera', MediaSource.camera),
              const Divider(),
            ],
            const SizedBox(height: 10),
          ],
        );
      });

  if (mediaSource == null) {
    return null;
  }

  return selectMedia(
    storageFolderPath: storageFolderPath,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
    isVideo: mediaSource == MediaSource.videoGallery ||
        (mediaSource == MediaSource.camera && allowVideo && !allowPhoto),
    mediaSource: mediaSource,
    includeDimensions: includeDimensions,
    includeBlurHash: includeBlurHash,
    remainingTime: remainingTime,
  );
}

Future<List<SelectedFile>?> selectMedia({
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  bool isVideo = false,
  MediaSource mediaSource = MediaSource.camera,
  bool multiImage = false,
  bool includeDimensions = false,
  bool includeBlurHash = false,
  bool isSubscribed = false,
  bool are7DaysPassed = false,
  required int remainingTime,
}) async {
  try {
    final picker = ImagePicker();

// Debug logging for image selection limit
    print('[IMAGE_LIMIT] 📸 Image selection logic evaluation:');
    print('[IMAGE_LIMIT] 🔍 !isSubscribed = ${!isSubscribed}');
    print('[IMAGE_LIMIT] 🔍 are7DaysPassed = $are7DaysPassed');
    print('[IMAGE_LIMIT] 🔍 remainingTime = $remainingTime');
    print('[IMAGE_LIMIT] 🔍 remainingTime <= 0 = ${remainingTime <= 0}');
    print(
        '[IMAGE_LIMIT] 🧮 Full condition: (!isSubscribed && are7DaysPassed && remainingTime <= 0) = ${(!isSubscribed && are7DaysPassed && remainingTime <= 0)}');
    print(
        '[IMAGE_LIMIT] 🎯 Selected limit: ${(!isSubscribed && are7DaysPassed && remainingTime <= 0) ? 3 : 60} images');
    if (multiImage) {
      List<XFile> pickedMedia = [];

      // Calculate image limit once for both platforms
      final int imageLimit =
          (!isSubscribed && are7DaysPassed && remainingTime <= 0) ? 3 : 60;

      if (Platform.isAndroid) {
        // Android: Use native Android picker with proper limit enforcement
        print(
            '[IMAGE_LIMIT] 🤖 Android: Using native picker with EXTRA_PICK_IMAGES_MAX limit: $imageLimit');

        try {
          // Use Android-specific implementation with proper limit
          print('[IMAGE_LIMIT] 🔧 Opening Android native picker with limit...');
          pickedMedia = await _pickMultipleImagesAndroid(
            picker: picker,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            limit: imageLimit,
          );
          print(
              '[IMAGE_LIMIT] 📊 Android native picker returned ${pickedMedia.length} images (limit: $imageLimit)');
        } catch (e) {
          print('[IMAGE_LIMIT] ❌ Android native picker failed: $e');
          print(
              '[IMAGE_LIMIT] 🔄 Falling back to regular picker with manual limit');

          // Fallback to regular picker
          try {
            pickedMedia = await picker.pickMultiImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              requestFullMetadata: true,
              imageQuality: imageQuality,
              limit: imageLimit,
            );

            // Manually enforce limit for fallback
            if (pickedMedia.length > imageLimit) {
              print(
                  '[IMAGE_LIMIT] ✂️ Fallback: manually limiting to $imageLimit images');
              pickedMedia = pickedMedia.take(imageLimit).toList();
            }
          } catch (fallbackError) {
            print(
                '[IMAGE_LIMIT] ❌ Fallback picker also failed: $fallbackError');
            return null;
          }
        }
      } else {
        // iOS: Use regular picker with limit
        print('[IMAGE_LIMIT] 🍎 Using iOS picker with limit: $imageLimit');

        pickedMedia = await picker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          requestFullMetadata: true,
          imageQuality: imageQuality,
          limit: imageLimit,
        );
      }

      // Always enforce limit as final safety check
      if (pickedMedia.length > imageLimit) {
        print(
            '[IMAGE_LIMIT] ✂️ Final safety check: limiting to $imageLimit images');
        pickedMedia = pickedMedia.take(imageLimit).toList();
      }

      print('[IMAGE_LIMIT] ✅ Successfully picked ${pickedMedia.length} images');

      if (pickedMedia.isEmpty) {
        print('[IMAGE_LIMIT] ❌ No images selected, returning null');

        return null;
      }

      print('[IMAGE_LIMIT] ✅ Processing ${pickedMedia.length} selected images');

      return Future.wait(pickedMedia.asMap().entries.map((e) async {
        final index = e.key;
        final media = e.value;

        // Enhanced error handling for Android content URIs
        Uint8List? mediaBytes;
        try {
          print('[IMAGE_LIMIT] 📖 Reading bytes from: ${media.path}');
          mediaBytes = await media.readAsBytes();
          print('[IMAGE_LIMIT] ✅ Successfully read ${mediaBytes.length} bytes');
        } catch (e) {
          print('[IMAGE_LIMIT] ❌ Failed to read bytes from ${media.path}: $e');
          // Skip this image if we can't read it
          return null;
        }

        // Skip if no bytes were read
        if (mediaBytes.isEmpty) {
          print(
              '[IMAGE_LIMIT] ⚠️ Skipping image with empty bytes: ${media.path}');
          return null;
        }

        final path =
            _getStoragePath(storageFolderPath, media.name, false, index);
        final dimensions = includeDimensions
            ? isVideo
                ? _getVideoDimensions(media.path)
                : _getImageDimensions(mediaBytes)
            : null;

        return SelectedFile(
          storagePath: path,
          filePath: media.path,
          bytes: mediaBytes,
          dimensions: await dimensions,
        );
      })).then((results) => results
          .where((result) => result != null)
          .cast<SelectedFile>()
          .toList());
    }

    final source = mediaSource == MediaSource.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    final pickedMediaFuture = isVideo
        ? picker.pickVideo(source: source)
        : picker.pickImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            source: source,
          );

    final pickedMedia = await pickedMediaFuture;

    final mediaBytes = await pickedMedia?.readAsBytes();

    if (mediaBytes == null) {
      return null;
    }

    final path = _getStoragePath(storageFolderPath, pickedMedia!.name, isVideo);

    final dimensions = includeDimensions
        ? isVideo
            ? _getVideoDimensions(pickedMedia.path)
            : _getImageDimensions(mediaBytes)
        : null;

    return [
      SelectedFile(
        storagePath: path,
        filePath: pickedMedia.path,
        bytes: mediaBytes,
        dimensions: await dimensions,
      ),
    ];
  } catch (e) {
    print('🔴🔴🔴🔴🔴 Exception While Picking Images $e');

    return null;
  }
}

bool validateFileFormat(String filePath, BuildContext context) {
  if (allowedFormats.contains(mime(filePath))) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Invalid file format: ${mime(filePath)}'),
    ));
  return false;
}

Future<SelectedFile?> selectFile({
  String? storageFolderPath,
  List<String>? allowedExtensions,
}) =>
    selectFiles(
      storageFolderPath: storageFolderPath,
      allowedExtensions: allowedExtensions,
      multiFile: false,
    ).then((value) => value?.first);

Future<List<SelectedFile>?> selectFiles({
  String? storageFolderPath,
  List<String>? allowedExtensions,
  bool multiFile = false,
}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(
    type: allowedExtensions != null ? FileType.custom : FileType.any,
    allowedExtensions: allowedExtensions,
    withData: true,
    allowMultiple: multiFile,
  );
  if (pickedFiles == null || pickedFiles.files.isEmpty) {
    return null;
  }
  if (multiFile) {
    return Future.wait(pickedFiles.files.asMap().entries.map((e) async {
      final index = e.key;
      final file = e.value;
      final storagePath =
          _getStoragePath(storageFolderPath, file.name, false, index);
      return SelectedFile(
        storagePath: storagePath,
        filePath: isWeb ? null : file.path,
        bytes: file.bytes!,
      );
    }));
  }
  final file = pickedFiles.files.first;
  if (file.bytes == null) {
    return null;
  }
  final storagePath = _getStoragePath(storageFolderPath, file.name, false);
  return [
    SelectedFile(
      storagePath: storagePath,
      filePath: isWeb ? null : file.path,
      bytes: file.bytes!,
    )
  ];
}

List<SelectedFile> selectedFilesFromUploadedFiles(
  List<FFUploadedFile> uploadedFiles, {
  String? storageFolderPath,
  bool isMultiData = false,
}) =>
    uploadedFiles.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final file = entry.value;
        return SelectedFile(
            storagePath: _getStoragePath(
              storageFolderPath != null ? storageFolderPath : null,
              file.name!,
              false,
              isMultiData ? index : null,
            ),
            bytes: file.bytes!);
      },
    ).toList();

Future<MediaDimensions> _getImageDimensions(Uint8List mediaBytes) async {
  final image = await decodeImageFromList(mediaBytes);
  return MediaDimensions(
    width: image.width.toDouble(),
    height: image.height.toDouble(),
  );
}

Future<MediaDimensions> _getVideoDimensions(String path) async {
  final VideoPlayerController videoPlayerController =
      VideoPlayerController.asset(path);
  await videoPlayerController.initialize();
  final size = videoPlayerController.value.size;
  return MediaDimensions(width: size.width, height: size.height);
}

String _getStoragePath(
  String? pathPrefix,
  String filePath,
  bool isVideo, [
  int? index,
]) {
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  // Workaround fixed by https://github.com/flutter/plugins/pull/3685
  // (not yet in stable).
  final ext = isVideo ? 'mp4' : filePath.split('.').last;
  final indexStr = index != null ? '_$index' : '';
  return '$pathPrefix/$timestamp$indexStr.$ext';
}

String getSignatureStoragePath([String? pathPrefix]) {
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  return '$pathPrefix/signature_$timestamp.png';
}

void showUploadMessage(
  BuildContext context,
  String message, {
  bool showLoading = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(
                  valueColor: Theme.of(context).brightness == Brightness.dark
                      ? AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).accent4)
                      : null,
                ),
              ),
            Text(message),
          ],
        ),
        duration: showLoading ? Duration(days: 1) : Duration(seconds: 4),
      ),
    );
}

String? _removeTrailingSlash(String? path) => path != null && path.endsWith('/')
    ? path.substring(0, path.length - 1)
    : path;
