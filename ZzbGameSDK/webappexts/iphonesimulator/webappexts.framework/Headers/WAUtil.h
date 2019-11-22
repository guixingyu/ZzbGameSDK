//
//  MHUtil.h
//  webapps
//
//  Created by Gen2 on 2019/1/13.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "symbols.h"


#define RGB(COLOR) [UIColor colorWithRed:((0x##COLOR >> 16) & 0xff)/255.0 \
green:((0x##COLOR >> 8) & 0xff)/255.0 \
blue:((0x##COLOR >> 0) & 0xff)/255.0 \
alpha:1]

#define RGBA(COLOR) [UIColor colorWithRed:((0x##COLOR >> 24) & 0xff)/255.0 \
green:((0x##COLOR >> 16) & 0xff)/255.0 \
blue:((0x##COLOR >> 8) & 0xff)/255.0 \
alpha:((0x##COLOR >> 0) & 0xff)/255.0]

#define Avisible(VERSION) ([[[UIDevice currentDevice] systemVersion]compare:@#VERSION  options:NSNumericSearch]!=NSOrderedAscending)

#define _SafeArea(Orientation) ({ \
UIEdgeInsets insets; \
if (Avisible(11.0)) { \
insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets; \
if (UIInterfaceOrientationIsPortrait(Orientation)) { insets.top = MAX(insets.top, 20); } \
}else { \
insets = (UIInterfaceOrientationIsPortrait(Orientation) ? UIEdgeInsetsMake(20, 0, 0, 0) : UIEdgeInsetsMake(0, 0, 0, 0)); \
}\
insets; \
})

#define STATIC(Class, name) Class##_##name

#define SafeArea _SafeArea(UIApplication.sharedApplication.statusBarOrientation)

#define MainFontB(S) [UIFont boldSystemFontOfSize:S]
#define MainFont(S) [UIFont systemFontOfSize:S]

@interface WAUtil : NSObject

+ (UIColor *)colorFromCSS:(NSString *)css;
+ (id)launchSettings:(NSString *)path;
+ (NSData *)dataWithObject:(id)object;
+ (UIImage *)loadImage:(NSString *)base64;
+ (UIImage *)loadImageWithName:(NSString *)name withBundle:(NSString *)bundle;
+ (NSString *)text:(NSDictionary *)dic;

@end
