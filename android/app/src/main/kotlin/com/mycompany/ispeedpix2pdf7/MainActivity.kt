package com.mycompany.ispeedpix2pdf7

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mycompany.ispeedpix2pdf7/file" // The method channel name
    private val NATIVE_PICKER_CHANNEL = "com.ispeedpix2pdf.native_picker" // Native picker channel
    private val IMAGE_PICKER_REQUEST_CODE = 1001

    private var imagePickerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up native image picker method channel
        MethodChannel(flutterEngine.dartExecutor, NATIVE_PICKER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickMultipleImages" -> {
                    val limit = call.argument<Int>("limit") ?: 60
                    val androidVersion = call.argument<Int>("androidVersion") ?: Build.VERSION.SDK_INT

                    Log.d("ImagePicker", "Android version: $androidVersion, Limit: $limit")

                    pickMultipleImages(limit, androidVersion, result)
                }
                "readContentUri" -> {
                    val uri = call.argument<String>("uri")
                    if (uri != null) {
                        readContentUriBytes(uri, result)
                    } else {
                        result.error("INVALID_URI", "URI parameter is null", null)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Make sure to call the method channel from FlutterEngine
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            // Check if the method being called is 'shareFile'
            if (call.method == "shareFile") {
                // Get the filePath argument passed from Flutter
                val filePath = call.argument<String>("filePath")

                if (filePath != null) {
                    // Call the function to share the file if the path is provided
                    shareFile(filePath)
                    result.success("File shared successfully")
                } else {
                    // If filePath is missing, return an error
                    result.error("INVALID_ARGUMENT", "File path is missing", null)
                }
            } else {
                // If the method is not recognized, indicate that it isn't implemented
                result.notImplemented()
            }
        }
    }

    private fun shareFile(filePath: String) {
        // Create a File object from the file path
        val file = File(filePath)

        // Get the URI for the file using FileProvider
        val uri: Uri = FileProvider.getUriForFile(
                this, "com.mycompany.ispeedpix2pdf7.fileprovider", file
        )

        // Extract the file name
        val fileName = file.name

        // Create an intent to share the file
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "application/pdf" // MIME type for PDFs
            putExtra(Intent.EXTRA_STREAM, uri) // Attach the file URI
            putExtra(Intent.EXTRA_SUBJECT, fileName) // Set the subject as the file name
            putExtra(Intent.EXTRA_TEXT, "Here's the PDF: $fileName") // Optional message
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // Grant permission to read the URI
        }

        // Start the activity to choose the sharing app
        startActivity(Intent.createChooser(intent, "Share $fileName"))
    }

    private fun pickMultipleImages(limit: Int, androidVersion: Int, result: MethodChannel.Result) {
        imagePickerResult = result

        Log.d("ImagePicker", "Creating intent for Android version: $androidVersion with limit: $limit")

        val intent = if (androidVersion >= Build.VERSION_CODES.KITKAT) {
            // Android 4.4+ (API 19+) to API 32 - Use ACTION_GET_CONTENT
            Log.d("ImagePicker", "Using ACTION_GET_CONTENT (Android 4.4+ to API 32)")
            Intent(Intent.ACTION_GET_CONTENT).apply {
                type = "image/*"
                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                // Note: EXTRA_PICK_IMAGES_MAX not available on older versions
            }
        } else {
            // Very old Android versions - Basic picker
            Log.d("ImagePicker", "Using ACTION_PICK (older Android)")
            Intent(Intent.ACTION_PICK).apply {
                type = "image/*"
                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            }
        }

        try {
            Log.d("ImagePicker", "Starting activity for result")
            startActivityForResult(intent, IMAGE_PICKER_REQUEST_CODE)
        } catch (e: Exception) {
            Log.e("ImagePicker", "Failed to open image picker", e)
            result.error("PICKER_ERROR", "Failed to launch image picker: ${e.message}", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == IMAGE_PICKER_REQUEST_CODE) {
            handleImagePickerResult(resultCode, data)
        }
    }

    private fun handleImagePickerResult(resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK && data != null) {
            val imagePaths = mutableListOf<String>()

            if (data.clipData != null) {
                // Multiple images selected
                val clipData = data.clipData!!
                for (i in 0 until clipData.itemCount) {
                    val uri = clipData.getItemAt(i).uri
                    // Grant persistent URI permission for Photo Picker URIs
                    try {
                        contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    } catch (e: SecurityException) {
                        // Permission might not be needed or already granted
                    }
                    imagePaths.add(uri.toString())
                }
            } else if (data.data != null) {
                // Single image selected
                val uri = data.data!!
                // Grant persistent URI permission for Photo Picker URIs
                try {
                    contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
                } catch (e: SecurityException) {
                    // Permission might not be needed or already granted
                }
                imagePaths.add(uri.toString())
            }

            imagePickerResult?.success(imagePaths)
        } else {
            imagePickerResult?.success(emptyList<String>())
        }

        imagePickerResult = null
    }

    private fun readContentUriBytes(uriString: String, result: MethodChannel.Result) {
        try {
            val uri = Uri.parse(uriString)
            val inputStream = contentResolver.openInputStream(uri)

            if (inputStream != null) {
                val bytes = inputStream.readBytes()
                inputStream.close()
                result.success(bytes)
            } else {
                result.error("READ_ERROR", "Could not open input stream for URI: $uriString", null)
            }
        } catch (e: Exception) {
            result.error("READ_ERROR", "Failed to read content URI: ${e.message}", null)
        }
    }
}
