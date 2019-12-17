//
//  ZzbGameManager.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/7.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZzbGameManager : NSObject
@property(nonatomic,strong)NSString *app_id;
@property(nonatomic,strong)NSString *app_key;
+ (ZzbGameManager *)sharedManager;
-(void)setGameAppId:(NSString*)appid andAppKey:(NSString*)appkey;
-(UINavigationController*)createGameNavController;
@end

NS_ASSUME_NONNULL_END
