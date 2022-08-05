import 'package:clover/clover.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clover_test.mocks.dart';

@GenerateMocks([StatelessViewModel, StatefulViewModel])
void main() {
  testWidgets(
    'StatelessView creates and holds an instance of StatelessViewModel',
    (tester) async {
      final viewModel = MockStatelessViewModel();
      final view = MockStatelessView(
        builder: () => viewModel,
      );
      expect(view.viewModel, viewModel);
    },
  );

  testWidgets(
    'StatefulView creates and holds an instance of StatefulViewModel',
    (tester) async {
      final viewModel = MockStatefulViewModel();
      final view = MockStatefulView(builder: () => viewModel);
      await tester.pumpWidget(view);
      final finder = find.byType(MockStatefulView);
      final state = tester.state<_MockStatefulViewState>(finder);
      expect(state.viewModel, viewModel);
    },
  );

  testWidgets(
    'StatefulViewModel dispose is called when state dispose',
    (tester) async {
      final viewModel = MockStatefulViewModel();
      final widget = Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          onGenerateRoute: (settings) {
            final name = settings.name;
            if (name == '/') {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Container();
                },
              );
            } else if (name == '/stateful_view') {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MockStatefulView(builder: () => viewModel);
                },
              );
            } else {
              return null;
            }
          },
          initialRoute: '/stateful_view',
        ),
      );
      await tester.pumpWidget(widget);
      final viewFinder = find.byType(MockStatefulView);
      final state = tester.state<_MockStatefulViewState>(viewFinder);
      expect(state.viewModel, viewModel);
      final navigatorFinder = find.byType(Navigator);
      final navigatorState = tester.state<NavigatorState>(navigatorFinder);
      navigatorState.pushReplacementNamed('/');
      await tester.pumpAndSettle();
      verify(viewModel.dispose()).called(1);
    },
  );
}

class MockStatelessView extends StatelessView<MockStatelessViewModel> {
  MockStatelessView({
    Key? key,
    required ViewModelBuilder<MockStatelessViewModel> builder,
  }) : super(key: key, builder: builder);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MockStatefulView extends StatefulView<MockStatefulViewModel> {
  const MockStatefulView({
    Key? key,
    required ViewModelBuilder<MockStatefulViewModel> builder,
  }) : super(key: key, builder: builder);

  @override
  ViewModelState<MockStatefulView, MockStatefulViewModel> createState() =>
      _MockStatefulViewState();
}

class _MockStatefulViewState
    extends ViewModelState<MockStatefulView, MockStatefulViewModel> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
