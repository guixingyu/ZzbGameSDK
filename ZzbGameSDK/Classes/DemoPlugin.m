//
//  DemoPlugin.m
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "DemoPlugin.h"
#import "ZzbGameRunTimeModel.h"
#import "ZzbUtil.h"
#import "ZzbDefine.h"

@implementation DemoPlugin {
	WAWebPluginBlock _block;
}

- (id)init {
    self = [super initWithName:@"demo"];
    
    
    
    return self;
}

- (void)process:(id)input block:(WAWebPluginBlock)block {
    /*
	_block = block;
	NSString *type = input;
	if ([type isEqualToString:@"splash_show"]) {
		if(self.showSplash){
			self.showSplash();
		}

	}
	else if([type isEqualToString:@"banner_show"]) {
		if(self.showBanner){
			self.showBanner();
		}
	}
	else if([type isEqualToString:@"interstitial_show"]) {
		if(self.showInterstitial){
			self.showInterstitial();
		}
	}
	else if([type isEqualToString:@"rewarded_video_show"]) {
		if(self.showRewardedVideo){
			self.showRewardedVideo();
		}
	}*/
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Demo"
//                                                                   message:input
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
//                                              style:UIAlertActionStyleDefault
//                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                block(@{
//                                                        @"success": @(YES),
//                                                        @"id": @"12345"
//                                                        });
//                                            }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
//                                              style:UIAlertActionStyleCancel
//                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                block(@{@"success": @(NO)});
//                                            }]];
//    [self.webViewController presentViewController:alert
//                                         animated:YES
//                                       completion:nil];
}

-(void)responseHandle:(BOOL)success id:(NSString*)id {
	_block(@{
		@"res": @(success),
		@"id": @"12345"
	});
}

-(void)ready {
    NSDate *datenow = [NSDate date];
    NSInteger time = [datenow timeIntervalSince1970];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *gameID = [ud objectForKey:ZzbRunGameId];
    ZzbGameRunTimeModel * model = [[ZzbGameRunTimeModel alloc] init];
    model.recordId = [gameID integerValue];
    model.startTime = time;
    NSString *string = [model toJSONString];
    [ud setObject:string forKey:ZzbRunGameTime];
}

-(void)unload{
    NSDate *datenow = [NSDate date];
    NSInteger time = [datenow timeIntervalSince1970];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *gametime = [ud objectForKey:ZzbRunGameTime];
    
    NSMutableArray <NSString*> *arr;
    NSArray *array = [gametime componentsSeparatedByString:@"-"];
    arr = [[NSMutableArray alloc] initWithArray:array];
    NSString *str = arr[arr.count-1];
    ZzbGameRunTimeModel *model = [[ZzbGameRunTimeModel alloc] initWithString:str error:nil];
    model.endTime = time;
    NSString *string = [model toJSONString];
    [arr removeObjectAtIndex:arr.count-1];
    [arr addObject:string];
    
    NSMutableArray *sendArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        NSData *data = [arr[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic allKeys] containsObject:@"recordId"] && [[dic allKeys] containsObject:@"startTime"] && [[dic allKeys] containsObject:@"endTime"]){
            [sendArr addObject:dic];
        }
    }
    if (sendArr.count > 0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * bodyStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"bodyStr----->:%@",bodyStr);
        [ZzbUtil sendGameRunTime:bodyStr];
    }
    else{
         [ud setObject:@"" forKey:ZzbRunGameId];
         [ud setObject:@"" forKey:ZzbRunGameTime];
    }
}


@end
