enum ImageType { svg, png, networkSvg, networkPng, networkMp4, file, mp4, unknown, empty }

extension ImageTypeExtension on String {
  ImageType get imageType {
    final value = toLowerCase();

    if (value.isEmpty || value.endsWith('null')) return ImageType.empty;

    if (value.startsWith('http://') || value.startsWith('https://')) {
      if (value.endsWith('.svg')) {
        return ImageType.networkSvg;
      } else if (value.endsWith('.mp4')) {
        return ImageType.networkMp4;
      } else {
        return ImageType.networkPng;
      }
    }

    if (value.startsWith('file://') || value.startsWith('/data')) {
      if (value.endsWith('.mp4')) {
        return ImageType.mp4;
      } else {
        return ImageType.file;
      }
    }

    if (value.startsWith('assets/') || value.startsWith('packages/')) {
      if (value.endsWith('.svg')) {
        return ImageType.svg;
      } else if (value.endsWith('.mp4')) {
        return ImageType.mp4;
      } else {
        return ImageType.png;
      }
    }

    if (value.endsWith('.svg')) {
      return ImageType.networkSvg;
    } else if (value.endsWith('.mp4')) {
      return ImageType.networkMp4;
    }

    return ImageType.networkPng;
  }
}
