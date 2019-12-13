//
//  DemoPlugin.h
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//


#import <webappexts/webappexts.h>

@interface DemoPlugin : WAWebPlugin
@property (nonatomic, copy) void(^showSplash)(void);
@property (nonatomic, copy) void(^showBanner)(void);
@property (nonatomic, copy) void(^showInterstitial)(void);
@property (nonatomic, copy) void(^showRewardedVideo)(void);

-(void)responseHandle:(BOOL)success id:(NSString*)id;
@end
