import 'package:equatable/equatable.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/permission_type.dart';

abstract class CollageEvent extends Equatable {
  CollageEvent([List props = const []]) : super();
}

class CheckPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  final int permissionIndex;

  CheckPermissionEvent(
      {required this.permissionType,
      this.isFromPicker = false,
      this.permissionIndex = 0});

  @override
  String toString() => 'CheckPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, permissionIndex];
}

class AskPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  final int permissionIndex;

  AskPermissionEvent(
      {required this.permissionType,
      this.isFromPicker = false,
      this.permissionIndex = 0});

  @override
  String toString() => 'AskPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, permissionIndex];
}

class AllowPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  final int permissionIndex;

  AllowPermissionEvent(
      {required this.permissionType,
      this.isFromPicker = false,
      this.permissionIndex = 0});

  @override
  String toString() => 'AllowPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, permissionIndex];
}

class DenyPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  final int permissionIndex;

  DenyPermissionEvent(
      {required this.permissionType,
      this.isFromPicker = false,
      this.permissionIndex = 0});

  @override
  String toString() => 'DenyPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, permissionIndex];
}

class ImageListEvent extends CollageEvent {
  final List<Images> imageList;

  ImageListEvent(this.imageList);

  @override
  String toString() => 'ImageListEvent';

  @override
  List<Object> get props => [imageList];
}
