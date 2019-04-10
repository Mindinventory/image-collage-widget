import 'package:equatable/equatable.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/permission_type.dart';

abstract class CollageEvent extends Equatable {}

class CheckPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;

  CheckPermissionEvent(this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'CheckPermissionEvent';
}

class AskPermissionEvent extends CollageEvent {

  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  AskPermissionEvent(
       this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'AskPermissionEvent';
}

class AllowPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  AllowPermissionEvent(
      this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'AllowPermissionEvent';
}

class DenyPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  DenyPermissionEvent(
      this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'DenyPermissionEvent';
}

class OpenPickerEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  OpenPickerEvent(
      this.isFromPicker, this.permissionType, this.index);
}

class ImageListEvent extends CollageEvent {
  final List<Images> imageList;

  ImageListEvent(this.imageList);

  @override
  String toString() => 'LoadImageEvent';
}

class RemoveImageEvent extends CollageEvent {

  final List<Images> imageList;
  RemoveImageEvent(this.imageList);

  @override
  String toString() => 'LoadImageEvent';
}

class Event extends CollageEvent {
  @override
  String toString() => 'LoadImageEvent';
}
