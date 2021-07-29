import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_utils/flutter_file_utils.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/collage_type.dart';
import 'package:image_collage_widget/utils/permission_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc.dart';


class CollageBloc extends Bloc<CollageEvent, CollageState?> {
  String? path;
  final CollageType collageType;
  final BuildContext context;

  CollageBloc({required this.context, required this.collageType, this.path})
      : assert(context != null),
        assert(collageType != null),
        super(null);

  CollageState get initialState => InitialState();

  @override
  Stream<CollageState> mapEventToState(CollageEvent event) async* {
    if (event is CheckPermissionEvent) {
      checkPermission(event.isFromPicker, event.permissionType, event.permissionIndex);
    }
    if (event is AllowPermissionEvent) {
      if (event.isFromPicker) {
        openPicker(event.permissionType, event.permissionIndex);
      } else {
        yield LoadImageState();
        await loadImages(path, getImageCount());
      }
    }

    if (event is AskPermissionEvent) {
      askPermission(event.isFromPicker, event.permissionType, event.permissionIndex);
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

  void checkPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    var permissionStatus = permissionType == PermissionType.Storage
        ? Platform.isIOS ? await Permission.photos.status : await Permission.storage.status
        : await Permission.camera.status;
      if (permissionStatus == PermissionStatus.granted) {
        add(AllowPermissionEvent(isFromPicker: isFromPicker, permissionType: permissionType, permissionIndex: index));
      } else {
        add(AskPermissionEvent(isFromPicker: isFromPicker, permissionType: permissionType, permissionIndex: index));
      }
  }

  void dispatchCheckPermissionEvent(
      {required PermissionType permissionType,
      bool isFromPicker = false,
      int index = -1}) {
    add(CheckPermissionEvent(
        isFromPicker: isFromPicker,
        permissionType: permissionType,
        permissionIndex: index));
  }

  void openPicker(PermissionType permissionType, int index) async {
    await ImagePicker().pickImage(
            source: permissionType == PermissionType.Storage
                ? ImageSource.gallery
                : ImageSource.camera)
        .then((pickedFile) {
      if (pickedFile != null) {
        var imageList = (state as ImageListState).copyWith().images;
        final File image = File(pickedFile.path);
        imageList[index].imageUrl = image;
        add(ImageListEvent(imageList));
      }
    });
  }

  void askPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    bool isForStorage = permissionType == PermissionType.Storage;
    Map<Permission, PermissionStatus> statuses = await [
      isForStorage
          ? Platform.isIOS ? Permission.photos : Permission.storage
          : Permission.camera
    ].request();

    if (statuses[isForStorage
        ? Platform.isIOS
        ? Permission.photos
        : Permission.storage
        : Permission.camera] ==
        PermissionStatus.granted) {
      add(AllowPermissionEvent(
          isFromPicker: isFromPicker,
          permissionType: permissionType,
          permissionIndex: index));
    } else {
      add(DenyPermissionEvent(
          isFromPicker: isFromPicker,
          permissionType: permissionType,
          permissionIndex: index));
    }
  }

  void dispatchRemovePhotoEvent(int index) {
    var imageList = (state as ImageListState).copyWith().images;
    imageList[index].imageUrl = null;
    add(ImageListEvent(imageList));
  }

  /// To load photos from device.
  /// @param path:- path of file from where needs to show image.
  /// Default path :- Camera.
  /// @param maxCount:- Maximum number of photos will return.
  Future loadImages(String? path, int maxCount) async {
    var filePath = await getExternalStorageDirectory();
    var root = Directory(path ?? '${filePath.path}/DCIM/Camera');

    await root.exists().then((isExist) async {
      int maxImage = maxCount;
      var listImage = blankList();
      if (isExist) {
        List<FileSystemEntity> file =
        await FileManager(root: root).filesTree(extensions: [
          'jpeg',
          'png',
          'jpg',
        ]);

        debugPrint('file length---> ${file.length}');

        /// [file] by default will return old images.
        /// for getting latest max number of photos [file.sublist(file.length - maxImage, file.length)]

        List<FileSystemEntity> files = file.length > maxImage
            ? file.sublist(file.length - (maxImage + 1), file.length - 1)
            : file;
        debugPrint('image path-->$files');
        debugPrint('image path file-->$file');

        for (int i = 0; i < files.length; i++) {
          listImage[i].imageUrl = File(files[i].path);
        }
      } else {
        debugPrint('No directory found.');
      }

      add(ImageListEvent(listImage));
    });
  }

  List<Images> blankList() {
    var imageList = <Images>[];
    for (int i = 0; i < getImageCount(); i++) {
      var images = Images();
      images.id = i + 1;
      imageList.add(images);
    }

    return imageList;
  }

  /// The no. of image return as per collage type.
  int getImageCount() {
    if (collageType == CollageType.HSplit || collageType == CollageType.VSplit) {
      return 2;
    } else if (collageType == CollageType.FourSquare ||
        collageType == CollageType.FourLeftBig) {
      return 4;
    } else if (collageType == CollageType.NineSquare) {
      return 9;
    } else if (collageType == CollageType.ThreeVertical ||
        collageType == CollageType.ThreeHorizontal) {
      return 3;
    } else if (collageType == CollageType.LeftBig ||
        collageType == CollageType.RightBig) {
      return 6;
    } else if (collageType == CollageType.VMiddleTwo ||
        collageType == CollageType.CenterBig) {
      return 7;
    } else {
      return 0;
    }
  }

  void showSnackBar({String msg = 'Permission Denied.'}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1000),
    ),);
  }
}
