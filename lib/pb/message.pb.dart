///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pbenum.dart';

export 'message.pbenum.dart';

enum TimMessage_Data {
  login, 
  loginAck, 
  serverInfo, 
  upDownMessage, 
  heartBeat, 
  messageAck, 
  hisMessagesReq, 
  hisMessagesAck, 
  notifyMessage, 
  converReq, 
  converAck, 
  notSet
}

class TimMessage extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, TimMessage_Data> _TimMessage_DataByTag = {
    2 : TimMessage_Data.login,
    3 : TimMessage_Data.loginAck,
    4 : TimMessage_Data.serverInfo,
    5 : TimMessage_Data.upDownMessage,
    6 : TimMessage_Data.heartBeat,
    7 : TimMessage_Data.messageAck,
    8 : TimMessage_Data.hisMessagesReq,
    9 : TimMessage_Data.hisMessagesAck,
    10 : TimMessage_Data.notifyMessage,
    11 : TimMessage_Data.converReq,
    12 : TimMessage_Data.converAck,
    0 : TimMessage_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TimMessage', package: const $pb.PackageName('com.tim.common.protos'))
    ..e<TimMessage_Type>(1, 'type', $pb.PbFieldType.OE, TimMessage_Type.Login, TimMessage_Type.valueOf, TimMessage_Type.values)
    ..a<Login>(2, 'login', $pb.PbFieldType.OM, Login.getDefault, Login.create)
    ..a<LoginAck>(3, 'loginAck', $pb.PbFieldType.OM, LoginAck.getDefault, LoginAck.create)
    ..a<ServerInfo>(4, 'serverInfo', $pb.PbFieldType.OM, ServerInfo.getDefault, ServerInfo.create)
    ..a<UpDownMessage>(5, 'upDownMessage', $pb.PbFieldType.OM, UpDownMessage.getDefault, UpDownMessage.create)
    ..a<HeartBeat>(6, 'heartBeat', $pb.PbFieldType.OM, HeartBeat.getDefault, HeartBeat.create)
    ..a<MessageAck>(7, 'messageAck', $pb.PbFieldType.OM, MessageAck.getDefault, MessageAck.create)
    ..a<HisMessagesReq>(8, 'hisMessagesReq', $pb.PbFieldType.OM, HisMessagesReq.getDefault, HisMessagesReq.create)
    ..a<HisMessagesAck>(9, 'hisMessagesAck', $pb.PbFieldType.OM, HisMessagesAck.getDefault, HisMessagesAck.create)
    ..a<NotifyMessage>(10, 'notifyMessage', $pb.PbFieldType.OM, NotifyMessage.getDefault, NotifyMessage.create)
    ..a<ConverReq>(11, 'converReq', $pb.PbFieldType.OM, ConverReq.getDefault, ConverReq.create)
    ..a<ConverAck>(12, 'converAck', $pb.PbFieldType.OM, ConverAck.getDefault, ConverAck.create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..hasRequiredFields = false
  ;

  TimMessage() : super();
  TimMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TimMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TimMessage clone() => TimMessage()..mergeFromMessage(this);
  TimMessage copyWith(void Function(TimMessage) updates) => super.copyWith((message) => updates(message as TimMessage));
  $pb.BuilderInfo get info_ => _i;
  static TimMessage create() => TimMessage();
  TimMessage createEmptyInstance() => create();
  static $pb.PbList<TimMessage> createRepeated() => $pb.PbList<TimMessage>();
  static TimMessage getDefault() => _defaultInstance ??= create()..freeze();
  static TimMessage _defaultInstance;

  TimMessage_Data whichData() => _TimMessage_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  TimMessage_Type get type => $_getN(0);
  set type(TimMessage_Type v) { setField(1, v); }
  $core.bool hasType() => $_has(0);
  void clearType() => clearField(1);

  Login get login => $_getN(1);
  set login(Login v) { setField(2, v); }
  $core.bool hasLogin() => $_has(1);
  void clearLogin() => clearField(2);

  LoginAck get loginAck => $_getN(2);
  set loginAck(LoginAck v) { setField(3, v); }
  $core.bool hasLoginAck() => $_has(2);
  void clearLoginAck() => clearField(3);

  ServerInfo get serverInfo => $_getN(3);
  set serverInfo(ServerInfo v) { setField(4, v); }
  $core.bool hasServerInfo() => $_has(3);
  void clearServerInfo() => clearField(4);

  UpDownMessage get upDownMessage => $_getN(4);
  set upDownMessage(UpDownMessage v) { setField(5, v); }
  $core.bool hasUpDownMessage() => $_has(4);
  void clearUpDownMessage() => clearField(5);

  HeartBeat get heartBeat => $_getN(5);
  set heartBeat(HeartBeat v) { setField(6, v); }
  $core.bool hasHeartBeat() => $_has(5);
  void clearHeartBeat() => clearField(6);

  MessageAck get messageAck => $_getN(6);
  set messageAck(MessageAck v) { setField(7, v); }
  $core.bool hasMessageAck() => $_has(6);
  void clearMessageAck() => clearField(7);

  HisMessagesReq get hisMessagesReq => $_getN(7);
  set hisMessagesReq(HisMessagesReq v) { setField(8, v); }
  $core.bool hasHisMessagesReq() => $_has(7);
  void clearHisMessagesReq() => clearField(8);

  HisMessagesAck get hisMessagesAck => $_getN(8);
  set hisMessagesAck(HisMessagesAck v) { setField(9, v); }
  $core.bool hasHisMessagesAck() => $_has(8);
  void clearHisMessagesAck() => clearField(9);

  NotifyMessage get notifyMessage => $_getN(9);
  set notifyMessage(NotifyMessage v) { setField(10, v); }
  $core.bool hasNotifyMessage() => $_has(9);
  void clearNotifyMessage() => clearField(10);

  ConverReq get converReq => $_getN(10);
  set converReq(ConverReq v) { setField(11, v); }
  $core.bool hasConverReq() => $_has(10);
  void clearConverReq() => clearField(11);

  ConverAck get converAck => $_getN(11);
  set converAck(ConverAck v) { setField(12, v); }
  $core.bool hasConverAck() => $_has(11);
  void clearConverAck() => clearField(12);
}

class Login extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Login', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'uid')
    ..aOS(3, 'token')
    ..hasRequiredFields = false
  ;

