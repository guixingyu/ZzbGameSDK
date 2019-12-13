//
//  ZzbPx.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/28.
//

#import "ZzbPx.h"
#import "ZzbDefine.h"
@implementation ZzbPx
+(CGFloat)px:(CGFloat)value {
    return value/375*ZZBSCREEN_WIDTH;
}
@end
