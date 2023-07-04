import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/services/notification_service.dart';

import 'global/helpers/app.dart';
import 'global/services/auth_service.dart';

enum AppPageView {
  chats,
  contacts,
  profile,
}

class AppController {
  final NotificationService _notificationService;
  final AuthService auth;
  late ValueNotifier<int> page;
  late PageController pageController;

  AppController(this._notificationService, this.auth);

  void init() {
    page = ValueNotifier<int>(AppPageView.chats.index);
    pageController = PageController(initialPage: page.value);
  }

  void initLate() {
    if (!auth.signedIn) {
      App.to.pushReplacementNamed('/login');
    } else {
      _notificationService.initialize();
    }
  }

  void jumpToPage(AppPageView pageView) {
    page.value = pageView.index;
    pageController.jumpToPage(page.value);
  }
}
