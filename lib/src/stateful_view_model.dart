import 'package:clover/src/base_view_model.dart';
import 'package:flutter/widgets.dart';

/// A base ViewModel used for [StatefulWidget]
abstract class StatefulViewModel extends BaseViewModel {
  /// Called when this object is removed from the tree permanently.
  void dispose() {}
}

/// A provider used for create and hold an instance of [TViewModel]
mixin StatefulViewModelProvider<TWidget extends StatefulWidget,
        TViewModel extends StatefulViewModel> on State<TWidget>
    implements ViewModelProvider<TViewModel> {
  @override
  late final TViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = createViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
