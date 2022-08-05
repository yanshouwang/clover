import 'package:flutter/widgets.dart';

import 'stateless_view_model.dart';
import 'view_model.dart';

abstract class StatelessView<TViewModel extends StatelessViewModel>
    extends StatelessWidget {
  final TViewModel viewModel;

  StatelessView({Key? key, required ViewModelBuilder<TViewModel> builder})
      : viewModel = builder(),
        super(key: key);
}
