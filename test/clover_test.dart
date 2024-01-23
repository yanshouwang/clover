import 'package:clover/clover.dart';
import 'package:flutter/widgets.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clover_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MyViewModel>(),
])
void main() {
  testWidgets(
    'View creates and holds an instance of ViewModel',
    (tester) async {
      final viewModel = MyViewModel();
      final widget = MyView(
        viewModel: viewModel,
      );
      await tester.pumpWidget(widget);
      final viewFinder = find.byType(MyView);
      final state = tester.state<MyViewState>(viewFinder);
      expect(state.viewModel, viewModel);
    },
  );

  testWidgets(
    'ViewModel dispose is called when state dispose',
    (tester) async {
      final viewModel = MockMyViewModel();
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
            } else if (name == '/view') {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MyView(
                    viewModel: viewModel,
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

class MyView extends View<MyViewModel> {
  final MyViewModel viewModel;

  const MyView({
    super.key,
    required this.viewModel,
  });

  @override
  ViewState<MyView, MyViewModel> createState() => MyViewState();
  @override
  MyViewModel createViewModel() => viewModel;
}

class MyViewState extends ViewState<MyView, MyViewModel> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyViewModel extends ViewModel {}
