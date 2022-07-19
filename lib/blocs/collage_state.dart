import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_collage_widget/model/images.dart';

@immutable
abstract class CollageState extends Equatable {
  CollageState([List props = const []]) : super();
}

///Initial state
class InitialState extends CollageState {
  @override
  String toString() => 'InitialState';

  @override
  List<Object> get props => [];
}

///Permission denied state
class PermissionDeniedState extends CollageState {
  @override
  String toString() => 'PermissionDeniedState';

  @override
  List<Object> get props => [];
}

///Load Image state
class LoadImageState extends CollageState {
  @override
  String toString() => 'LoadImageState';

  @override
  List<Object> get props => [];
}

///Image list state
class ImageListState extends CollageState {
  final List<Images> images;

  ImageListState({
    required this.images,
  }) : super([images]);

  ImageListState copyWith({
    required List<Images> images,
  }) {
    return ImageListState(
      images: images,
    );
  }

  @override
  String toString() => 'ImageListState';

  @override
  List<Object> get props => [images];
}
