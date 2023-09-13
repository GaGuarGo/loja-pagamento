import 'package:flutter/material.dart';

class PageManager {
  // ignore: prefer_final_fields
  PageController _pageController;

  PageManager(this._pageController);

  int page = 0;

  void setPage(int page) {
    if (this.page == page) return;
    this.page = page;
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }
}
