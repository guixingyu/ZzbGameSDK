//
//  WAEBundle.h
//  extensions
//
//  Created by Gen2 on 2019/9/17.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WABundle : NSObject

+ (UIImage *)loadImageWithName:(NSString *)name withBundle:(NSString *)bundle;

@end

NS_ASSUME_NONNULL_END
