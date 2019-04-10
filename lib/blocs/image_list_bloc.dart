import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_list_event.dart';
import 'image_list_state.dart';

class image_list_bloc extends Bloc<image_list_event, image_list_state> {

  String path;
  CollageType collageType;
  final BuildContext context;
  final bool withImage;

  image_list_bloc(this.context, this.withImage, {this.path, this.collageType});

  @override
  image_list_state get initialState => image_list_state.initial();

  @override
  Stream<image_list_state> mapEventToState(image_list_event event) async* {
    debugPrint("event---> $event");

    if (event is InitialEvent) {
      if (withImage) {
        checkPermission();
      } else {
        yield image_list_state(
            imageList: blankList(),
            isImageLoadedStarted: currentState.isImageLoadedStarted,
            isPermissionGranted: currentState.isPermissionGranted);
      }
    }

    /// Handling storage permission
    /// This event will fire from [checkPermission() & checkPermissionOnResume()]
    if (event is PermissionHandleEvent) {
      if (event.isFromOnResume ?? false) {
        _handleOnResumePermission();
      } else {
        _handlePermission();
      }
    }

    /// Handle Image loading from external storage.
    /// This event will fire from [ _handlePermission() ].
    if (event is ImageLoadedEvent) {
      yield image_list_state(
          imageList: event.imageList,
          isImageLoadedStarted: false,
          isPermissionGranted: currentState.isPermissionGranted);
    }

    /// For getting the images from device it will take time.
    /// Once the image loading is done [loadImages()], this event will fire.
    if (event is DataLoadedEvent) {
      yield image_list_state(
          imageList: image_list_state.initial().imageList,
          isPermissionGranted: event.isPermissionGranted,
          isImageLoadedStarted: true);
      if (event.isPermissionGranted) {
        loadImages(path, getImageCount());
        debugPrint("iamgeCount---> ${getImageCount()}");
      }
    }

    /// For dispatch imageList with new selected image.
    if (event is PickedImageEvent) {
      yield image_list_state(
          imageList: event.imageList,
          isPermissionGranted: currentState.isPermissionGranted,
          isImageLoadedStarted: currentState.isImageLoadedStarted);
    }
  }

  /// The no. of image return as per collage type.
  getImageCount() {
    if (collageType == CollageType.HSplit || collageType == CollageType.VSplit)
      return 2;
    else if (collageType == CollageType.FourSquare ||
        collageType == CollageType.FourLeftBig)
      return 4;
    else if (collageType == CollageType.NineSquare)
      return 9;
    else if (collageType == CollageType.ThreeVertical ||
        collageType == CollageType.ThreeHorizontal)
      return 3;
    else if (collageType == CollageType.LeftBig ||
        collageType == CollageType.RightBig)
      return 6;
    else if (collageType == CollageType.VMiddleTwo ||
        collageType == CollageType.CenterBig) return 7;
  }

  /// To load photos from device.
  /// @param path:- path of file from where needs to show image.
  /// Default path :- Camera.
  /// @param maxCount:- Maximum number of photos will return.
  Future loadImages(String path, int maxCount) async {
    var filePath = await getExternalStorageDirectory();
    var root = Directory(path != null ? path : '${filePath.path}/DCIM/Camera');

    await root.exists().then((isExist) async {
      int maxImage = maxCount != null ? maxCount : 6;
      var listImage = blankList();
      if (isExist) {
        List<String> file =
        await FileManager(root: root.path).filesTree(extensions: [
          "jpeg",
          "png",
          "jpg",
        ]);

        debugPrint('file length---> ${file.length}');

        /// [file] by default will return old images.
        /// for getting latest max number of photos [file.sublist(file.length - maxImage, file.length)]

        List<String> files = file.length > maxImage
            ? file.sublist(file.length - (maxImage + 1), file.length - 1)
            : file;
        debugPrint("image path-->${files}");
        debugPrint("image path file-->${file}");

        for (int i = 0; i < files.length; i++) {
//          var image = Images();
//          image.id = i;
//          image.imageUrl = File(files[i]);
          listImage[i].imageUrl = File(files[i]);
//          listImage.add(image);
        }
      } else {
        debugPrint("No directory found.");
      }

      dispatch(ImageLoadedEvent(imageList: listImage, isImageLoaded: true));
    });
  }

