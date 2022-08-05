import 'package:flutter/widgets.dart';

import 'stateful_view_model.dart';
import 'view_model.dart';

abstract class StatefulView<TViewModel extends StatefulViewModel>
    extends StatefulWidget {
  final ViewModelBuilder<TViewModel> _builder;

  const StatefulView({Key? key, required ViewModelBuilder<TViewModel> builder})
      : _builder = builder,
        super(key: key);

  @override
  ViewModelState<StatefulView, TViewModel> createState();
}

abstract class ViewModelState<TView extends StatefulView,
    TViewModel extends StatefulViewModel> extends State<TView> {
  late TViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget._builder() as TViewModel;
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
