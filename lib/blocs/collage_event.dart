import 'package:equatable/equatable.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/permission_type.dart';

abstract class CollageEvent extends Equatable {
  CollageEvent([List props = const []]) : super();
}

///Checking permission event
class CheckPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;

  CheckPermissionEvent(this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'CheckPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, index];
}

///Asking permission event
class AskPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  AskPermissionEvent(this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'AskPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, index];
}

///Allow permission event
class AllowPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  AllowPermissionEvent(this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'AllowPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, index];
}

///Denied permission event
class DenyPermissionEvent extends CollageEvent {
  final PermissionType permissionType;
  final bool isFromPicker;
  int index = 0;
  DenyPermissionEvent(this.isFromPicker, this.permissionType, this.index);

  @override
  String toString() => 'DenyPermissionEvent';

  @override
  List<Object> get props => [permissionType, isFromPicker, index];
}

///ImageList permission event
class ImageListEvent extends CollageEvent {
  final List<Images> imageList;

  ImageListEvent(this.imageList);

  @override
  String toString() => 'ImageListEvent';

  @override
  List<Object> get props => [imageList];
}
