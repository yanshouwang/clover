import 'package:clover/clover.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clover_test.mocks.dart';
import 'util.dart';

@GenerateMocks([StatelessViewModel, StatefulViewModel])
void main() {
  testWidgets(
    'StatelessViewModelProvider creates and holds an instance of StatelessViewModel',
    (tester) async {
      final widget = MockStatelessView();
      expect(widget.viewModel, isInstanceOf<MockStatelessViewModel>());
      expect(widget.viewModel, widget.viewModel);
    },
  );

  testWidgets(
    'StatefulViewModelProvider creates and holds an instance of StatefulViewModel',
    (tester) async {
      const widget = MockStatefulView();
      await tester.pumpWidget(widget);
      final finder = find.byType(MockStatefulView);
      final state = tester.state<_MockStatefulViewState>(finder);
      expect(state.viewModel, isInstanceOf<MockStatefulViewModel>());
      expect(state.viewModel, state.viewModel);
    },
  );

  testWidgets(
    'StatefulViewModel dispose is called when state dispose',
    (tester) async {
      final tapKey = GlobalKey();
      final widget = VisibilityChanger(
        tapKey: tapKey,
        child: const MockStatefulView(),
      );
      await tester.pumpWidget(widget);
      final finder = find.byType(MockStatefulView);
      final state = tester.state<_MockStatefulViewState>(finder);
      final tapFinder = find.byKey(tapKey);
      await tester.tap(tapFinder);
      await tester.pump();
      verify(state.viewModel.dispose()).called(1);
    },
  );
}

class MockStatelessView extends StatelessWidget
    with StatelessViewModelProvider<MockStatelessViewModel> {
  MockStatelessView({Key? key}) : super(key: key);

  @override
  createViewModel() {
    return MockStatelessViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MockStatefulView extends StatefulWidget {
  const MockStatefulView({Key? key}) : super(key: key);

  @override
  State<MockStatefulView> createState() => _MockStatefulViewState();
}

class _MockStatefulViewState extends State<MockStatefulView>
    with StatefulViewModelProvider<MockStatefulView, MockStatefulViewModel> {
  @override
  MockStatefulViewModel createViewModel() {
    return MockStatefulViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
