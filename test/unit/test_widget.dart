import 'package:built_redux/built_redux.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter/material.dart';

import 'test_models.dart';

final providerKey = new Key('providerKey');
final providerOtherKey = new Key('providerOtherKey ');
final counterKey = new Key('counterKey');
final incrementTextKey = new Key('incrementTextKey');
final incrementButtonKey = new Key('incrementButtonKey');
final incrementOtherButtonKey = new Key('incrementOtherButtonKey');

class ProviderWidgetConnector extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ProviderWidgetConnector(this.store) : super(key: providerKey);

  @override
  Widget build(BuildContext context) => new MaterialApp(
        title: 'flutter_built_redux_test',
        home: new ReduxProvider(
          store: store,
          child: new CounterWidget(),
        ),
      );
}

// ignore: must_be_immutable
class ProviderWidgetConnection extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;
  int numBuilds = 0;

  ProviderWidgetConnection(this.store) : super(key: providerKey);

  @override
  Widget build(BuildContext context) => new MaterialApp(
        title: 'flutter_built_redux_test',
        home: new ReduxProvider(
          store: store,
          child: new StoreConnection<Counter, CounterActions, int>(
            connect: (state) => state.count,
            key: counterKey,
            builder: (BuildContext context, int count, CounterActions actions) {
              numBuilds++;
              return new Scaffold(
                body: new Row(
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: actions.increment,
                      child: new Text('Increment'),
                      key: incrementButtonKey,
                    ),
                    new RaisedButton(
                      onPressed: actions.incrementOther,
                      child: new Text('Increment Other'),
                      key: incrementOtherButtonKey,
                    ),
                    new Text(
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
class CounterWidget extends StoreConnector<Counter, CounterActions, int> {
  // the number of times this component has been rebuild
  // used to test that we don't update after updating state
  // the connect function does not consume
  int numBuilds = 0;

  CounterWidget() : super(key: counterKey);

  @override
  int connect(Counter state) {
    return state.count;
  }

  @override
  Widget build(BuildContext context, int count, CounterActions actions) {
    numBuilds++;
    return new Scaffold(
      body: new Row(
        children: <Widget>[
          new RaisedButton(
            onPressed: actions.increment,
            child: new Text('Increment'),
            key: incrementButtonKey,
          ),
          new RaisedButton(
            onPressed: actions.incrementOther,
            child: new Text('Increment Other'),
            key: incrementOtherButtonKey,
          ),
          new Text(
            'Count: $count',
            key: incrementTextKey,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ProviderCallbackWidgetConnection extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;
  int onInitCount = 0;
  int onDisposeCount = 0;
  int onAfterFirstBuildCount = 0;
  int onDidChangeCount = 0;
  int onDidChangeState;

  ProviderCallbackWidgetConnection(this.store, [Key key])
      : super(key: key ?? providerKey);

  @override
  Widget build(BuildContext context) => new MaterialApp(
        title: 'flutter_built_redux_test',
        home: new ReduxProvider(
          store: store,
          child: new StoreConnection<Counter, CounterActions, int>(
            onInit: (state, actions) {
              onInitCount++;
            },
            onDispose: (actions) {
              onDisposeCount++;
            },
            onAfterFirstBuild: (state, actions) {
              onAfterFirstBuildCount++;
            },
            onDidChange: (state, actions) {
              onDidChangeState = state;
              onDidChangeCount++;
            },
            connect: (state) => state.count,
            key: counterKey,
            builder: (BuildContext context, int count, CounterActions actions) {
              return new Scaffold(
                body: new Row(
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: actions.increment,
                      child: new Text('Increment'),
                      key: incrementButtonKey,
                    ),
                    new RaisedButton(
                      onPressed: actions.incrementOther,
                      child: new Text('Increment Other'),
                      key: incrementOtherButtonKey,
                    ),
                    new Text(
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

class ProviderCallbackWidgetConnector extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ProviderCallbackWidgetConnector(this.store, [Key key])
      : super(key: key ?? providerKey);

  @override
  Widget build(BuildContext context) => new MaterialApp(
        title: 'flutter_built_redux_test',
        home: new ReduxProvider(
          store: store,
          child: new CounterCallbackWidget(),
        ),
      );
}

// ignore: must_be_immutable
class CounterCallbackWidget extends CounterWidget {
  int onInitCount = 0;
  int onDisposeCount = 0;
  int onAfterFirstBuildCount = 0;
  int onDidChangeCount = 0;
  int onDidChangeState;

  CounterCallbackWidget() : super();

  @override
  void onInit(int state, CounterActions actions) {
    onInitCount++;
  }

  @override
  void onDispose(actions) {
    onDisposeCount++;
  }

  @override
  void onAfterFirstBuild(int state, CounterActions actions) {
    onAfterFirstBuildCount++;
  }

  @override
  void onDidChange(int state, CounterActions actions) {
    onDidChangeState = state;
    onDidChangeCount++;
  }
}
