import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:image_collage_widget/utils/permission_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc.dart';

class CollageBloc extends Bloc<CollageEvent, CollageState> {
  String path;
  final CollageType collageType;
  final BuildContext context;

  CollageBloc(
      {required this.context, required this.collageType, required this.path})
      : super(LoadImageState()) {

    on<CheckPermissionEvent>((event, emit) => add(checkPermission(
        event.isFromPicker, event.permissionType, event.index)));
    on<AllowPermissionEvent>((event, emit) {
      if (event.isFromPicker) {
        openPicker(event.permissionType, event.index);
      } else {
        emit(LoadImageState()) ;
        loadImages(path, getImageCount());
      }
    });
    on<AskPermissionEvent>((event, emit) => emit(
        askPermission(event.isFromPicker, event.permissionType, event.index)));

    on<DenyPermissionEvent>((event, emit) {
      showSnackBar();
      if (!event.isFromPicker) {
        emit(PermissionDeniedState()) ;
      }
    });

    on<ImageListEvent>((event, emit) {
      emit(LoadImageState()) ;
      emit(ImageListState(images: event.imageList)) ;
    });
  }

  checkPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    PermissionStatus _permissionStatus = PermissionStatus.denied;

    if (permissionType == PermissionType.Storage) {
      if (Platform.isIOS) {
        askForPermission(
            _permissionStatus, isFromPicker, permissionType, index);
      } else {
        askForPermission(
            _permissionStatus, isFromPicker, permissionType, index);
      }
    } else {
      askForPermission(_permissionStatus, isFromPicker, permissionType, index);
    }
  }

  askForPermission(PermissionStatus permissionStatus, bool isFromPicker,
      PermissionType permissionType, int index) {
    if (permissionStatus == PermissionStatus.granted) {
      AllowPermissionEvent(isFromPicker, permissionType, index);
    } else {
      AskPermissionEvent(isFromPicker, permissionType, index);
    }
  }

  void dispatchCheckPermissionEvent(
      {required PermissionType permissionType,
      bool isFromPicker = false,
      int index = -1}) {
    CheckPermissionEvent(isFromPicker, permissionType, index);
  }

  openPicker(PermissionType permissionType, int index) async {
    await ImagePicker.platform
        .pickImage(
            source: permissionType == PermissionType.Storage
                ? ImageSource.gallery
                : ImageSource.camera)
        .then((image) {
      if (image != null) {
        var imageList = (state as ImageListState).copyWith(images: []).images;
        imageList[index].imageUrl = File(image.path);
        ImageListEvent(imageList);
      }
    });
  }

  askPermission(
      bool isFromPicker, PermissionType permissionType, int index) async {
    Map<Permission, PermissionStatus> statuses = {};
    // You can request multiple permissions at once.

    if (Platform.isIOS) {
      statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();
    } else {
      statuses = await [Permission.camera].request();
    }
    bool isForStorage = permissionType == PermissionType.Storage;
    if (isForStorage) {
      if (Platform.isIOS)
        await Permission.photos.request().then((value) => eventAction(
            isForStorage, isFromPicker, permissionType, index, statuses));
      else
        await Permission.storage.request().then((value) => eventAction(
            isForStorage, isFromPicker, permissionType, index, statuses));
    } else {
      await Permission.camera.request().then((value) => eventAction(
          isForStorage, isFromPicker, permissionType, index, statuses));
    }
  }

  eventAction(
      bool isForStorage,
      bool isFromPicker,
      PermissionType permissionType,
      int index,
      Map<Permission, PermissionStatus> status) {
    if (status[isForStorage
            ? Platform.isIOS
                ? Permission.photos
                : Permission.storage
            : Permission.camera] ==
        PermissionStatus.granted) {
      AllowPermissionEvent(isFromPicker, permissionType, index);
    } else {
      DenyPermissionEvent(isFromPicker, permissionType, index);
    }
  }

  dispatchRemovePhotoEvent(int index) {
    var imageList = (state as ImageListState).copyWith(images: []).images;
    imageList[index].imageUrl = null;
    ImageListEvent(imageList);
  }

  /// To load photos from device.
  /// @param path:- path of file from where needs to show image.
  /// Default path :- Camera.
  /// @param maxCount:- Maximum number of photos will return.
  Future loadImages(String path, int maxCount) async {
    String? path = await FilePicker.platform.getDirectoryPath();

    var root = Directory(path != null ? path : '$path/DCIM/Camera');

    await root.exists().then((isExist) async {
      int maxImage = maxCount != null ? maxCount : 6;
      var listImage = blankList();
      if (isExist) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpeg', 'png', 'jpg'],
        );

        if (result != null) {
          List<File> files =
              result.paths.map((path) => File(path ?? '')).toList();

          debugPrint('file length---> ${files.length}');

          /// [file] by default will return old images.
          /// for getting latest max number of photos [file.sublist(file.length - maxImage, file.length)]

          List<File> filesList = files.length > maxImage
              ? files.sublist(files.length - (maxImage + 1), files.length - 1)
              : files;
          debugPrint("image path-->$files");
          debugPrint("image path file-->$files");

          for (int i = 0; i < filesList.length; i++) {
            listImage[i].imageUrl = File(filesList[i].path);
          }
        } else {
          // User canceled the picker
        }
      } else {
        debugPrint("No directory found.");
      }

      ImageListEvent(listImage);
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
