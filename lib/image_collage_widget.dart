library image_collage_widget;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/collage_type.dart';

import 'blocs/collage_bloc.dart';
import 'blocs/collage_event.dart';
import 'blocs/collage_state.dart';
import 'utils/permission_type.dart';
import 'widgets/row_widget.dart';

/// A ImageCollageWidget.
class ImageCollageWidget extends StatefulWidget {
  final String? filePath;
  final bool withImage;
  final CollageType collageType;
  final List<Images>? images;
  final EdgeInsetsGeometry? gridPadding;

  const ImageCollageWidget(
      {super.key,
      this.filePath,
      required this.collageType,
      required this.withImage,
      this.images,
      this.gridPadding});

  @override
  State<StatefulWidget> createState() => _ImageCollageWidget();
}

class _ImageCollageWidget extends State<ImageCollageWidget> with WidgetsBindingObserver {
  late final String _filePath;
  late final CollageType _collageType;
  late CollageBloc _imageListBloc;
  List<Images> images = [];

  @override
  void initState() {
    super.initState();

    _filePath = widget.filePath ?? '';
    _collageType = widget.collageType;

    images = widget.images ?? [];

    WidgetsBinding.instance.addObserver(this);
    _imageListBloc = CollageBloc(context: context,
        path: _filePath,
        collageType: _collageType,
        listOfImages: images);
    _imageListBloc.add(ImageListEvent(_imageListBloc.blankList()));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _imageListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _imageListBloc,
      child: BlocBuilder(
        bloc: _imageListBloc,
        builder: (context, CollageState state) {
          if (state is PermissionDeniedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("To show images you have to allow storage permission."),
                  TextButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)))),
                    child: const Text("Allow"),
                    onPressed: () => _handlePermission(),
                  ),
                ],
              ),
            );
          }
          if (state is LoadImageState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ImageListState) {
            return _gridView();
          }
          return Container(
            color: Colors.green,
          );
        },
      ),
    );
  }

  void _handlePermission() {
    _imageListBloc.add(CheckPermissionEvent(true, PermissionType.storage, 0));
  }

  Widget _gridView() {
    return AspectRatio(
      aspectRatio: 1.0 / 1.0,
      child: GridCollageWidget(
        _collageType,
        _imageListBloc,
        images: images,
        gridPadding: widget.gridPadding,
      ),
    );
  }
}
