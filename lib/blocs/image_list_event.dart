import 'package:image_collage_widget/model/images.dart';
import 'package:flutter/material.dart';

abstract class image_list_event {}

class InitialEvent extends image_list_event {
}

class ImageLoadedEvent extends image_list_event {
  List<Images> imageList;
  bool isImageLoaded;

  ImageLoadedEvent({this.imageList, this.isImageLoaded});
}

class DataLoadedEvent extends image_list_event {
  bool isPermissionGranted;

  DataLoadedEvent({this.isPermissionGranted});
}

class PermissionHandleEvent extends image_list_event {
  bool isFromOnResume;
  PermissionHandleEvent({this.isFromOnResume});
}

class PickImageEvent extends image_list_event {
  int imageId;
  bool isForStorage;
  PickImageEvent(this.imageId, {this.isForStorage = false});
}

class PickedImageEvent extends image_list_event {
  List<Images> imageList;
  PickedImageEvent(this.imageList);
}

class OpenPickerEvent extends image_list_event {
  int imageIndex;
  OpenPickerEvent(this.imageIndex);
}
