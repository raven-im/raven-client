
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/date_util.dart';

import '../more_widgets.dart';

class ConversationItem extends StatefulWidget {
  ConversationEntity entity;
  ConversationItemDelegate delegate;
  ConversationItem(ConversationItemDelegate delegate,ConversationEntity entity) {
    this.entity = entity; 
    this.delegate = delegate;
  }
  @override
  State<StatefulWidget> createState() {
    return _ConversationItemState(delegate,this.entity);
  }
}

class _ConversationItemState extends State<ConversationItem> {
  ConversationEntity conversationEntity;
  ConversationItemDelegate delegate;
  ContactEntity contactEntity;
  _ConversationItemState(ConversationItemDelegate delegate,ConversationEntity entity) {
    this.conversationEntity = entity;
    this.delegate = delegate;
    _fetchContactEntity();
  }

  _fetchContactEntity() async {
    this.contactEntity = await DataBaseApi.get().getContactsEntity(this.conversationEntity.targetUid);
  }

  void _tapConversation() {
    if(this.delegate != null) {
      this.delegate.didTapConversationItem(this.conversationEntity);
    }else {

    }
  }

  void _longPressConversation() {
    if(this.delegate != null) {
      this.delegate.didLongPressConversationItem(this.conversationEntity);
    }
  }

  Widget _buildWidget() {
    Widget res;
    ConversationEntity entity = this.conversationEntity;
    String timeTmp = DateUtil.getDateStrByDateTime(DateUtil.getDateTimeByMs(entity.timestamp));
    String time = DateUtil.formatDateTime(timeTmp, DateFormat.YEAR_MONTH_DAY, '/', '');

    res = MoreWidgets.conversationListViewItem(
        entity.name == null ? entity.targetUid : entity.name, 
        entity.conversationType,
        portrait: this.contactEntity!=null? this.contactEntity.portrait :"",
        content: entity.lastMessage,
        time: time,
        unread: entity.isUnreadCount, 
        onItemClick: (res) {
          _tapConversation();
        },
        onItemLongClick: (res){
          _longPressConversation();
        });
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

abstract class ConversationItemDelegate {
  void didTapConversationItem(ConversationEntity entity);
  void didLongPressConversationItem(ConversationEntity entity);
}