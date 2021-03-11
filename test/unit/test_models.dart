library test_models;

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'test_models.g.dart';

Store<Counter, CounterBuilder, CounterActions> createStore() => Store(
      createReducer(),
      Counter(),
      CounterActions(),
    );

Reducer<Counter, CounterBuilder, dynamic> createReducer() =>
    (ReducerBuilder<Counter, CounterBuilder>()
          ..add(CounterActionsNames.increment, (s, a, b) => b.count++)
          ..add(CounterActionsNames.incrementOther, (s, a, b) => b.other++))
        .build();

abstract class CounterActions extends ReduxActions {
  factory CounterActions() => _$CounterActions();
  CounterActions._();

  ActionDispatcher<Null> get increment;
  ActionDispatcher<Null> get incrementOther;
}

abstract class Counter implements Built<Counter, CounterBuilder> {
  factory Counter() => _$Counter._(
        count: 0,
        other: 0,
      );
  Counter._();

  int? get count;
  int? get other;
}
