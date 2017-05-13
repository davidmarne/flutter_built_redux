# flutter_built_redux

Built_redux provider for Flutter.
By creating a StatefulWidget that extends StoreConnector/StoreConnectorState
you get automatic subscribing to your redux store, and you component will only
rerender when the store triggers and the values you take from the store in connect
change!

### Consuming

Wrap your top-level flutter widget with InheritedStore
```
class MyProviderWidget extends StatelessWidget {
  final store = new Store<MyReduxState, MyReduxStateBuilder, MyReduxStateActions>(
    new MyReduxState(),
    new MyReduxStateActions(),
  );

  @override
  Widget build(BuildContext context) {
    return new InheritedStore(
      store: store,
      child: new MyWidget(),
    );
  }
}
```

Declare the properties from your state you want this widget to subscribe to by
creating a new built value.
```
abstract class MyWidgetProps implements Built<MyReduxState, MyReduxStateBuilder> {
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
