import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:built_redux/built_redux.dart';

/// [Connect] maps state from the store to the local state that a give
/// component cares about
typedef LocalState Connect<StoreState, LocalState>(StoreState state);

/// [StoreConnectionBuilder] returns a widget given context, local state, and actions
typedef Widget StoreConnectionBuilder<LocalState, Actions extends ReduxActions>(
    BuildContext context, LocalState state, Actions actions);

/// Called once right before building the widget.
/// Your state will be the result of [StoreConnector.connect].
/// You can safely use context in this callback.
/// Perfect to fetch data/dispatch action.
typedef OnInitCallback<LocalState, Actions extends ReduxActions> = void
    Function(
  LocalState state,
  Actions actions,
);

/// Will be called after your Widget has been built for the first time.
/// Your state will be the result of [StoreConnector.connect].
/// This callback is useful for certain animations, showing dialogs or snackbars
/// after your layout has been built
typedef OnAfterFirstBuildCallback<LocalState, Actions extends ReduxActions>
    = void Function(
  LocalState state,
  Actions actions,
);

/// Will be called every time the state has been changed and the widget has been rebuilt.
typedef OnDidChangeCallback<LocalState, Actions extends ReduxActions> = void
    Function(
  LocalState state,
  Actions actions,
);

/// Clean up some data or dispatch an action.
/// This is called in [State.dispose] before the widget is removed from the
/// Widget tree
typedef OnDisposeCallback<Actions extends ReduxActions> = void Function(
    Actions actions);

/// [StoreConnection] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result. It is an implementation
/// of `StoreConnector` that takes a connect function and builder function as parameters
/// so `StoreConnector` doesn't have to be implemented manually.
///
/// [connect] takes the current state of the redux store and retuns an object that contains
/// the subset of the redux state tree that this component cares about.
/// It requires that you return a comparable type to ensure your props setState is only called when necessary.
/// Primitive types, built values, and collections are recommended.
/// The result of [connect] is what gets passed to the build function's second param
///
/// [builder] is a function that takes a `BuildContext`, the `LocalState` returned from
/// connect, and your `ReduxActions` class and returns a widget.
///
/// [StoreState] is the generic type of your built_redux store's state object
/// [Actions] is the generic tyoe of your built_redux store's actions contiainer
/// [LocalState] is the state from your store that this widget needs to render.
/// [LocalState] should be comparable. It is recommended to only use primitive or built types.
class StoreConnection<StoreState, Actions extends ReduxActions, LocalState>
    extends StoreConnector<StoreState, Actions, LocalState> {
  final Connect<StoreState, LocalState> _connect;
  final StoreConnectionBuilder<LocalState, Actions> _builder;
  final OnInitCallback<LocalState, Actions> _onInit;
  final OnDisposeCallback<Actions> _onDispose;
  final OnAfterFirstBuildCallback<LocalState, Actions> _onAfterFirstBuild;
  final OnDidChangeCallback<LocalState, Actions> _onDidChange;

  StoreConnection({
    @required LocalState connect(StoreState state),
    @required
        Widget builder(BuildContext context, LocalState state, Actions actions),
    OnInitCallback<LocalState, Actions> onInit,
    OnDisposeCallback<Actions> onDispose,
    OnAfterFirstBuildCallback<LocalState, Actions> onAfterFirstBuild,
    OnDidChangeCallback<LocalState, Actions> onDidChange,
    Key key,
  })  : assert(connect != null, 'StoreConnection: connect must not be null'),
        assert(builder != null, 'StoreConnection: builder must not be null'),
        _connect = connect,
        _builder = builder,
        _onInit = onInit,
        _onDispose = onDispose,
        _onAfterFirstBuild = onAfterFirstBuild,
        _onDidChange = onDidChange,
        super(key: key);

  @protected
  @override
  void onInit(LocalState state, Actions actions) {
    if (null != _onInit) {
      _onInit(state, actions);
    }
  }

  @protected
  @override
  void onDispose(Actions actions) {
    if (null != _onDispose) {
      _onDispose(actions);
    }
  }

  @protected
  @override
  void onAfterFirstBuild(LocalState state, Actions actions) {
    if (null != _onAfterFirstBuild) {
      _onAfterFirstBuild(state, actions);
    }
  }

  @protected
  @override
  void onDidChange(LocalState state, Actions actions) {
    if (null != _onDidChange) {
      _onDidChange(state, actions);
    }
  }

  @protected
  LocalState connect(StoreState state) => _connect(state);

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions) =>
      _builder(context, state, actions);
}

