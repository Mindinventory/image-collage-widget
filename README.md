# image_collage_widget

<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/dart-website-deepskyblue.svg" alt="Dart Website"></a>
<a href=""><img src="https://app.codacy.com/project/badge/Grade/dc683c9cc61b499fa7cdbf54e4d9ff35"/></a>
<a href="https://github.com/Mindinventory/image-collage-widget/blob/master/LICENSE" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/github/license/Mindinventory/image-collage-widget"></a>
<a href="https://pub.dev/packages/image_collage_widget"><img src="https://img.shields.io/pub/v/image_collage_widget?color=as&label=image-collage-widget&logo=as1&logoColor=blue&style=social"></a>
<a href="https://github.com/Mindinventory/image-collage-widget"><img src="https://img.shields.io/github/stars/Mindinventory/image-collage-widget?style=social" alt="MIT License"></a>

A flutter package for creating photo collages in your applications.

## Key Features

* Create 11 different type of collages.
* Start with or without images from gallery preloaded (Only for Android).
* Allow user to add or remove photo into collage.
* User can update images from gallery/camera.
* Don't worry about `permissions`, we handled it.

## Preview
![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/center_big_fr.png?raw=true "Title")  ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/left_big_rf.png?raw=true "Title")   ![image](https://github.com/Mindinventory/image-collage-widget/blob/master/media/v_split_rf.png?raw=true "Title")

## Usage

* Step 1:- To use this package, add `image_collage_widget ` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

    ```yaml
        dependencies:
          ...
          image_collage_widget: ^1.0.6
    ```


* Step 2:- Prepare AndroidManifest.xml

   ```
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-feature android:name="android.hardware.camera" />

    <!-- Devices running Android 13 (API level 33) or higher -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

    <!-- To handle the reselection within the app on devices running Android 14
         or higher if your app targets Android 14 (API level 34) or higher.  -->
    <uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED" />
  
   ```

  * Step 3:- Prepare Info.plist

     ```
         <key>NSPhotoLibraryUsageDescription</key>
         <string>Need to access photo library</string>
         <key>NSCameraUsageDescription</key>
         <string>To upload your picture</string>
     ```

    * Step 4:- Add `ImageCollageWidget` in your dart file

      ```
            import 'package:image_collage_widget/image_collage_widget.dart';
            import 'package:image_collage_widget/utils/collage_type.dart';
        
            ...
        
         /// @param withImage:- If withImage = true, It will load image from given {filePath (default = "Camera")}
         /// @param collageType:- CollageType.CenterBig

                 child: ImageCollageWidget(
                   collageType: widget.collageType,
                   withImage: true,
                   filePath: _directory?.path?.toString(),
                 ),

      ```

### Dependencies

* [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view): ^0.7.0
* [flutter_bloc](https://pub.dev/packages/flutter_bloc): ^8.1.6
* [file_manager](https://pub.dev/packages/file_manager): ^1.0.2
* [file_picker](https://pub.dev/packages/file_picker): ^8.1.2
* [permission_handler](https://pub.dev/packages/permission_handler): ^11.3.1
* [image_picker](https://pub.dev/packages/image_picker): ^1.1.2
* [equatable](https://pub.dev/packages/equatable): ^2.0.5
* [device_info_plus](https://pub.dev/packages/device_info_plus): ^10.1.2

## Guideline for contributors

* Contribution towards our repository is always welcome, we request contributors to create a pull
  request for development.

## Guideline to report an issue/feature request

It would be great for us if the reporter can share the below things to understand the root cause of
the issue.

* Library version
* Code snippet
* Logs if applicable
* Device specification like (Manufacturer, OS version, etc)
* Screenshot/video with steps to reproduce the issue
* Library used

## LICENSE!

**image_collage_widget** is [MIT-licensed.](https://github.com/Mindinventory/image-collage-widget/blob/master/LICENSE)

## Let us know!

We’d be really happy if you send us links to your projects where you use our open-source libraries.
Just send an email to [sales@mindinventory.com](mailto:sales@mindinventory.com) And do let us know
if you have any questions or suggestion regarding our work.

Visit our website [mindinventory.com.](https://www.mindinventory.com)

Let us know if you are interested to building Apps or Designing Products.
<p><a href="https://www.mindinventory.com/contact-us.php?utm_source=gthb&utm_medium=repo&utm_campaign=image-collage-widget" target="__blank">
<img src="https://github.com/Mindinventory/image-collage-widget/blob/master/assets/have_a_project_button.png?raw=true" width="203" height="43"  alt="flutter app development">
</a></p>