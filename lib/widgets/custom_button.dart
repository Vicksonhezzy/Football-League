import 'package:flutter/material.dart';
import 'package:sbc_league/core/utils/size_utils.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  ButtonShape? shape;

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shadowColor: _setTextButtonShadowColor(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingAll9:
        return getPadding(all: 5);
      case ButtonPadding.PaddingT13:
        return getPadding(top: 13, right: 13, bottom: 13);
      default:
        return getPadding(all: 10);
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.FillBluegray900:
        return Colors.grey.shade900;
      case ButtonVariant.LoginButton:
        return Colors.green.shade600;
      case ButtonVariant.OutlineGray90033:
        return Colors.blue.shade900;
      case ButtonVariant.OutlineGray90033_1:
        return Colors.blue.shade900;
      case ButtonVariant.OutlineBlack90033:
        return Colors.blue.shade900;
      case ButtonVariant.OutlineBlue900:
        return null;
      default:
        return Colors.blue.shade900;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineBlue900:
        return BorderSide(
          color: Colors.blue.shade900,
          width: getHorizontalSize(1.00),
        );
      default:
        return null;
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      // case ButtonVariant.OutlineGray90033:
      //   return ColorConstant.gray90033;
      // case ButtonVariant.OutlineGray90033_1:
      //   return ColorConstant.gray90033;
      // case ButtonVariant.OutlineBlack90033:
      //   return ColorConstant.black90033;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.CircleBorder20:
        return BorderRadius.circular(
          getHorizontalSize(20.00),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(5.00),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.SintonyBold13:
        return TextStyle(
          color: Colors.white70,
          fontSize: getFontSize(18),
          fontFamily: 'Sintony',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(1.31),
        );
      case ButtonFontStyle.SintonyBold1088:
        return TextStyle(
          color: Colors.white70,
          fontSize: getFontSize(10.88),
          fontFamily: 'Sintony',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(1.38),
        );
      case ButtonFontStyle.SintonyBold10Blue900:
        return TextStyle(
          color: Colors.blue.shade900,
          fontSize: getFontSize(10),
          fontFamily: 'Sintony',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(1.40),
        );
      default:
        return TextStyle(
          color: Colors.white70,
          fontSize: getFontSize(13),
          fontFamily: 'Sintony',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(1.40),
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder5,
  CircleBorder20,
}

enum ButtonPadding {
  PaddingAll13,
  PaddingAll9,
  PaddingT13,
}

enum ButtonVariant {
  FillBlue900,
  FillBluegray900,
  LoginButton,
  OutlineGray90033,
  OutlineGray90033_1,
  OutlineBlack90033,
  OutlineBlue900,
}

enum ButtonFontStyle {
  SintonyBold10,
  SintonyBold13,
  SintonyBold1088,
  SintonyBold10Blue900,
}
