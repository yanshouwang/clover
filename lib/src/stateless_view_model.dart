import 'package:clover/src/base_view_model.dart';
import 'package:flutter/widgets.dart';

/// A base ViewModel used for [StatelessWidget]
abstract class StatelessViewModel extends BaseViewModel {}

/// A provider used for create and hold an instance of [T].
mixin StatelessViewModelProvider<T extends StatelessViewModel>
    on StatelessWidget implements ViewModelProvider<T> {
  @override
  late final viewModel = createViewModel();
}