/// [StoreConnector] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result.
/// [StoreState] is the generic type of your built_redux store's state object
/// [Actions] is the generic tyoe of your built_redux store's actions contiainer
/// [LocalState] is the state from your store that this widget needs to render.
/// [LocalState] should be comparable. It is recommended to only use primitive or built types.
abstract class StoreConnector<StoreState, Actions extends ReduxActions,
    LocalState> extends StatefulWidget {
  StoreConnector({Key key}) : super(key: key);

  @protected
  void onInit(LocalState state, Actions actions) {}

  @protected
  void onDispose(Actions actions) {}

  @protected
  void onAfterFirstBuild(LocalState state, Actions actions) {}

  @protected
  void onDidChange(LocalState state, Actions actions) {}

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  /// It requires that you return a comparable type to ensure your props setState is only called when necessary.
  /// Primitive types, built values, and collections are recommended.
  /// The result of [connect] is what gets passed to the build function's second param
  @protected
  LocalState connect(StoreState state);

  @override
  _StoreConnectorState<StoreState, Actions, LocalState> createState() =>
      new _StoreConnectorState<StoreState, Actions, LocalState>();

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions);
}

class _StoreConnectorState<StoreState, Actions extends ReduxActions, LocalState>
    extends State<StoreConnector<StoreState, Actions, LocalState>> {
  StreamSubscription<SubstateChange<LocalState>> _storeSub;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState _state;

  Store _store;

  /// sets up a subscription to the store
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if the store has already been subscribed to return early. didChangeDependencies
    // will be called every time the dependencies of the widget change, but we only
    // want to subscribe to the store the first time it is called. Subscriptions are setup
    // in didChangeDependencies, rather than initState, because inheritFromWidgetOfExactType
    // cannot be called before initState completes.
    // See https://github.com/flutter/flutter/blob/0.0.20/packages/flutter/lib/src/widgets/framework.dart#L3721
    if (_storeSub != null) return;

    // get the store from the ReduxProvider ancestor
    final ReduxProvider reduxProvider =
        context.inheritFromWidgetOfExactType(ReduxProvider);

    // if it is not found raise an error
    assert(reduxProvider != null,
        'Store was not found, make sure ReduxProvider is an ancestor of this component.');

    assert(reduxProvider.store.state is StoreState,
        'Store found was not the correct type, make sure StoreConnector\'s generic for StoreState matches the state type of your built_redux store.');

    assert(reduxProvider.store.actions is Actions,
        'Store found was not the correct type, make sure StoreConnector\'s generic for Actions matches the actions type of your built_redux store.');

    _store = reduxProvider.store;

    // set the initial state
    _state = widget.connect(_store.state as StoreState);

    widget.onInit(_state, _store.actions as Actions);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAfterFirstBuild(_state, _store.actions as Actions);
    });

    // listen to changes
    _storeSub = _store
        .substateStream((state) => widget.connect(state as StoreState))
        .listen((change) {
      setState(() {
        _state = change.next;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDidChange(_state, _store.actions as Actions);
      });
    });
  }

  /// Cancels the store subscription.
  @override
  @mustCallSuper
  void dispose() {
    _storeSub.cancel();
    widget.onDispose(_store.actions as Actions);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.build(context, _state, _store.actions as Actions);
}

/// [ReduxProvider] provides access to the redux store to descendant widgets.
/// [ReduxProvider] must be an ancesestor of a `StoreConnector`, otherwise the
/// `StoreConnector` will throw during initialization.
class ReduxProvider extends InheritedWidget {
  ReduxProvider({Key key, @required this.store, @required Widget child})
      : super(key: key, child: child);

  /// [store] is a reference to the redux store
  final Store store;

  @override
  bool updateShouldNotify(ReduxProvider old) => store != old.store;
}