  Login() : super();
  Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Login clone() => Login()..mergeFromMessage(this);
  Login copyWith(void Function(Login) updates) => super.copyWith((message) => updates(message as Login));
  $pb.BuilderInfo get info_ => _i;
  static Login create() => Login();
  Login createEmptyInstance() => create();
  static $pb.PbList<Login> createRepeated() => $pb.PbList<Login>();
  static Login getDefault() => _defaultInstance ??= create()..freeze();
  static Login _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get uid => $_getS(1, '');
  set uid($core.String v) { $_setString(1, v); }
  $core.bool hasUid() => $_has(1);
  void clearUid() => clearField(2);

  $core.String get token => $_getS(2, '');
  set token($core.String v) { $_setString(2, v); }
  $core.bool hasToken() => $_has(2);
  void clearToken() => clearField(3);
}

class LoginAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginAck', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<Code>(2, 'code', $pb.PbFieldType.OE, Code.SUCCESS, Code.valueOf, Code.values)
    ..aOS(3, 'msg')
    ..a<Int64>(4, 'time', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  LoginAck() : super();
  LoginAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginAck clone() => LoginAck()..mergeFromMessage(this);
  LoginAck copyWith(void Function(LoginAck) updates) => super.copyWith((message) => updates(message as LoginAck));
  $pb.BuilderInfo get info_ => _i;
  static LoginAck create() => LoginAck();
  LoginAck createEmptyInstance() => create();
  static $pb.PbList<LoginAck> createRepeated() => $pb.PbList<LoginAck>();
  static LoginAck getDefault() => _defaultInstance ??= create()..freeze();
  static LoginAck _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Code get code => $_getN(1);
  set code(Code v) { setField(2, v); }
  $core.bool hasCode() => $_has(1);
  void clearCode() => clearField(2);

  $core.String get msg => $_getS(2, '');
  set msg($core.String v) { $_setString(2, v); }
  $core.bool hasMsg() => $_has(2);
  void clearMsg() => clearField(3);

  Int64 get time => $_getI64(3);
  set time(Int64 v) { $_setInt64(3, v); }
  $core.bool hasTime() => $_has(3);
  void clearTime() => clearField(4);
}

class ServerInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServerInfo', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'ip')
    ..a<$core.int>(3, 'port', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  ServerInfo() : super();
  ServerInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServerInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServerInfo clone() => ServerInfo()..mergeFromMessage(this);
  ServerInfo copyWith(void Function(ServerInfo) updates) => super.copyWith((message) => updates(message as ServerInfo));
  $pb.BuilderInfo get info_ => _i;
  static ServerInfo create() => ServerInfo();
  ServerInfo createEmptyInstance() => create();
  static $pb.PbList<ServerInfo> createRepeated() => $pb.PbList<ServerInfo>();
  static ServerInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ServerInfo _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get ip => $_getS(1, '');
  set ip($core.String v) { $_setString(1, v); }
  $core.bool hasIp() => $_has(1);
  void clearIp() => clearField(2);

  $core.int get port => $_get(2, 0);
  set port($core.int v) { $_setUnsignedInt32(2, v); }
  $core.bool hasPort() => $_has(2);
  void clearPort() => clearField(3);
}

class UpDownMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpDownMessage', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'cid', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(3, 'fromUid')
    ..aOS(4, 'targetUid')
    ..aOS(5, 'groupId')
    ..aOS(6, 'converId')
    ..e<ConverType>(7, 'converType', $pb.PbFieldType.OE, ConverType.SINGLE, ConverType.valueOf, ConverType.values)
    ..a<MessageContent>(9, 'content', $pb.PbFieldType.OM, MessageContent.getDefault, MessageContent.create)
    ..hasRequiredFields = false
  ;

  UpDownMessage() : super();
  UpDownMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpDownMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpDownMessage clone() => UpDownMessage()..mergeFromMessage(this);
  UpDownMessage copyWith(void Function(UpDownMessage) updates) => super.copyWith((message) => updates(message as UpDownMessage));
  $pb.BuilderInfo get info_ => _i;
  static UpDownMessage create() => UpDownMessage();
  UpDownMessage createEmptyInstance() => create();
  static $pb.PbList<UpDownMessage> createRepeated() => $pb.PbList<UpDownMessage>();
  static UpDownMessage getDefault() => _defaultInstance ??= create()..freeze();
  static UpDownMessage _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get cid => $_getI64(1);
  set cid(Int64 v) { $_setInt64(1, v); }
  $core.bool hasCid() => $_has(1);
  void clearCid() => clearField(2);

  $core.String get fromUid => $_getS(2, '');
  set fromUid($core.String v) { $_setString(2, v); }
  $core.bool hasFromUid() => $_has(2);
  void clearFromUid() => clearField(3);

  $core.String get targetUid => $_getS(3, '');
  set targetUid($core.String v) { $_setString(3, v); }
  $core.bool hasTargetUid() => $_has(3);
  void clearTargetUid() => clearField(4);

  $core.String get groupId => $_getS(4, '');
  set groupId($core.String v) { $_setString(4, v); }
  $core.bool hasGroupId() => $_has(4);
  void clearGroupId() => clearField(5);

  $core.String get converId => $_getS(5, '');
  set converId($core.String v) { $_setString(5, v); }
  $core.bool hasConverId() => $_has(5);
  void clearConverId() => clearField(6);

  ConverType get converType => $_getN(6);
  set converType(ConverType v) { setField(7, v); }
  $core.bool hasConverType() => $_has(6);
  void clearConverType() => clearField(7);

  MessageContent get content => $_getN(7);
  set content(MessageContent v) { setField(9, v); }
  $core.bool hasContent() => $_has(7);
  void clearContent() => clearField(9);
}

class HeartBeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HeartBeat', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<HeartBeatType>(2, 'heartBeatType', $pb.PbFieldType.OE, HeartBeatType.PING, HeartBeatType.valueOf, HeartBeatType.values)
    ..hasRequiredFields = false
  ;

  HeartBeat() : super();
  HeartBeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HeartBeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HeartBeat clone() => HeartBeat()..mergeFromMessage(this);
  HeartBeat copyWith(void Function(HeartBeat) updates) => super.copyWith((message) => updates(message as HeartBeat));
  $pb.BuilderInfo get info_ => _i;
  static HeartBeat create() => HeartBeat();
  HeartBeat createEmptyInstance() => create();
  static $pb.PbList<HeartBeat> createRepeated() => $pb.PbList<HeartBeat>();
  static HeartBeat getDefault() => _defaultInstance ??= create()..freeze();
  static HeartBeat _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  HeartBeatType get heartBeatType => $_getN(1);
  set heartBeatType(HeartBeatType v) { setField(2, v); }
  $core.bool hasHeartBeatType() => $_has(1);
  void clearHeartBeatType() => clearField(2);
}

class MessageAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MessageAck', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<Int64>(2, 'cid', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(3, 'targetUid')
    ..aOS(4, 'converId')
    ..a<Int64>(5, 'time', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<Code>(6, 'code', $pb.PbFieldType.OE, Code.SUCCESS, Code.valueOf, Code.values)
    ..hasRequiredFields = false
  ;

  MessageAck() : super();
  MessageAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageAck clone() => MessageAck()..mergeFromMessage(this);
  MessageAck copyWith(void Function(MessageAck) updates) => super.copyWith((message) => updates(message as MessageAck));
  $pb.BuilderInfo get info_ => _i;
  static MessageAck create() => MessageAck();
  MessageAck createEmptyInstance() => create();
  static $pb.PbList<MessageAck> createRepeated() => $pb.PbList<MessageAck>();
  static MessageAck getDefault() => _defaultInstance ??= create()..freeze();
  static MessageAck _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get cid => $_getI64(1);
  set cid(Int64 v) { $_setInt64(1, v); }
  $core.bool hasCid() => $_has(1);
  void clearCid() => clearField(2);

  $core.String get targetUid => $_getS(2, '');
  set targetUid($core.String v) { $_setString(2, v); }
  $core.bool hasTargetUid() => $_has(2);
  void clearTargetUid() => clearField(3);

  $core.String get converId => $_getS(3, '');
  set converId($core.String v) { $_setString(3, v); }
  $core.bool hasConverId() => $_has(3);
  void clearConverId() => clearField(4);

  Int64 get time => $_getI64(4);
  set time(Int64 v) { $_setInt64(4, v); }
  $core.bool hasTime() => $_has(4);
  void clearTime() => clearField(5);

  Code get code => $_getN(5);
  set code(Code v) { setField(6, v); }
  $core.bool hasCode() => $_has(5);
  void clearCode() => clearField(6);
}

class MessageContent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MessageContent', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'uid')
    ..e<MessageType>(3, 'type', $pb.PbFieldType.OE, MessageType.TEXT, MessageType.valueOf, MessageType.values)
    ..aOS(4, 'content')
    ..a<Int64>(5, 'time', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  MessageContent() : super();
  MessageContent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageContent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageContent clone() => MessageContent()..mergeFromMessage(this);
  MessageContent copyWith(void Function(MessageContent) updates) => super.copyWith((message) => updates(message as MessageContent));
  $pb.BuilderInfo get info_ => _i;
  static MessageContent create() => MessageContent();
  MessageContent createEmptyInstance() => create();
  static $pb.PbList<MessageContent> createRepeated() => $pb.PbList<MessageContent>();
  static MessageContent getDefault() => _defaultInstance ??= create()..freeze();
  static MessageContent _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get uid => $_getS(1, '');
  set uid($core.String v) { $_setString(1, v); }
  $core.bool hasUid() => $_has(1);
  void clearUid() => clearField(2);

  MessageType get type => $_getN(2);
  set type(MessageType v) { setField(3, v); }
  $core.bool hasType() => $_has(2);
  void clearType() => clearField(3);

  $core.String get content => $_getS(3, '');
  set content($core.String v) { $_setString(3, v); }
  $core.bool hasContent() => $_has(3);
  void clearContent() => clearField(4);

  Int64 get time => $_getI64(4);
  set time(Int64 v) { $_setInt64(4, v); }
  $core.bool hasTime() => $_has(4);
  void clearTime() => clearField(5);
}

class HisMessagesReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HisMessagesReq', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'converId')
    ..a<Int64>(3, 'beaginTime', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  HisMessagesReq() : super();
  HisMessagesReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HisMessagesReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HisMessagesReq clone() => HisMessagesReq()..mergeFromMessage(this);
  HisMessagesReq copyWith(void Function(HisMessagesReq) updates) => super.copyWith((message) => updates(message as HisMessagesReq));
  $pb.BuilderInfo get info_ => _i;
  static HisMessagesReq create() => HisMessagesReq();
  HisMessagesReq createEmptyInstance() => create();
  static $pb.PbList<HisMessagesReq> createRepeated() => $pb.PbList<HisMessagesReq>();
  static HisMessagesReq getDefault() => _defaultInstance ??= create()..freeze();
  static HisMessagesReq _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get converId => $_getS(1, '');
  set converId($core.String v) { $_setString(1, v); }
  $core.bool hasConverId() => $_has(1);
  void clearConverId() => clearField(2);

  Int64 get beaginTime => $_getI64(2);
  set beaginTime(Int64 v) { $_setInt64(2, v); }
  $core.bool hasBeaginTime() => $_has(2);
  void clearBeaginTime() => clearField(3);
}

class HisMessagesAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HisMessagesAck', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'converId')
    ..pc<MessageContent>(4, 'messageList', $pb.PbFieldType.PM,MessageContent.create)
    ..hasRequiredFields = false
  ;

  HisMessagesAck() : super();
  HisMessagesAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HisMessagesAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HisMessagesAck clone() => HisMessagesAck()..mergeFromMessage(this);
  HisMessagesAck copyWith(void Function(HisMessagesAck) updates) => super.copyWith((message) => updates(message as HisMessagesAck));
  $pb.BuilderInfo get info_ => _i;
  static HisMessagesAck create() => HisMessagesAck();
  HisMessagesAck createEmptyInstance() => create();
  static $pb.PbList<HisMessagesAck> createRepeated() => $pb.PbList<HisMessagesAck>();
  static HisMessagesAck getDefault() => _defaultInstance ??= create()..freeze();
  static HisMessagesAck _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get converId => $_getS(1, '');
  set converId($core.String v) { $_setString(1, v); }
  $core.bool hasConverId() => $_has(1);
  void clearConverId() => clearField(2);

  $core.List<MessageContent> get messageList => $_getList(2);
}

class ConverReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConverReq', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<OperationType>(2, 'type', $pb.PbFieldType.OE, OperationType.DETAIL, OperationType.valueOf, OperationType.values)
    ..aOS(3, 'conversationId')
    ..hasRequiredFields = false
  ;

  ConverReq() : super();
  ConverReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConverReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConverReq clone() => ConverReq()..mergeFromMessage(this);
  ConverReq copyWith(void Function(ConverReq) updates) => super.copyWith((message) => updates(message as ConverReq));
  $pb.BuilderInfo get info_ => _i;
  static ConverReq create() => ConverReq();
  ConverReq createEmptyInstance() => create();
  static $pb.PbList<ConverReq> createRepeated() => $pb.PbList<ConverReq>();
  static ConverReq getDefault() => _defaultInstance ??= create()..freeze();
  static ConverReq _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  OperationType get type => $_getN(1);
  set type(OperationType v) { setField(2, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.String get conversationId => $_getS(2, '');
  set conversationId($core.String v) { $_setString(2, v); }
  $core.bool hasConversationId() => $_has(2);
  void clearConversationId() => clearField(3);
}

class ConverAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConverAck', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..e<Code>(3, 'code', $pb.PbFieldType.OE, Code.SUCCESS, Code.valueOf, Code.values)
    ..a<Int64>(4, 'time', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<ConverInfo>(5, 'converInfo', $pb.PbFieldType.OM, ConverInfo.getDefault, ConverInfo.create)
    ..pc<ConverInfo>(6, 'converList', $pb.PbFieldType.PM,ConverInfo.create)
    ..hasRequiredFields = false
  ;

  ConverAck() : super();
  ConverAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConverAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConverAck clone() => ConverAck()..mergeFromMessage(this);
  ConverAck copyWith(void Function(ConverAck) updates) => super.copyWith((message) => updates(message as ConverAck));
  $pb.BuilderInfo get info_ => _i;
  static ConverAck create() => ConverAck();
  ConverAck createEmptyInstance() => create();
  static $pb.PbList<ConverAck> createRepeated() => $pb.PbList<ConverAck>();
  static ConverAck getDefault() => _defaultInstance ??= create()..freeze();
  static ConverAck _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Code get code => $_getN(1);
  set code(Code v) { setField(3, v); }
  $core.bool hasCode() => $_has(1);
  void clearCode() => clearField(3);

  Int64 get time => $_getI64(2);
  set time(Int64 v) { $_setInt64(2, v); }
  $core.bool hasTime() => $_has(2);
  void clearTime() => clearField(4);

  ConverInfo get converInfo => $_getN(3);
  set converInfo(ConverInfo v) { setField(5, v); }
  $core.bool hasConverInfo() => $_has(3);
  void clearConverInfo() => clearField(5);

  $core.List<ConverInfo> get converList => $_getList(4);
}

class ConverInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConverInfo', package: const $pb.PackageName('com.tim.common.protos'))
    ..aOS(1, 'converId')
    ..e<ConverType>(2, 'type', $pb.PbFieldType.OE, ConverType.SINGLE, ConverType.valueOf, ConverType.values)
    ..pPS(3, 'uidList')
    ..aOS(4, 'groupId')
    ..a<Int64>(5, 'unCount', $pb.PbFieldType.OU6, Int64.ZERO)
    ..a<MessageContent>(6, 'lastContent', $pb.PbFieldType.OM, MessageContent.getDefault, MessageContent.create)
    ..hasRequiredFields = false
  ;

  ConverInfo() : super();
  ConverInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConverInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConverInfo clone() => ConverInfo()..mergeFromMessage(this);
  ConverInfo copyWith(void Function(ConverInfo) updates) => super.copyWith((message) => updates(message as ConverInfo));
  $pb.BuilderInfo get info_ => _i;
  static ConverInfo create() => ConverInfo();
  ConverInfo createEmptyInstance() => create();
  static $pb.PbList<ConverInfo> createRepeated() => $pb.PbList<ConverInfo>();
  static ConverInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ConverInfo _defaultInstance;

  $core.String get converId => $_getS(0, '');
  set converId($core.String v) { $_setString(0, v); }
  $core.bool hasConverId() => $_has(0);
  void clearConverId() => clearField(1);

  ConverType get type => $_getN(1);
  set type(ConverType v) { setField(2, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.List<$core.String> get uidList => $_getList(2);

  $core.String get groupId => $_getS(3, '');
  set groupId($core.String v) { $_setString(3, v); }
  $core.bool hasGroupId() => $_has(3);
  void clearGroupId() => clearField(4);

  Int64 get unCount => $_getI64(4);
  set unCount(Int64 v) { $_setInt64(4, v); }
  $core.bool hasUnCount() => $_has(4);
  void clearUnCount() => clearField(5);

  MessageContent get lastContent => $_getN(5);
  set lastContent(MessageContent v) { setField(6, v); }
  $core.bool hasLastContent() => $_has(5);
  void clearLastContent() => clearField(6);
}

class NotifyMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NotifyMessage', package: const $pb.PackageName('com.tim.common.protos'))
    ..a<Int64>(1, 'id', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aOS(2, 'type')
    ..aOS(3, 'targetUid')
    ..aOS(4, 'content')
    ..a<Int64>(5, 'time', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  NotifyMessage() : super();
  NotifyMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotifyMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotifyMessage clone() => NotifyMessage()..mergeFromMessage(this);
  NotifyMessage copyWith(void Function(NotifyMessage) updates) => super.copyWith((message) => updates(message as NotifyMessage));
  $pb.BuilderInfo get info_ => _i;
  static NotifyMessage create() => NotifyMessage();
  NotifyMessage createEmptyInstance() => create();
  static $pb.PbList<NotifyMessage> createRepeated() => $pb.PbList<NotifyMessage>();
  static NotifyMessage getDefault() => _defaultInstance ??= create()..freeze();
  static NotifyMessage _defaultInstance;

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get type => $_getS(1, '');
  set type($core.String v) { $_setString(1, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.String get targetUid => $_getS(2, '');
  set targetUid($core.String v) { $_setString(2, v); }
  $core.bool hasTargetUid() => $_has(2);
  void clearTargetUid() => clearField(3);

  $core.String get content => $_getS(3, '');
  set content($core.String v) { $_setString(3, v); }
  $core.bool hasContent() => $_has(3);
  void clearContent() => clearField(4);

  Int64 get time => $_getI64(4);
  set time(Int64 v) { $_setInt64(4, v); }
  $core.bool hasTime() => $_has(4);
  void clearTime() => clearField(5);
}

