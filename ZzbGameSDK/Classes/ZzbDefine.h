//
//  ZzbDefine.h
//  ZzbGameSDK
//
//  Created by haoyang yu on 2019/12/11.
//

#ifndef ZzbDefine_h
#define ZzbDefine_h
#import "ZzbPx.h"

#define ZZBSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define ZZBSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define ZZBColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:1.0]



#define ZZBColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define ZZBCGRectMake(x,y,width,height) CGRectMake([ZzbPx px:x], [ZzbPx px:y], [ZzbPx px:width], [ZzbPx px:height])

#define ZZBISIPHONEX (UIApplication.sharedApplication.statusBarFrame.size.height >20 ? YES : NO)

#define NavigationHeight (ZZBISIPHONEX ? 88.0 : 64.0)
#define TabbarHeight (ZZBISIPHONEX ? 83.0 : 49.0)

#define HOST_URL @"https://gpsdk.17la.com"
#define apiUrl @"https://gpsdk.17la.com/api/"

#define ZzbCollectKey @"Zzb_CollectKey"
#define ZzbMineGameKey @"Zzb_MineGameKey"
#define ZzbRunGameId @"zzb_runGameId"
#define ZzbRunGameTime @"zzb_runGameTime"
#define ZzbEnterBackground @"ZzbEnterBackground"
#define ZzbEnterForeground @"ZzbEnterForeground"

#endif /* ZzbDefine_h */
