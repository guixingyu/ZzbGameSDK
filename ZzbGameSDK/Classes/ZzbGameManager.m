//
//  ZzbGameManager.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/7.
//

#import "ZzbGameManager.h"
#import "ZzbGameMainViewController.h"
#import "ZzbRootNavViewController.h"
@interface ZzbGameManager()

@end

@implementation ZzbGameManager

static ZzbGameManager *__zzbGameManager;

+ (ZzbGameManager *)sharedManager{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __zzbGameManager = [[ZzbGameManager alloc] init];
        
    });
    return __zzbGameManager;
}

+ (void)initialize {
    [ZzbGameManager sharedManager];
}

+ (instancetype)alloc {
    if (__zzbGameManager) {
        return  __zzbGameManager;
    }
    return [super alloc];
}

-(void)setGameAppId:(NSString*)appid andAppKey:(NSString*)appkey{
    _app_id = appid;
    _app_key = appkey;
}

-(ZzbRootNavViewController*)createGameNavController {
    ZzbGameMainViewController *vc = [[ZzbGameMainViewController alloc] init];
    ZzbRootNavViewController *nav = [[ZzbRootNavViewController alloc] initWithRootViewController:vc];
    return nav;
}

@end
