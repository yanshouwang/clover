import 'package:flutter/widgets.dart';

import 'view_model.dart';

/// A base ViewModel used for [StatefulWidget]
abstract class StatefulViewModel extends ViewModel {
  /// Called when this object is removed from the tree permanently.
  void dispose() {}
}
