/// A base ViewModel used for reuse functions at the lowest layer.
abstract class BaseViewModel {}

/// A base provider used for create and hold an instance of [T].
abstract class ViewModelProvider<T extends BaseViewModel> {
  /// Get the instance of [T].
  T get viewModel;

  /// Create [T].
  ///
  /// Returns an instance of [T].
  T createViewModel();
}
