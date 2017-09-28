// GENERATED CODE - DO NOT MODIFY BY HAND

part of chat_messages;

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

class _$ChatMessages extends ChatMessages {
  @override
  final BuiltList<ChatMessage> messages;
  @override
  final String currentMessage;
  bool __isComposing;

  factory _$ChatMessages([void updates(ChatMessagesBuilder b)]) =>
      (new ChatMessagesBuilder()..update(updates)).build();

  _$ChatMessages._({this.messages, this.currentMessage}) : super._() {
    if (messages == null) throw new ArgumentError.notNull('messages');
    if (currentMessage == null)
      throw new ArgumentError.notNull('currentMessage');
  }

  @override
  bool get isComposing => __isComposing ??= super.isComposing;

  @override
  ChatMessages rebuild(void updates(ChatMessagesBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessagesBuilder toBuilder() => new ChatMessagesBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! ChatMessages) return false;
    return messages == other.messages && currentMessage == other.currentMessage;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, messages.hashCode), currentMessage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatMessages')
          ..add('messages', messages)
          ..add('currentMessage', currentMessage))
        .toString();
  }
}

class ChatMessagesBuilder
    implements Builder<ChatMessages, ChatMessagesBuilder> {
  _$ChatMessages _$v;

  ListBuilder<ChatMessage> _messages;
  ListBuilder<ChatMessage> get messages =>
      _$this._messages ??= new ListBuilder<ChatMessage>();
  set messages(ListBuilder<ChatMessage> messages) =>
      _$this._messages = messages;

  String _currentMessage;
  String get currentMessage => _$this._currentMessage;
  set currentMessage(String currentMessage) =>
      _$this._currentMessage = currentMessage;

  ChatMessagesBuilder();

  ChatMessagesBuilder get _$this {
    if (_$v != null) {
      _messages = _$v.messages?.toBuilder();
      _currentMessage = _$v.currentMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessages other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$ChatMessages;
  }

  @override
  void update(void updates(ChatMessagesBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatMessages build() {
    final _$result = _$v ??
        new _$ChatMessages._(
            messages: messages?.build(), currentMessage: currentMessage);
    replace(_$result);
    return _$result;
  }
}

// **************************************************************************
// Generator: BuiltReduxGenerator
// **************************************************************************

class _$ChatMessagesActions extends ChatMessagesActions {
  final ActionDispatcher<ChatUser> commitCurrentMessageAction =
      new ActionDispatcher<ChatUser>(
          'ChatMessagesActions-commitCurrentMessageAction');

  final ActionDispatcher<String> setCurrentMessageAction =
      new ActionDispatcher<String>(
          'ChatMessagesActions-setCurrentMessageAction');
  factory _$ChatMessagesActions() => new _$ChatMessagesActions._();

  _$ChatMessagesActions._() : super._();

  @override
  void setDispatcher(Dispatcher dispatcher) {
    commitCurrentMessageAction.setDispatcher(dispatcher);
    setCurrentMessageAction.setDispatcher(dispatcher);
  }
}

class ChatMessagesActionsNames {
  static final ActionName<ChatUser> commitCurrentMessageAction =
      new ActionName<ChatUser>(
          'ChatMessagesActions-commitCurrentMessageAction');
  static final ActionName<String> setCurrentMessageAction =
      new ActionName<String>('ChatMessagesActions-setCurrentMessageAction');
}
