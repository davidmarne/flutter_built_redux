# flutter_built_redux

## Original Code
[davidmarne/flutter-built_redux](https://github.com/davidmarne/flutter_built_redux)

## Modifications

### StoreConnector and StoreConnections calls init
You can override the `init` function to bind listeners you may need.

Example Code:
```dart
/// Note that you must add AppBuilder too.
class AppScreen extends StoreConnector<App, AppBuilder, AppActions, App> {
  /// Connects the state we need in this screen.
  @override
  App connect(App state) => state;

  /// Initializes necessary listeners for this screen.
  @override
  void init(BuildContext context, Store<App, AppBuilder, AppActions> store) {
    // You can use the store to bind listeners and context to interact with the widget.
    store.stream.listen((change) {});
  }

  /// Build this screen.
  @override
  Widget build(BuildContext context, App state, AppActions actions) {
    return Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
    );
  }
}
```

## Notes
I'm maintaining this repository for personal use. When and if those changes are merged in the default repository, I will remove this repository. If you want to use it for production, I recommend you to fork it.
