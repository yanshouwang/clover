import 'package:flutter/widgets.dart';

/// Signature for a function that creates a view.
typedef ViewBuilder<T extends Widget> = T Function();

/// Signature for a function that creates a view model.
typedef ViewModelBuilder<T extends ViewModel> = T Function();

/// A base view model used for reuse functions at the lowest layer.
abstract class ViewModel extends ChangeNotifier {
  /// Get the closest [ViewModel] instance with type [T] from the given context.
  static T of<T extends ViewModel>(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedViewModel<T>>()!
      .viewModel;

  BuildContext? _context;

  BuildContext get context {
    assert(() {
      if (_context == null) {
        throw FlutterError(
          'This view has been unmounted, so the State no longer has a context (and should be considered defunct). \n'
          'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.',
        );
      }
      return true;
    }());
    return _context!;
  }

  @visibleForTesting
  set context(BuildContext? value) => _context = value;

  bool get mounted => _context != null;

  @mustCallSuper
  void didChangeDependencies() {}

  @mustCallSuper
  void activate() {}

  @mustCallSuper
  void deactivate() {}

  @mustCallSuper
  void reassemble() {}
}

/// A binding class responsible for creating the [TView] and the [TViewModel],
/// holding the [TViewModel] and updates the [TView] when the [TViewModel] sends
/// notifications.
class ViewModelBinding<TView extends Widget, TViewModel extends ViewModel>
    extends StatefulWidget {
  /// The [TView] builder.
  final ViewBuilder<TView> viewBuilder;

  /// The [TViewModel] builder.
  final ViewModelBuilder<TViewModel> viewModelBuilder;

  /// Create a binding widget with builders of [TView] and [TViewModel] and updates
  /// the [TView] when the [TViewModel] sends notifications.
  const ViewModelBinding({
    super.key,
    required this.viewBuilder,
    required this.viewModelBuilder,
  });

  @override
  State<ViewModelBinding<TView, TViewModel>> createState() =>
      _ViewModelBindingState<TView, TViewModel>();
}

class _ViewModelBindingState<TView extends Widget, TViewModel extends ViewModel>
    extends State<ViewModelBinding<TView, TViewModel>> {
  late final TViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModelBuilder();
    _viewModel.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedViewModel<TViewModel>(
      view: widget.viewBuilder(),
      viewModel: _viewModel,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.didChangeDependencies();
  }

  @override
  void activate() {
    super.activate();
    _viewModel.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
    _viewModel.deactivate();
  }

  @override
  void reassemble() {
    super.reassemble();
    _viewModel.reassemble();
  }

  @override
  void dispose() {
    _viewModel.context = null;
    _viewModel.dispose();
    super.dispose();
  }
}

class _InheritedViewModel<T extends ViewModel> extends InheritedNotifier<T> {
  const _InheritedViewModel({
    super.key,
    required Widget view,
    required T viewModel,
  }) : super(
          notifier: viewModel,
          child: view,
        );

  T get viewModel => notifier!;
}
