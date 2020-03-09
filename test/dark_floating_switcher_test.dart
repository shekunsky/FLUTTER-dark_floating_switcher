import 'package:flutter_test/flutter_test.dart';
import 'package:dark_floating_switcher/dark_floating_switcher.dart';
import 'package:dark_floating_switcher/dark_floating_switcher_state.dart';

void main() {
  testWidgets('Widget changed his state on tap and callback is executed',
      (WidgetTester tester) async {
    int _callbackCounter = 0;
    DarkFloatingSwitcherState _currentState = DarkFloatingSwitcherState.on;

    // Create the widget by telling the tester to build it.
    DarkFloatingSwitcher _switcher = DarkFloatingSwitcher(
      state: _currentState,
      valueChanged: (state) {
        _currentState = state;
        _callbackCounter++;
      },
    );

    // Build the widget.
    await tester.pumpWidget(_switcher);

    // Tap the switcher while current state is 'ON'.
    await tester.tap(find.byType(DarkFloatingSwitcher));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expect to state changed to 'OFF' and callback executed
    expect(_currentState, DarkFloatingSwitcherState.off);
    expect(_callbackCounter, 1);

    // Tap the switcher while current state is 'OFF'.
    await tester.tap(find.byType(DarkFloatingSwitcher));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expect to state changed to 'ON' and callback executed
    expect(_currentState, DarkFloatingSwitcherState.on);
    expect(_callbackCounter, 2);
  });
}
