import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:image_collage_widget/utils/permission_type.dart';
import 'package:path_provider/path_provider.dart';
import 'collage_event.dart';
import 'collage_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class CollageBloc extends Bloc<CollageEvent, CollageState> {
  String path;
  final CollageType collageType;
  final BuildContext context;

  CollageBloc({@required this.context, @required this.collageType, this.path});

  @override
  CollageState get initialState => InitialState();

  @override
  Stream<CollageState> mapEventToState(CollageEvent event) async* {
    print('event---> $event');
    print('state---> $currentState');

    if (event is CheckPermissionEvent) {
      checkPermission(event.isFromPicker, event.permissionType, event.index);
    }
    if (event is AllowPermissionEvent) {
      print('permisiionType--->${event.permissionType}');
      if (event.isFromPicker) {
        openPicker(event.permissionType, event.index);
      } else {
        yield LoadImageState();
        loadImages(path, getImageCount());
      }
    }

    if (event is AskPermissionEvent) {
      askPermission(event.isFromPicker, event.permissionType, event.index);
    }

    if (event is DenyPermissionEvent) {
      showSnackBar();
      if (!event.isFromPicker) {
        yield PermissionDeniedState();
      }
    }

    if (event is ImageListEvent) {
      yield LoadImageState();
      yield ImageListState(images: event.imageList);
    }
  }

  checkPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    PermissionHandler()
        .checkPermissionStatus(permissionType == PermissionType.Storage
            ? Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage
            : PermissionGroup.camera)
        .then((permissionStatus) {
      print("permissionStatus===> $permissionStatus");
      if (permissionStatus == PermissionStatus.granted) {
        dispatch(AllowPermissionEvent(isFromPicker, permissionType, index));
      } else {
        print("permissionStatusChecked===> $permissionStatus");
        dispatch(AskPermissionEvent(isFromPicker, permissionType, index));
      }
    });
  }

  void dispatchCheckPermissionEvent(
      {@required PermissionType permissionType,
      bool isFromPicker = false,
      int index = -1}) {
    dispatch(CheckPermissionEvent(isFromPicker, permissionType, index));
  }

  openPicker(PermissionType permissionType, int index) async {
    await ImagePicker.pickImage(
            source: permissionType == PermissionType.Storage
                ? ImageSource.gallery
                : ImageSource.camera)
        .then((image) {
      if (image != null) {
        var imageList = (currentState as ImageListState).copyWith().images;
        imageList[index].imageUrl = image;
        dispatch(ImageListEvent(imageList));
      }
    });
  }

  askPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    bool isForStorage = permissionType == PermissionType.Storage;
    await PermissionHandler().requestPermissions([
      isForStorage
          ? Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage
          : PermissionGroup.camera
    ]).then((Map<PermissionGroup, PermissionStatus> status) async {
      if (status[isForStorage
              ? Platform.isIOS
                  ? PermissionGroup.photos
                  : PermissionGroup.storage
              : PermissionGroup.camera] ==
          PermissionStatus.granted) {
        dispatch(AllowPermissionEvent(isFromPicker, permissionType, index));
      } else {
        dispatch(DenyPermissionEvent(isFromPicker, permissionType, index));
      }
    });
  }

  dispatchRemovePhotoEvent(int index) {
    var imageList = (currentState as ImageListState).copyWith().images;
    imageList[index].imageUrl = null;
    dispatch(ImageListEvent(imageList));
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

      dispatch(ImageListEvent(listImage));
    });
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

  showSnackBar({String msg = "Permission Denied."}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1000),
    ));
  }
}
