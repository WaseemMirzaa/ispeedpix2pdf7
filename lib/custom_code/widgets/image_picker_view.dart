// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_picker/file_picker.dart';

// LoadingWithTextWidget class
class LoadingWithTextWidget extends StatelessWidget {
  final String text;

  const LoadingWithTextWidget(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              text,
            )
          ],
        ),
      );
}

// ImagePickerView class
class ImagePickerView extends StatefulWidget {
  const ImagePickerView({
    super.key,
    this.width,
    this.height,
    this.maxFiles = 5, // Limit the number of files
    this.onFilesPicked,
    this.onFileRemoved,
  });

  final double? width;
  final double? height;
  final int maxFiles; // Maximum number of files allowed
  final Future Function(List<FFUploadedFile>? pickedFiles)? onFilesPicked;
  final Future Function(String? removedFile)? onFileRemoved;

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  bool _isPicking = false;

  List<Uint8List?> pickedFiles = [];
  List<String?> fileNames = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 500,
      height: widget.height ?? 500,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Color(0xFFd9dde1),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: _pickFiles,
                    child: Visibility(
                      visible: (pickedFiles.isEmpty && !_isPicking),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            'Click here to pick images',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'PNG or JPG\n Upload images for best results.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  pickedFiles.isNotEmpty
                      ? _imageGridView()
                      : const SizedBox.shrink(),
                  _isPicking
                      ? LoadingWithTextWidget('Picking files...')
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          if (!_isPicking && pickedFiles.isNotEmpty) ...[
            SizedBox(
              height: 12,
            ),
            _clearAllButton(),
          ],
        ],
      ),
    );
  }

  Widget _clearAllButton() => TextButton.icon(
        onPressed: () {
          setState(() {
            pickedFiles.clear();
            fileNames.clear();
            print('All files removed');
            widget.onFilesPicked?.call([]);
          });
        },
        icon: Icon(Icons.delete_forever),
        label: Text('Clear All'),
      );

  Future<void> _pickFiles() async {
    if (pickedFiles.length >= widget.maxFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can only select up to ${widget.maxFiles} files.',
          ),
        ),
      );
      return;
    }

    final picked = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      onFileLoading: (v) {
        _onFileLoading(picking: v == FilePickerStatus.picking);
      },
      type: FileType.image,
      withData: true,
    );

    if (picked != null) {
      final newFiles = picked.files
          .where((file) => !fileNames.contains(file.name))
          .take(widget.maxFiles - pickedFiles.length)
          .toList();

      setState(() {
        for (var file in newFiles) {
          pickedFiles.add(file.bytes);
          fileNames.add(file.name);
        }

        // Create List of FFUploadedFile objects
        List<FFUploadedFile> uploadedFiles = List.generate(
          newFiles.length,
          (index) => FFUploadedFile(
            name: newFiles[index].name,
            bytes: newFiles[index].bytes,
            height: null, // Set dynamically if available
            width: null, // Set dynamically if available
            blurHash: '', // Optional
          ),
        );

        widget.onFilesPicked?.call(uploadedFiles);
      });

      if (newFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No additional files could be selected.'),
          ),
        );
      }
    }

    _onFileLoading(picking: false);
  }

  _onFileLoading({bool picking = false}) {
    setState(() {
      _isPicking = picking;
    });
  }

  Widget _imageGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: pickedFiles.length,
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.memory(
                pickedFiles[index]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  widget.onFileRemoved?.call(fileNames[index]);
                  pickedFiles.removeAt(index);
                  fileNames.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
