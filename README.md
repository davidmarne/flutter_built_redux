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

## Consuming

Wrap your top-level flutter widget with ReduxProvider

```dart
class MyProviderWidget extends StatelessWidget {
  final store = new Store<MyReduxState, MyReduxStateBuilder, MyReduxStateActions>(
    new MyReduxState(),
    new MyReduxStateActions(),
  );

  @override
  Widget build(BuildContext context) {
    return new ReduxProvider(
      store: store,
      child: new MyWidget(),
    );
  }
}
```

Write a widget that extends StoreConnector.
Declare the properties from your state you want this widget to subscribe to by
creating a implementing connect & implement the build method.

```dart

// first 3 generics are the redux store value, builder and actions, while the last
// one is the local state's value.
class MyWidget extends StoreConnector<MyReduxState, MyReduxStateBuilder, MyReduxStateActions, String> {
  MyWidget({Key key}) : super(key: key);


  // connect is the function that returns an object containing the data from
  // your store that this component cares about. It requires that you return a
  // comparable type to ensure your props setState is only called when necessary.
  // Primitive types, built values, and collections are recommended.
  // The result of connect is what gets passed to your build function's second param
  @override
  MyWidgetProps connect(MyReduxState state) => state.someProperty;

  @override
  Widget build(BuildContext context, MyWidgetProps props, MyReduxStateActions action) {
    return new Center(
      child: new Text(state.someProperty),
    );
  }
```

[built_redux]: https://github.com/davidmarne/built_redux

[todo_mvc]: https://gitlab.com/brianegan/flutter_architecture_samples/tree/master/example/built_redux

[Brian Egan]: https://gitlab.com/brianegan
