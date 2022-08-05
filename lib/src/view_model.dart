/// A base ViewModel used for reuse functions at the lowest layer.
abstract class ViewModel {}

typedef ViewModelBuilder<T extends ViewModel> = T Function();
