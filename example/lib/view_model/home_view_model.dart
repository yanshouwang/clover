import 'package:clover/clover.dart';
import 'package:flutter/foundation.dart';

/// A base ViewModel used for home.
abstract class HomeViewModel extends ViewModel {
  /// Get the title.
  String get title;

  /// Get the count listenable.
  ValueListenable<int> get count;

  /// Increase the count.
  void increase();

  /// Decrease the count.
  void decrease();

  /// Create an instance of [HomeViewModel]
  factory HomeViewModel() => _HomeViewModel();
}

class _HomeViewModel extends ViewModel implements HomeViewModel {
  @override
  final String title;
  @override
  final ValueNotifier<int> count;

  _HomeViewModel()
      : title = 'Clover Demo Home Page',
        count = ValueNotifier(0);

  @override
  void increase() {
    count.value++;
  }

  @override
  void decrease() {
    count.value--;
  }

  @override
  void dispose() {
    super.dispose();
    count.dispose();
  }
}
