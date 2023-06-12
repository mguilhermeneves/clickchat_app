import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clickchat_app/src/global/services/auth_service.dart';
import 'package:clickchat_app/src/global/services/storage_service.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';

class ProfileController {
  final StorageService _storageService;
  final AuthService _authService;
  final signOutLoading = ValueNotifier<bool>(false);
  final profilePictureUrl = ValueNotifier<String?>(null);

  User? get user => _authService.user;

  ProfileController(this._storageService, this._authService);

  Future<void> init() async {
    if (profilePictureUrl.value != null) return;

    var pictureResult = await _storageService.getProfilePicture(user?.uid);

    if (pictureResult.succeeded) {
      profilePictureUrl.value = pictureResult.data;
    } else {
      App.dialog.alert(pictureResult.error!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    signOutLoading.value = true;

    await _authService.signOut(context);

    signOutLoading.value = false;
  }

  Future<void> pickPicture(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(source: source);
    if (file == null) return;

    final resultUpload =
        await _storageService.uploadProfilePicture(file.path, user?.uid);

    App.to.pop();

    if (resultUpload.succeeded) {
      profilePictureUrl.value = resultUpload.data;
    } else {
      App.dialog.alert(resultUpload.error!);
    }
  }

  Future<void> deletePicture() async {
    var resultDelete = await _storageService.deleteProfilePicture(user?.uid);

    App.to.pop();

    if (resultDelete.succeeded) {
      profilePictureUrl.value = null;
    } else {
      App.dialog.alert(resultDelete.error!);
    }
  }
}
