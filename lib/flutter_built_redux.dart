import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

/// [Connect] maps state from the store to the local state that a give
/// component cares about
typedef LocalState Connect<StoreState, LocalState>(StoreState state);

/// [StoreConnectionBuilder] returns a widget given context, local state, and actions
typedef Widget StoreConnectionBuilder<LocalState, Actions extends ReduxActions>(
    BuildContext context, LocalState state, Actions actions);

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
class StoreConnection<
        StoreState extends Built<StoreState, StoreStateBuilder>,
        StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
        Actions extends ReduxActions,
        LocalState>
    extends StoreConnector<StoreState, StoreStateBuilder, Actions, LocalState> {
  final Connect<StoreState, LocalState> _connect;
  final StoreConnectionBuilder<LocalState, Actions> _builder;
  final Function(BuildContext context, Store store) _init;

  StoreConnection({
    @required LocalState connect(StoreState state),
    @required
        Widget builder(BuildContext context, LocalState state, Actions actions),
    void init(BuildContext context, Store store),
    Key key,
  })  : assert(connect != null, 'StoreConnection: connect must not be null'),
        assert(builder != null, 'StoreConnection: builder must not be null'),
        _connect = connect,
        _builder = builder,
        _init = init,
        super(key: key);

  @protected
  LocalState connect(StoreState state) => _connect(state);

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions) =>
      _builder(context, state, actions);

  @override
  void init(BuildContext context,
      Store<StoreState, StoreStateBuilder, Actions> store) {
    _init(context, store);
  }
}

/// [StoreConnector] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result.
/// [StoreState] is the generic type of your built_redux store's state object
/// [Actions] is the generic tyoe of your built_redux store's actions contiainer
/// [LocalState] is the state from your store that this widget needs to render.
/// [LocalState] should be comparable. It is recommended to only use primitive or built types.
abstract class StoreConnector<
    StoreState extends Built<StoreState, StoreStateBuilder>,
    StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
    Actions extends ReduxActions,
    LocalState> extends StatefulWidget {
  StoreConnector({Key key}) : super(key: key);

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  /// It requires that you return a comparable type to ensure your props setState is only called when necessary.
  /// Primitive types, built values, and collections are recommended.
  /// The result of [connect] is what gets passed to the build function's second param
  @protected
  LocalState connect(StoreState state);

  @override
  _StoreConnectorState<StoreState, StoreStateBuilder, Actions, LocalState>
      createState() => new _StoreConnectorState<StoreState, StoreStateBuilder,
          Actions, LocalState>();

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions);

  @protected
  void init(BuildContext context,
      Store<StoreState, StoreStateBuilder, Actions> store) {}
}

class _StoreConnectorState<
        StoreState extends Built<StoreState, StoreStateBuilder>,
        StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
        Actions extends ReduxActions,
        LocalState>
    extends State<
        StoreConnector<StoreState, StoreStateBuilder, Actions, LocalState>> {
  StreamSubscription<SubstateChange<LocalState>> _storeSub;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState _state;

  Store<StoreState, StoreStateBuilder, Actions> get _store {
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

    return reduxProvider.store as Store<StoreState, StoreStateBuilder, Actions>;
  }

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

    // set the initial state
    _state = widget.connect(_store.state as StoreState);

    // calls init so the user can bind his listeners
    widget.init(context, _store);

    // listen to changes
    _storeSub = _store
        .substateStream((state) => widget.connect(state as StoreState))
        .listen((change) {
      setState(() {
        _state = change.next;
      });
    });
  }

  /// Cancels the store subscription.
  @override
  @mustCallSuper
  void dispose() {
    _storeSub.cancel();
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
