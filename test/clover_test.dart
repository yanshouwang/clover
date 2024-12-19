import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clover_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ViewModel>(),
])
void main() {
  testWidgets(
    'Creates and holds an instance of ViewModel',
    (tester) async {
      final widget = ViewModelBinding(
        viewBuilder: () => Builder(
          builder: (context) {
            final viewModel = ViewModel.of<MockViewModel>(context);
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text('${viewModel.runtimeType}'),
            );
          },
        ),
        viewModelBuilder: () => MockViewModel(),
      );
      await tester.pumpWidget(widget);
      final viewFinder = find.byType(Text);
      final view = tester.widget<Text>(viewFinder);
      expect(view.data, 'MockViewModel');
    },
  );

  testWidgets(
    'ViewModel is disposed with state',
    (tester) async {
      final viewModel = MockViewModel();
      final widget = Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          onGenerateRoute: (settings) {
            final name = settings.name;
            if (name == '/') {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const Placeholder();
                },
              );
            } else if (name == '/view') {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ViewModelBinding(
                    viewBuilder: () => const Placeholder(),
                    viewModelBuilder: () => viewModel,
                  );
                },
              );
            } else {
              return null;
            }
          },
          initialRoute: '/view',
        ),
      );
      await tester.pumpWidget(widget);
      final navigatorFinder = find.byType(Navigator);
      final navigatorState = tester.state<NavigatorState>(navigatorFinder);
      navigatorState.pushReplacementNamed('/');
      await tester.pumpAndSettle();
      verify(viewModel.dispose()).called(1);
    },
  );
}
