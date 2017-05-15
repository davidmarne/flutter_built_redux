[![Pub](https://img.shields.io/pub/v/flutter_built_redux.svg)](https://pub.dartlang.org/packages/flutter_built_redux)

# flutter_built_redux

[built_redux] bindings for Flutter.

By creating a StatefulWidget that extends StoreConnector/StoreConnectorState you get automatic subscribing to your redux store, and you component will only call setState when the store triggers and the values you take from the store in connect change!

### Why you may need flutter_built_redux
For the same reason you would want to use redux with react.

from the flutter tutorial:

> In Flutter, change notifications flow “up” the widget hierarchy by way of callbacks, while current state flows “down” to the stateless widgets that do presentation.

Following this pattern requires you to send any state or state mutator callbacks that are common between your widgets down from some common ancestor.

With larger applications this is very tedious, leads to large widget constructors, and this pattern causes flutter to rerun the build function on all widgets between the ancestor that contains the state and the widget that actually cares about it. It also means your business logic and network requests live in your widget declarations.

[built_redux] gives you a predicable state container that can live outside your widgets and perform logic in action middleware.

flutter_built_redux lets a widget to subscribe to the pieces of the redux state tree that it cares about. It also lets lets widgets dispatch actions to mutate the redux state tree. This means widgets can access and mutate application state without the state and state mutator callbacks being passed down from its ancestors!

### Consuming

Wrap your top-level flutter widget with ReduxProvider
```
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

Declare the properties from your state you want this widget to subscribe to by
creating a new built value.
```
abstract class MyWidgetProps implements Built<MyWidgetProps, MyWidgetPropsBuilder> {
  String get propIWantFromMyReduxState;

  // Built value boilerplate
  MyWidgetProps._();
  factory MyWidgetProps([updates(MyWidgetPropsBuilder b)]) => _$MyWidgetProps;
}

// first 3 generics are the redux store value, builder and actions, while the last
// two are the subscribed values value and builder.
class MyWidget extends StoreConnector<MyReduxState, MyReduxStateBuilder, MyReduxStateActions,
    MyWidgetProps, MyWidgetPropsBuilder> {
  MyWidget({Key key}) : super(key: key);


  // connect is the function that returns an object containing the properties from
  // your store that this component cares about. It requires that you return a
  // built_value to ensure your props has a valid == override so setState
  // is only called if the properties this component cares about change.
  @override
  MyWidgetProps connect(Store<MyReduxState, MyReduxStateBuilder, MyReduxStateActions> store) =>
      new MyWidgetProps((b) => b..propIWantFromMyReduxState = store.state.someProperty)

  MyWidgetState createState() => new MyWidgetState();
}

class MyWidgetState extends StoreConnectorState<MyReduxState, MyReduxStateBuilder,
    MyReduxStateActions, MyWidgetProps, MyWidgetPropsBuilder> {

  // by extending StoreConnectorState you inherit a state property. In this case
  // it would be of type MyWidgetProps.
  //
  // you also inherit an actions property, which is of type MyReduxStateActions

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(state.propIWantFromMyReduxState),
    );
  }
```

[built_redux]: https://github.com/davidmarne/built_redux
