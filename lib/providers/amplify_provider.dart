import 'dart:io';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../amplifyconfiguration.dart';

final amplifyProvider = ChangeNotifierProvider((ref) => AmplifyProvider());
final AmplifyProvider amplifyProviderVar = AmplifyProvider();

class AmplifyProvider extends ChangeNotifier {
  bool isAmplifyConfigured = false;
  bool isFinishUpload = true;
  double uploadingValue = 0.0;

  initAmplifyFlutter() async {
    AmplifyAuthCognito auth = AmplifyAuthCognito();
    AmplifyStorageS3 storage = AmplifyStorageS3();
    AmplifyAnalyticsPinpoint analytics = AmplifyAnalyticsPinpoint();

    Amplify.addPlugins([auth, storage, analytics]);

    // Initialize AmplifyFlutter
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }

    isAmplifyConfigured = true;
    notifyListeners();
  }

  Future<String> upload() async {
    try {
      isFinishUpload = false;
      notifyListeners();
      // Uploading the file with options
      FilePickerResult? pickResult =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickResult == null) {
        print('User canceled upload.');
        isFinishUpload = true;
        notifyListeners();
        return "";
      }

      File local = File(pickResult.files.single.path!);
      final key = DateTime.now().toString();
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'filename';
      metadata['desc'] = 'A test file';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);

      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key,
          local: local,
          options: options,
          onProgress: (progress) {
            print("PROGRESS: " + progress.getFractionCompleted().toString());
            if (progress.getFractionCompleted() > 0.0 &&
                progress.getFractionCompleted() < 1) {
              uploadingValue = progress.getFractionCompleted();
              isFinishUpload = false;
              notifyListeners();
            } else {
              uploadingValue = 0.0;
              isFinishUpload = true;
              notifyListeners();
            }
          });

      return getUrl(result.key);
    } catch (e) {
      return "";
      print('UploadFile Err: ' + e.toString());
    }
  }

  Future<String> getUrl(uploadFileKey) async {
    try {
      print('In getUrl');
      String key = uploadFileKey;
      S3GetUrlOptions options = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.guest, expires: 604800);
      GetUrlResult result =
          await Amplify.Storage.getUrl(key: key, options: options);
      return result.url;
      notifyListeners();
    } catch (e) {
      return "";
      print('GetUrl Err: ' + e.toString());
    }
  }

  Future<bool> remove(fileToRemove) async {
    try {
      print('In remove');
      String key = fileToRemove;
      RemoveOptions options =
          RemoveOptions(accessLevel: StorageAccessLevel.guest);
      RemoveResult result =
          await Amplify.Storage.remove(key: key, options: options);

      // removeResult = result.key;
      // notifyListeners();
      // print('_removeResult:' + _removeResult);
      return true;
    } catch (e) {
      print('Remove Err: ' + e.toString());
      return false;
    }
  }
}
