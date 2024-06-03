import 'package:flutter/widgets.dart';

import 'view_model.dart';

/// Signature for a function that creates a view.
typedef ViewBuilder<T extends Widget> = T Function(BuildContext context);

/// Signature for a function that creates a view model.
typedef ViewModelBuilder<T extends ViewModel> = T Function(
    BuildContext context);

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
    _viewModel = widget.viewModelBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedViewModel<TViewModel>(
      view: widget.viewBuilder(context),
      viewModel: _viewModel,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
