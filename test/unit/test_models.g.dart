// GENERATED CODE - DO NOT MODIFY BY HAND

part of test_models;

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides

class _$CounterActions extends CounterActions {
  factory _$CounterActions() => new _$CounterActions._();
  _$CounterActions._() : super._();

  final ActionDispatcher<Null> increment =
      new ActionDispatcher<Null>('CounterActions-increment');
  final ActionDispatcher<Null> incrementOther =
      new ActionDispatcher<Null>('CounterActions-incrementOther');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    increment.setDispatcher(dispatcher);
    incrementOther.setDispatcher(dispatcher);
  }
}

class CounterActionsNames {
  static final ActionName<Null> increment =
      new ActionName<Null>('CounterActions-increment');
  static final ActionName<Null> incrementOther =
      new ActionName<Null>('CounterActions-incrementOther');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new

class _$Counter extends Counter {
  @override
  final int count;
  @override
  final int other;

  factory _$Counter([void updates(CounterBuilder b)]) =>
      (new CounterBuilder()..update(updates)).build();

  _$Counter._({this.count, this.other}) : super._() {
    if (count == null) throw new BuiltValueNullFieldError('Counter', 'count');
    if (other == null) throw new BuiltValueNullFieldError('Counter', 'other');
  }

  @override
  Counter rebuild(void updates(CounterBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBuilder toBuilder() => new CounterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Counter && count == other.count && other == other.other;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, count.hashCode), other.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Counter')
          ..add('count', count)
          ..add('other', other))
        .toString();
  }
}

class CounterBuilder implements Builder<Counter, CounterBuilder> {
  _$Counter _$v;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  int _other;
  int get other => _$this._other;
  set other(int other) => _$this._other = other;

  CounterBuilder();

  CounterBuilder get _$this {
    if (_$v != null) {
      _count = _$v.count;
      _other = _$v.other;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Counter other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$Counter;
  }

  @override
  void update(void updates(CounterBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Counter build() {
    final _$result = _$v ?? new _$Counter._(count: count, other: other);
    replace(_$result);
    return _$result;
  }
}
