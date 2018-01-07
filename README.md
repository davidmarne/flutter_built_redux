[![Pub](https://img.shields.io/pub/v/flutter_built_redux.svg)](https://pub.dartlang.org/packages/flutter_built_redux)
[![codecov.io](http://codecov.io/github/davidmarne/flutter_built_redux/coverage.svg?branch=master)](http://codecov.io/github/davidmarne/flutter_built_redux?branch=master)

# flutter_built_redux

[built_redux] bindings for Flutter.

By creating a Widget that extends StoreConnector you get automatic subscribing to your redux store, and you component will only call setState when the store triggers and the values you take from the store in connect change!

## Examples

[todo_mvc], written by [Brian Egan]

## Why you may need flutter_built_redux

For the same reason you would want to use redux with react.

from the flutter tutorial:

> In Flutter, change notifications flow “up” the widget hierarchy by way of callbacks, while current state flows “down” to the stateless widgets that do presentation.

Following this pattern requires you to send any state or state mutator callbacks that are common between your widgets down from some common ancestor.

With larger applications this is very tedious, leads to large widget constructors, and this pattern causes flutter to rerun the build function on all widgets between the ancestor that contains the state and the widget that actually cares about it. It also means your business logic and network requests live in your widget declarations.

[built_redux] gives you a predicable state container that can live outside your widgets and perform logic in action middleware.

flutter_built_redux lets a widget to subscribe to the pieces of the redux state tree that it cares about. It also lets lets widgets dispatch actions to mutate the redux state tree. This means widgets can access and mutate application state without the state and state mutator callbacks being passed down from its ancestors!

## Consuming - Simple Counter Example

Wrap your top-level flutter widget with ReduxProvider. This provides
all child widgets with access to the store.

```dart
class ProviderWidget extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ProviderWidget(this.store);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'flutter_built_redux - Counter Example',
      home: new ReduxProvider(
        store: store,
        child: new CounterWidget(),
      ),
    );
  }
}
```

Write a widget that extends StoreConnector.
Declare the properties from your state you want this widget to subscribe to by
implementing the connect & build methods. In this case
we are subscribing to the count property from the Counter built_value

```dart

// first 3 generics are the redux store value, builder and actions, while the last
// one is the local state's value.
class CounterWidget extends StoreConnector<Counter, CounterActions, int> {
  CounterWidget({Key key}) : super(key: key);

  @override
  int connect(Counter state) => state.count;

  @override
  Widget build(BuildContext context, int count, CounterActions actions) {
    return new Scaffold(
      body: new Row(
        children: <Widget>[
          new RaisedButton(
            onPressed: actions.increment, // dispatches a built_redux action
            child: new Text('Increment'),
          ),
          new Text('Count: $count'), // renders the count value from the built_redux store
        ],
      ),
    );
  }
}
```

For context, the redux store in this example may look like:

```dart
Store<Counter, CounterBuilder, CounterActions> createStore() => new Store(
      createReducer(),
      new Counter(),
      new CounterActions(),
    );

Reducer<Counter, CounterBuilder, dynamic> createReducer() =>
    (new ReducerBuilder<Counter, CounterBuilder>()
          ..add(CounterActionsNames.increment, (s, a, b) => b.count++).build();

abstract class CounterActions extends ReduxActions {
  factory CounterActions() => new _$CounterActions();
  CounterActions._();

  ActionDispatcher<Null> get increment;
}

abstract class Counter implements Built<Counter, CounterBuilder> {
  factory Counter() => new _$Counter._(count: 0);
  Counter._();

  int get count;
}

```

[built_redux]: https://github.com/davidmarne/built_redux

[todo_mvc]: https://gitlab.com/brianegan/flutter_architecture_samples/tree/master/example/built_redux

[Brian Egan]: https://gitlab.com/brianegan
