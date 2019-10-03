import 'package:equatable/equatable.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CollageState extends Equatable {
  CollageState([List props = const []]) : super();
}

class InitialState extends CollageState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PermissionDeniedState extends CollageState {

  @override
  String toString() => 'PermissionDeniedState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadImageState extends CollageState {

  @override
  String toString() => 'LoadImageState';

  @override
  // TODO: implement props
  List<Object> get props => null;
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

  @override
  // TODO: implement props
  List<Object> get props => null;

//  ImageListState copyWith({
//    List<Images> images
//  }) {
//    return ImageListState(images ?? this.images);
//  }
}

