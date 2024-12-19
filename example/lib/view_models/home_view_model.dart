import 'dart:developer';

import 'package:clover/clover.dart';

/// The home view model.
class HomeViewModel extends ViewModel {
  final String _title;
  int _count;

  HomeViewModel()
      : _title = 'Home View',
        _count = 0;

  /// Get the title.
  String get title => _title;

  /// Get the count listenable.
  int get count => _count;

  /// Increase the count.
  void increase() {
    _count++;
    notifyListeners();
  }

  /// Decrease the count.
  void decrease() {
    _count--;
    notifyListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('didChangeDependencies');
  }

  @override
  void activate() {
    super.activate();
    log('activate');
  }

  @override
  void deactivate() {
    super.deactivate();
    log('deactivate');
  }

  @override
  void reassemble() {
    super.reassemble();
    log('reassemble');
  }

  @override
  void dispose() {
    log('dispose');
    super.dispose();
  }
}
