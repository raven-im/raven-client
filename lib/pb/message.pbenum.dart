///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class HeartBeatType extends $pb.ProtobufEnum {
  static const HeartBeatType PING = HeartBeatType._(0, 'PING');
  static const HeartBeatType PONG = HeartBeatType._(1, 'PONG');

  static const $core.List<HeartBeatType> values = <HeartBeatType> [
    PING,
    PONG,
  ];

  static final $core.Map<$core.int, HeartBeatType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static HeartBeatType valueOf($core.int value) => _byValue[value];

  const HeartBeatType._($core.int v, $core.String n) : super(v, n);
}

class Code extends $pb.ProtobufEnum {
  static const Code SUCCESS = Code._(0, 'SUCCESS');
  static const Code FAIL = Code._(1, 'FAIL');

  static const $core.List<Code> values = <Code> [
    SUCCESS,
    FAIL,
  ];

  static final $core.Map<$core.int, Code> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Code valueOf($core.int value) => _byValue[value];

  const Code._($core.int v, $core.String n) : super(v, n);
}

class ConverType extends $pb.ProtobufEnum {
  static const ConverType SINGLE = ConverType._(0, 'SINGLE');
  static const ConverType GROUP = ConverType._(1, 'GROUP');

  static const $core.List<ConverType> values = <ConverType> [
    SINGLE,
    GROUP,
  ];

  static final $core.Map<$core.int, ConverType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConverType valueOf($core.int value) => _byValue[value];

  const ConverType._($core.int v, $core.String n) : super(v, n);
}

class MessageType extends $pb.ProtobufEnum {
  static const MessageType TEXT = MessageType._(0, 'TEXT');
  static const MessageType PICTURE = MessageType._(1, 'PICTURE');
  static const MessageType VOICE = MessageType._(2, 'VOICE');
  static const MessageType VIDEO = MessageType._(3, 'VIDEO');

  static const $core.List<MessageType> values = <MessageType> [
    TEXT,
    PICTURE,
    VOICE,
    VIDEO,
  ];

  static final $core.Map<$core.int, MessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageType valueOf($core.int value) => _byValue[value];

  const MessageType._($core.int v, $core.String n) : super(v, n);
}

class OperationType extends $pb.ProtobufEnum {
  static const OperationType DETAIL = OperationType._(0, 'DETAIL');
  static const OperationType ALL = OperationType._(1, 'ALL');

  static const $core.List<OperationType> values = <OperationType> [
    DETAIL,
    ALL,
  ];

  static final $core.Map<$core.int, OperationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OperationType valueOf($core.int value) => _byValue[value];

  const OperationType._($core.int v, $core.String n) : super(v, n);
}

class RavenMessage_Type extends $pb.ProtobufEnum {
  static const RavenMessage_Type Login = RavenMessage_Type._(0, 'Login');
  static const RavenMessage_Type LoginAck = RavenMessage_Type._(1, 'LoginAck');
  static const RavenMessage_Type ServerInfo = RavenMessage_Type._(2, 'ServerInfo');
  static const RavenMessage_Type UpDownMessage = RavenMessage_Type._(3, 'UpDownMessage');
  static const RavenMessage_Type HeartBeat = RavenMessage_Type._(4, 'HeartBeat');
  static const RavenMessage_Type MessageAck = RavenMessage_Type._(5, 'MessageAck');
  static const RavenMessage_Type HisMessagesReq = RavenMessage_Type._(6, 'HisMessagesReq');
  static const RavenMessage_Type HisMessagesAck = RavenMessage_Type._(7, 'HisMessagesAck');
  static const RavenMessage_Type NotifyMessage = RavenMessage_Type._(8, 'NotifyMessage');
  static const RavenMessage_Type ConverReq = RavenMessage_Type._(11, 'ConverReq');
  static const RavenMessage_Type ConverAck = RavenMessage_Type._(10, 'ConverAck');

  static const $core.List<RavenMessage_Type> values = <RavenMessage_Type> [
    Login,
    LoginAck,
    ServerInfo,
    UpDownMessage,
    HeartBeat,
    MessageAck,
    HisMessagesReq,
    HisMessagesAck,
    NotifyMessage,
    ConverReq,
    ConverAck,
  ];

  static final $core.Map<$core.int, RavenMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RavenMessage_Type valueOf($core.int value) => _byValue[value];

  const RavenMessage_Type._($core.int v, $core.String n) : super(v, n);
}

