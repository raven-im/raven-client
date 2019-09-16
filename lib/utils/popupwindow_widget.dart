import 'package:flutter/material.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/functions.dart';
import 'package:myapp/utils/image_util.dart';

class PopupWindowUtil {
  /*
  * 选择相机相册
  */
  static Future showPhotoChosen(BuildContext context, {OnCallBack onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("Album"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getGalleryImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  /*
  * 选择拍照片、拍视频
  */
  static Future showCameraChosen(BuildContext context,
      {OnCallBackWithType onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(1, image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("Video"),
                onTap: () async {
                  Navigator.pop(context);
                  // InteractNative.goNativeWithValue(
                  //     InteractNative.methodNames['shootVideo'], null)
                  //     .then((success) {
                  //   if (success != null && success is Map) {
                  //     if (onCallBack != null) {
                  //       onCallBack(2, success);
                  //     }
                  //   } else {
                  //     DialogUtil.buildToast(success.toString());
                  //   }
                  // });
                },
              ),
            ],
          );
        });
  }
}
