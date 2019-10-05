library image_collage_widget;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:image_collage_widget/utils/permission_type.dart';
import 'package:image_collage_widget/widgets/row_widget.dart';

import 'blocs/bloc.dart';

/// A ImageCollageWidget.
class ImageCollageWidget extends StatefulWidget {
  final String filePath;
  final CollageType collageType;
  final bool withImage;

  const ImageCollageWidget(
      {Key key, this.filePath, this.collageType, this.withImage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageCollageWidget(filePath: filePath, collageType: collageType);
  }
}

class _ImageCollageWidget extends State<ImageCollageWidget>
    with WidgetsBindingObserver {
  _ImageCollageWidget({this.filePath, this.collageType});

  String filePath;
  final CollageType collageType;
  var withImage = false;

  CollageBloc _imageListBloc;
  AppLifecycleState _appLifecycleState;
  var isFromPermissionButton = false;

  @override
  void initState() {
    super.initState();

    withImage = widget.withImage ?? false;

    WidgetsBinding.instance.addObserver(this);
    _imageListBloc =
        CollageBloc(context: context, path: filePath, collageType: collageType);

    if (withImage && !Platform.isIOS) {
      _handlePermission();
    } else {
      _imageListBloc.dispatch(ImageListEvent(_imageListBloc.blankList()));
    }
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    _appLifecycleState = state;
    debugPrint("app state---> $_appLifecycleState");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _imageListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => _imageListBloc,
      child: BlocBuilder(
          bloc: _imageListBloc,
          builder: (context, CollageState state) {
            if (state is PermissionDeniedState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "To show images you have to allow storage permission."),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text("Allow"),
                      onPressed: () => _handlePermission(),
                    ),
                  ],
                ),
              );
            }

            if (state is LoadImageState) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }

            if (state is ImageListState) {
              return _gridView();
            }

            return Container();
          }),
    );
  }

  void _handlePermission() {
    _imageListBloc.dispatchCheckPermissionEvent(
        permissionType: PermissionType.Storage);
  }

  Widget _gridView() {
    return AspectRatio(
      aspectRatio: 1.0 / 1.0,
      child: Container(
        child: GridCollageWidget(collageType, _imageListBloc),
      ),
    );
  }
}