
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/extension/image_type_extension.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';
import 'custom_avatar.dart';

class ImageView extends StatelessWidget {
  ImageView({
    super.key,
    required this.imagePath,
    this.name,
    this.id,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = const FaIcon(FontAwesomeIcons.cameraRetro),
    this.errorListener,
    this.isExpanded = false,
    this.showControls = true,
    this.autoPlay = false,
    this.showErrorWidget = false,
  }) : errorWidget = name != null ? CustomAvatar(name: name) : null;

  final String imagePath;
  final String? id;
  final String? name;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Icon placeHolder;
  final Widget? errorWidget;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool showControls;
  final bool autoPlay;
  final bool showErrorWidget;
  final void Function(Object)? errorListener;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  Widget _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    switch (imagePath.imageType) {
      case ImageType.svg:
        return SizedBox(
          height: height,
          width: width,
          child: SvgPicture.asset(
            imagePath,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: (context) => Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(color: AppColors.backGround),
            ),
            colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          ),
        );
      case ImageType.networkSvg:
        if (isExpanded) {
          return Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.network(
              imagePath,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              placeholderBuilder: (context) => Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(color: AppColors.backGround),
              ),
              colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
            ),
          );
        } else {
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.network(
              imagePath,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
              placeholderBuilder: (context) => Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(color: AppColors.backGround),
              ),
            ),
          );
        }
      case ImageType.networkPng:
        if (isExpanded) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  imagePath,
                  errorListener: errorListener,
                ),
                colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.color),
                fit: fit,
              ),
            ),
            child: showErrorWidget ? errorWidget : null,
          );
        } else {
          return CachedNetworkImage(
            fit: fit,
            height: height,
            width: width,
            imageUrl: imagePath,
            color: color,
            errorWidget: (_, __, ___) => errorWidget ?? Icon(Icons.image_outlined, color: color ?? AppColors.red),
            placeholder: (context, url) => Skeletonizer(
              effect: ShimmerEffect(
                baseColor: Colors.grey[300]!,
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                highlightColor: Colors.grey[100]!,
                duration: const Duration(milliseconds: 400),
              ),
              enabled: true,
              child: SizedBox(
                height: AppHeight.h40,
                width: AppWidth.w40,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.r10),
                  ),
                  value: 1,
                  color: AppColors.backGround,
                  backgroundColor: AppColors.lightGrey,
                ),
              ),
            ),
          );
        }
      case ImageType.file:
        return Image.file(
          File(imagePath),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
     
      case ImageType.empty:
        return Icon(Icons.image_outlined, color: color ?? AppColors.red);
      case ImageType.png:
      default:
        return Image.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
    }
  }
}

