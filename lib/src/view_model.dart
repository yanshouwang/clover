import 'package:flutter/widgets.dart';

/// A base view model used for reuse functions at the lowest layer.
abstract class ViewModel extends ChangeNotifier {
  /// Get the closest [ViewModel] instance with type [T] from the given context.
  static T of<T extends ViewModel>(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedViewModel<T>>()!
      .viewModel;
}

/// An inherited widget for a [ViewModel], which updates its dependencies when
/// the [viewModel] is triggered.
class InheritedViewModel<T extends ViewModel> extends StatelessWidget {
  /// The view.
  final Widget view;

  /// The viewModel.
  final T viewModel;

  /// Create an inherited widget that updates its dependents when [viewModel]
  /// sends notifications.
  const InheritedViewModel({
    super.key,
    required this.view,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _InheritedViewModel<T>(
      viewModel: viewModel,
      child: view,
    );
  }
}

class _InheritedViewModel<T extends ViewModel> extends InheritedNotifier<T> {
  const _InheritedViewModel({
    super.key,
    required T viewModel,
    required super.child,
  }) : super(notifier: viewModel);

  T get viewModel => notifier!;
}
