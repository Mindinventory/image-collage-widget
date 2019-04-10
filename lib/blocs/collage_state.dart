import 'package:image_collage_widget/model/images.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CollageState extends Equatable {
  CollageState([List props = const []]) : super(props);
}

class InitialState extends CollageState {}

class PermissionDeniedState extends CollageState {

  @override
  String toString() => 'PermissionDeniedState';
}

class LoadImageState extends CollageState {

  @override
  String toString() => 'LoadImageState';
}

class ImageListState extends CollageState {

  final List<Images> images;

//  ImageListState(this.images);

  ImageListState({
    this.images,
  }) : super([images]);

  ImageListState copyWith({
    List<Images> images,
  }) {
    return ImageListState(
      images: images ?? this.images,
    );
  }

  @override
  String toString() => 'ImageListState';

//  ImageListState copyWith({
//    List<Images> images
//  }) {
//    return ImageListState(images ?? this.images);
//  }
}

