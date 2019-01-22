import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_models.dart';
import 'test_widget.dart';

void main() {
  Store<Counter, CounterBuilder, CounterActions> store;

  setUp(() {
    store = createStore();
  });

  tearDown(() async {
    await store.dispose();
  });

  group('flutter_built_redux: ', () {
    group('StoreConnector: ', () {
      testWidgets('renders default state correctly',
          (WidgetTester tester) async {
        final providerWidget = new ProviderWidgetConnector(store);

        await tester.pumpWidget(providerWidget);

        CounterWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(counterWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');
      });

      testWidgets('rerenders after increment', (WidgetTester tester) async {
        final widget = new ProviderWidgetConnector(store);

        await tester.pumpWidget(widget);

        CounterWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(counterWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(counterWidget.numBuilds, 2);
        expect(incrementTextWidget.data, 'Count: 1');
      });

      testWidgets('does not rerender after update to other counter',
          (WidgetTester tester) async {
        final widget = new ProviderWidgetConnector(store);

        await tester.pumpWidget(widget);

        CounterWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(counterWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');

        await tester.tap(find.byKey(incrementOtherButtonKey));
        await tester.pump();

        counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        // pump should not cause a rebuild
        expect(counterWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');
      });

      testWidgets('triggers onInit', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnector(store);

        await tester.pumpWidget(providerWidget);

        CounterCallbackWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        expect(counterWidget.onInitCount, 1);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        expect(counterWidget.onInitCount, 1);
      });

      testWidgets('triggers onDispose', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnector(store);
        final providerOtherWidget =
            new ProviderCallbackWidgetConnector(store, providerOtherKey);

        await tester.pumpWidget(providerWidget);

        CounterCallbackWidget counterWidget() => tester.firstWidget(
              find.byKey(counterKey),
            );
        CounterCallbackWidget counterWidget1 = counterWidget();

        expect(counterWidget1.onDisposeCount, 0);

        await tester.pump();

        expect(counterWidget1.onDisposeCount, 0);

        await tester.pumpWidget(providerOtherWidget);

        expect(counterWidget1.onDisposeCount, 1);

        CounterCallbackWidget counterWidget2 = counterWidget();

        expect(counterWidget2.onDisposeCount, 0);

        await tester.pump();

        expect(counterWidget1.onDisposeCount, 1);
        expect(counterWidget2.onDisposeCount, 0);
      });

      testWidgets('triggers onAfterFirstBuild', (WidgetTester tester) async {
        final firstState = store.state;
        final providerWidget = new ProviderCallbackWidgetConnector(store);

        await tester.pumpWidget(providerWidget);

        CounterCallbackWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        expect(counterWidget.onAfterFirstBuildCount, 1);
        expect(firstState, store.state);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        expect(counterWidget.onAfterFirstBuildCount, 1);

        await tester.pumpWidget(providerWidget);
        await tester.tap(find.byKey(incrementButtonKey));

        expect(counterWidget.onAfterFirstBuildCount, 1);
      });

      testWidgets('triggers onDidChange', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnector(store);

        await tester.pumpWidget(providerWidget);

        CounterCallbackWidget counterWidget = tester.firstWidget(
          find.byKey(counterKey),
        );

        expect(counterWidget.onDidChangeCount, 0);
        expect(counterWidget.onDidChangeState, null);

        await tester.pump();
        expect(counterWidget.onDidChangeCount, 0);
        expect(counterWidget.onDidChangeState, null);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();
        expect(counterWidget.onDidChangeCount, 1);
        expect(counterWidget.onDidChangeState, 1);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();
        expect(counterWidget.onDidChangeCount, 2);
        expect(counterWidget.onDidChangeState, 2);
      });
    });

    group('StoreConnection: ', () {
      testWidgets('renders default state correctly',
          (WidgetTester tester) async {
        final providerWidget = new ProviderWidgetConnection(store);

        await tester.pumpWidget(providerWidget);

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(providerWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');
      });

      testWidgets('rerenders after increment', (WidgetTester tester) async {
        final providerWidget = new ProviderWidgetConnection(store);

        await tester.pumpWidget(providerWidget);

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(providerWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(providerWidget.numBuilds, 2);
        expect(incrementTextWidget.data, 'Count: 1');
      });

      testWidgets('does not rerender after update to other counter',
          (WidgetTester tester) async {
        final providerWidget = new ProviderWidgetConnection(store);

        await tester.pumpWidget(providerWidget);

        Text incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        expect(providerWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');

        await tester.tap(find.byKey(incrementOtherButtonKey));
        await tester.pump();

        incrementTextWidget = tester.firstWidget(
          find.byKey(incrementTextKey),
        );

        // pump should not cause a rebuild
        expect(providerWidget.numBuilds, 1);
        expect(incrementTextWidget.data, 'Count: 0');
      });

      testWidgets('triggers onInit', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnection(store);

        await tester.pumpWidget(providerWidget);

        expect(providerWidget.onInitCount, 1);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        expect(providerWidget.onInitCount, 1);
      });

      testWidgets('triggers onDispose', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnection(store);
        final providerOtherWidget =
            new ProviderCallbackWidgetConnection(store, providerOtherKey);

        await tester.pumpWidget(providerWidget);

        expect(providerWidget.onDisposeCount, 0);

        await tester.pump();

        expect(providerWidget.onDisposeCount, 0);
        expect(providerOtherWidget.onDisposeCount, 0);

        await tester.pumpWidget(providerOtherWidget);

        expect(providerWidget.onDisposeCount, 1);
        expect(providerOtherWidget.onDisposeCount, 0);

        await tester.pump();

        expect(providerWidget.onDisposeCount, 1);
      });

      testWidgets('triggers onAfterFirstBuild', (WidgetTester tester) async {
        final firstState = store.state;
        final providerWidget = new ProviderCallbackWidgetConnection(store);
        expect(providerWidget.onAfterFirstBuildCount, 0);
        await tester.pumpWidget(providerWidget);

        expect(providerWidget.onAfterFirstBuildCount, 1);
        expect(firstState, store.state);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();

        expect(providerWidget.onAfterFirstBuildCount, 1);

        await tester.pumpWidget(providerWidget);
        await tester.tap(find.byKey(incrementButtonKey));

        expect(providerWidget.onAfterFirstBuildCount, 1);
      });

      testWidgets('triggers onDidChange', (WidgetTester tester) async {
        final providerWidget = new ProviderCallbackWidgetConnection(store);

        await tester.pumpWidget(providerWidget);

        expect(providerWidget.onDidChangeCount, 0);
        expect(providerWidget.onDidChangeState, null);

        await tester.pump();
        expect(providerWidget.onDidChangeCount, 0);
        expect(providerWidget.onDidChangeState, null);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();
        expect(providerWidget.onDidChangeCount, 1);
        expect(providerWidget.onDidChangeState, 1);

        await tester.tap(find.byKey(incrementButtonKey));
        await tester.pump();
        expect(providerWidget.onDidChangeCount, 2);
        expect(providerWidget.onDidChangeState, 2);
      });
    });
  });
}
