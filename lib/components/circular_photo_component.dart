import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CircularPhotoComponent extends StatelessWidget {
  final File? image;
  final String? url;
  final bool smallCircularProgressIndicator;
  final bool byTotalBytes;
  const CircularPhotoComponent({Key? key, this.url, this.image, this.smallCircularProgressIndicator = false, this.byTotalBytes = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(500)),
      child: Container(
        color: themeProvider.isDarkMode ? imageBackgroundDarkColor : imageBackgroundLightColor,
        child: url != null
            ? Image.network(
                url ?? ImageAssetKeys.launcherIcon,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Transform.scale(
                      scale: smallCircularProgressIndicator ? 0.5 : 1.0,
                      child: CircularProgressIndicator(
                        value: byTotalBytes
                            ? (loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)
                            : null,
                      ),
                    ),
                  );
                },
              )
            : image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.cover,
                  )
                : null,
      ),
    );
  }
}
