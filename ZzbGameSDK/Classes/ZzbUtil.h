//
//  ZzbUtil.h
//  ZzbGameSDK
//
//  Created by haoyang yu on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import "ZzbShowAllListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZzbUtil : NSObject
+(void)handleEnterGame:(NSInteger)appid andAppkey:(NSString*)appkey;
+(void)sendGameRunTime:(NSString*)bodyStr;
@end

NS_ASSUME_NONNULL_END
