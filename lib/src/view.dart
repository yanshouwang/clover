import 'package:flutter/widgets.dart' hide View;

import 'view_model.dart';

abstract class View<TViewModel extends ViewModel> extends StatefulWidget {
  const View({super.key});

  @override
  ViewState createState();
  @protected
  @factory
  TViewModel createViewModel();
}

abstract class ViewState<TView extends View<TViewModel>,
    TViewModel extends ViewModel> extends State<TView> {
  late final TViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.createViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
