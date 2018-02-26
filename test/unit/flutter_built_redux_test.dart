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
    });
  });
}
