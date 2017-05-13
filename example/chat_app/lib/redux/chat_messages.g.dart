// GENERATED CODE - DO NOT MODIFY BY HAND

part of chat_messages;

// **************************************************************************
// Generator: BuiltReduxGenerator
// Target: abstract class ChatMessagesActions
// **************************************************************************

class _$ChatMessagesActions extends ChatMessagesActions {
  ActionDispatcher<ChatUser> commitCurrentMessageAction =
      new ActionDispatcher<ChatUser>(
          'ChatMessagesActions-commitCurrentMessageAction');

  ActionDispatcher<String> setCurrentMessageAction =
      new ActionDispatcher<String>(
          'ChatMessagesActions-setCurrentMessageAction');
  factory _$ChatMessagesActions() => new _$ChatMessagesActions._();
  _$ChatMessagesActions._() : super._();
  syncWithStore(dispatcher) {
    commitCurrentMessageAction.syncWithStore(dispatcher);
    setCurrentMessageAction.syncWithStore(dispatcher);
  }
}

class ChatMessagesActionsNames {
  static ActionName commitCurrentMessageAction = new ActionName<ChatUser>(
      'ChatMessagesActions-commitCurrentMessageAction');
  static ActionName setCurrentMessageAction =
      new ActionName<String>('ChatMessagesActions-setCurrentMessageAction');
}

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class ChatMessages
// **************************************************************************

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
    final result = _$v ??
        new _$ChatMessages._(
            messages: messages?.build(), currentMessage: currentMessage);
    replace(result);
    return result;
  }
}
