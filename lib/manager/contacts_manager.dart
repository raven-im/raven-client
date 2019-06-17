import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/entity/rest_list_entity.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';

class ContactManager {
  static final ContactManager _contacts = new ContactManager._internal();

  static ContactManager get() {
    return _contacts;
  }

  ContactManager._internal();

  /*
  *  查询联系人列表
  */
  Future<List<ContactEntity>> getContactsEntity() async {
    List<ContactEntity> res = [];
    RestListEntity entity = await RestManager.get().getUserList();
    if (Constants.RSP_COMMON_SUCCESS != entity.code) {
      DialogUtil.buildToast(entity.message);
    } else {
      entity.data.forEach((item) {
        res.add(new ContactEntity(
          userId: item['id'],
          userName: item['name'],
          portrait: item['portrait'],
          status: item['state'],
          mobile: item['mobile'],
          ));
      });
    }
    return res;
  }
}