  /// After permission granted this event will call for loading image from device.
  void _startLoaded(bool isPermissionGranted) {
    if (withImage) {
      dispatch(DataLoadedEvent(isPermissionGranted: isPermissionGranted));
    }
  }

  void checkPermission() {
    dispatch(PermissionHandleEvent());
  }

  /// For checking permission in on resume of widget.
  void checkPermissionOnResume() {
    dispatch(PermissionHandleEvent(isFromOnResume: true));
  }

  void callInitialEvent() {
    dispatch(InitialEvent());
  }

  Future _handleOnResumePermission() async {
    var permissions = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permissions == PermissionStatus.granted) {
      _startLoaded(true);
    }
  }

  List<Images> blankList() {
    var imageList = List<Images>();
    for (int i = 0; i < getImageCount(); i++) {
      var images = Images();
      images.id = i + 1;
      imageList.add(images);
    }

    return imageList;
  }

  /// Storage permission is required for getting photos.
  Future _handlePermission(
      {bool isForStoragePermission = true, int index}) async {
    var permissions = await PermissionHandler().checkPermissionStatus(
        isForStoragePermission
            ? PermissionGroup.storage
            : PermissionGroup.camera);

    if (permissions == PermissionStatus.granted) {
      index == null
          ? _startLoaded(true)
          : openPicker(isForStoragePermission, index);
    } else if (permissions == PermissionStatus.denied) {
      PermissionHandler().requestPermissions([
        isForStoragePermission
            ? PermissionGroup.storage
            : PermissionGroup.camera
      ]).then((Map<PermissionGroup, PermissionStatus> status) async {
        if (status[isForStoragePermission
            ? PermissionGroup.storage
            : PermissionGroup.camera] ==
            PermissionStatus.granted) {
          index == null
              ? _startLoaded(true)
              : openPicker(isForStoragePermission, index);
        } else {
          _startLoaded(false);
          _showPermissionSnackBar(context);
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return AlertDialog(
//                  content: Text("Storage permission is needed."),
//                  actions: <Widget>[
//                    FlatButton(
//                      onPressed: () {
//                        Navigator.of(context).pop(true);
//                      },
//                      child: Text(
//                        "Cancel",
//                        style: TextStyle(fontSize: 12, color: Colors.black),
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(left: 10),
//                      child: FlatButton(
//                        padding: EdgeInsets.only(right: 10),
//                        onPressed: () {
//                          PermissionHandler().openAppSettings();
//                          Navigator.of(context).pop(true);
//                        },
//                        child: Text(
//                          "Allow",
//                          style: TextStyle(fontSize: 12, color: Colors.black),
//                        ),
//                      ),
//                    )
//                  ],
//                );
//              });
        }
      });
    } else {
      debugPrint("Permission status---> ${permissions.value}");
    }
  }

  void _showPermissionSnackBar(BuildContext context) async {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Permission Denied'),
        duration: Duration(milliseconds: 1000),
//        action: SnackBarAction(
//            label: 'Allow',
//            onPressed: () {
//              PermissionHandler().openAppSettings();
//            }),
      ),
    );
  }

  imagePickerDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ListView(
              shrinkWrap: true,
              children: <Widget>[
                buildDialogOption(index, isForStorage: false),
                buildDialogOption(index),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  dismissDialog();
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  dismissDialog() {
    Navigator.of(context, rootNavigator: true).pop(true);
  }

  Widget buildDialogOption(int index, {bool isForStorage = true}) {
    return InkWell(
        splashColor: Colors.blue[100],
        highlightColor: Colors.blue[200],
        onTap: () {
          Navigator.of(context).pop(true);
          _handlePermission(index: index, isForStoragePermission: isForStorage);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(isForStorage ? "Gallery" : "Camera"),
        ));
  }

  openPicker(bool isForStorage, int index) async {
    await ImagePicker.pickImage(
        source: isForStorage ? ImageSource.gallery : ImageSource.camera)
        .then((image) {
      if (image != null) {
        var images = Images();
        images.imageUrl = image;
        var imageList = currentState.imageList;
        imageList.removeAt(index);
        imageList.insert(index, images);
        dispatch(PickedImageEvent(imageList));
      }
    });
  }
}
