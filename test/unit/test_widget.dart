import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import 'test_models.dart';

final providerKey = Key('providerKey');
final counterKey = Key('counterKey');
final incrementTextKey = Key('incrementTextKey');
final incrementButtonKey = Key('incrementButtonKey');
final incrementOtherButtonKey = Key('incrementOtherButtonKey');

class ProviderWidgetConnector extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions>? store;

  ProviderWidgetConnector(this.store) : super(key: providerKey);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'flutter_built_redux_test',
        home: ReduxProvider(
          store: store,
          child: CounterWidget(),
        ),
      );
}

// ignore: must_be_immutable
class ProviderWidgetConnection extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions>? store;
  int numBuilds = 0;

  ProviderWidgetConnection(this.store) : super(key: providerKey);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'flutter_built_redux_test',
        home: ReduxProvider(
          store: store,
          child: StoreConnection<Counter, CounterActions, int?>(
            connect: (state) => state.count,
            key: counterKey,
            builder: (BuildContext context, int? count, CounterActions actions) {
              numBuilds++;
              return Scaffold(
                body: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => actions.increment(null),
                      child: Text('Increment'),
                      key: incrementButtonKey,
                    ),
                    ElevatedButton(
                      onPressed: () => actions.incrementOther(null),
                      child: Text('Increment Other'),
                      key: incrementOtherButtonKey,
                    ),
                    Text(
                      'Count: $count',
                      key: incrementTextKey,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

// ignore: must_be_immutable
class CounterWidget extends StoreConnector<Counter, CounterActions, int?> {
  // the number of times this component has been rebuild
  // used to test that we don't update after updating state
  // the connect function does not consume
  int numBuilds = 0;

  CounterWidget() : super(key: counterKey);

  @override
  int? connect(Counter state) {
    return state.count;
  }

  @override
  Widget build(BuildContext context, int? count, CounterActions actions) {
    numBuilds++;
    return Scaffold(
      body: Row(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => actions.increment(null),
            child: Text('Increment'),
            key: incrementButtonKey,
          ),
          ElevatedButton(
            onPressed: () => actions.incrementOther(null),
            child: Text('Increment Other'),
            key: incrementOtherButtonKey,
          ),
          Text(
            'Count: $count',
            key: incrementTextKey,
          ),
        ],
      ),
    );
  }
}
