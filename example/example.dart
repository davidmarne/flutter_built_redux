library example;

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder, ActionDispatcher;
import 'package:flutter_built_redux/flutter_built_redux.dart';

part 'example.g.dart';

void main() {
  // create the store
  final store = Store(
    reducerBuilder.build(),
    Counter(),
    CounterActions(),
  );

  runApp(ConnectionExample(store));
  // or comment the line above and uncomment the line below
  // runApp(ConnectorExample(store));
}

/// an example using `StoreConnection`
class ConnectionExample extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ConnectionExample(this.store);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'flutter_built_redux_test',
        home: ReduxProvider(
          store: store,
          child: StoreConnection<Counter, CounterActions, int>(
            connect: (state) => state.count,
            builder: (BuildContext context, int count, CounterActions actions) {
              return Scaffold(
                body: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => actions.increment(null),
                      child: Text('Increment'),
                    ),
                    Text('Count: $count'),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

/// an example using a widget that implements `StoreConnector`
class ConnectorExample extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ConnectorExample(this.store);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_built_redux_test',
      home: ReduxProvider(
        store: store,
        child: CounterWidget(),
      ),
    );
  }
}

/// [CounterWidget] impelments [StoreConnector] manually
class CounterWidget extends StoreConnector<Counter, CounterActions, int> {
  CounterWidget();

  @override
  int connect(Counter state) => state.count;

  @override
  Widget build(BuildContext context, int count, CounterActions actions) =>
      Scaffold(
        body: Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => actions.increment(null),
              child: Text('Increment'),
            ),
            Text('Count: $count'),
          ],
        ),
      );
}

// Built redux counter state, actions, and reducer

ReducerBuilder<Counter, CounterBuilder> reducerBuilder =
    ReducerBuilder<Counter, CounterBuilder>()
      ..add(CounterActionsNames.increment, (s, a, b) => b.count++);

abstract class CounterActions extends ReduxActions {
  factory CounterActions() => _$CounterActions();
  CounterActions._();

  ActionDispatcher<Null> get increment;
}

abstract class Counter implements Built<Counter, CounterBuilder> {
  factory Counter() => _$Counter._(count: 0);
  Counter._();

  int get count;
}
