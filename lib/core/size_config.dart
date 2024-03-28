import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';


class SizeConfig{
  double get screenWidth{
    if(PlatformUtil.isWeb == false){
      return MediaQuery.of(globalContext).size.width;
    }else{
      int screenSize = window.screen?.width ?? 0;
      if(PlatformUtil.isDesktopWeb){
        if(screenSize > webMaxSize.width){
          return webMaxSize.width;
        }else{
          return screenSize.toDouble();
        }
      }else{
        return (screenSize ?? 0).toDouble();
      }
    }
  }

  double get screenHeight{
    if(PlatformUtil.isWeb == false){
      return MediaQuery.of(globalContext).size.height;
    }else{
      return window.screen?.height?.toDouble() ?? 0;
    }
  }

  Size get webMaxSize{
    if(PlatformUtil.isDesktopWeb){
      return const Size(600, 800);
    }else{
      return Size(screenWidth,screenHeight);
    }
  }

}

extension FontSizeExtension on double{
  double get fs{
    if(PlatformUtil.isDesktopWeb){
      return this;
    }else{
      return this*(SizeConfig().screenWidth/375);
    }
  }
}
