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
  final profilePictureLoading = ValueNotifier<bool>(false);

  String? profilePictureUrl;

  User? get user => _authService.user;

  ProfileController(this._storageService, this._authService);

  void init() {
    if (profilePictureUrl != null) return;

    _getProfilePicture();
  }

  Future<void> signOut(BuildContext context) async {
    signOutLoading.value = true;

    await _authService.signOut(context);

    signOutLoading.value = false;
  }

  Future<void> pickPicture(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (file == null) return;

    App.to.pop();

    profilePictureLoading.value = true;

    final resultUpload =
        await _storageService.uploadProfilePicture(file.path, user?.uid);

    profilePictureLoading.value = false;

    if (resultUpload.succeeded) {
      profilePictureUrl = resultUpload.data;
    } else {
      App.dialog.alert(resultUpload.error!);
    }
  }

  Future<void> deletePicture() async {
    App.to.pop();

    profilePictureLoading.value = true;

    final resultDelete = await _storageService.deleteProfilePicture(user?.uid);

    profilePictureLoading.value = false;

    if (resultDelete.succeeded) {
      profilePictureUrl = null;
    } else {
      App.dialog.alert(resultDelete.error!);
    }
  }

  Future<void> _getProfilePicture() async {
    profilePictureLoading.value = true;

    final pictureResult = await _storageService.getProfilePicture(user?.uid);

    profilePictureLoading.value = false;

    if (pictureResult.succeeded) {
      profilePictureUrl = pictureResult.data;
    } else {
      App.dialog.alert(pictureResult.error!);
    }
  }
}
