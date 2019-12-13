//
//  ZzbUtil.m
//  ZzbGameSDK
//
//  Created by haoyang yu on 2019/12/11.
//

#import "ZzbUtil.h"
#import "DemoViewController.h"
#import "ZzbDefine.h"
#import "ReqPacker.h"
#import <AFNetworking/AFNetworking.h>
@implementation ZzbUtil
+(void)handleEnterGame:(NSInteger)appid andAppkey:(NSString*)appkey{
    if (appid && appkey) {
        NSString *appidStr = [NSString stringWithFormat:@"%ld",(long)appid];
        NSLog(@"appid:%@",appidStr);
        [WAEMainViewController setup:@{@"id": [appidStr description],@"key": [appkey description]}];
        //启动游戏保存id到本地目录当中
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:appidStr forKey:ZzbRunGameId];
    }
}

+(void)sendGameRunTime:(NSString*)bodyStr {
    NSString *url = [NSString stringWithFormat:@"%@applet/duration",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    NSData *jsonData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setPostStr:bodyStr];
    url = [req getPostUrl];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    NSURLSessionDataTask *dt = [manager dataTaskWithRequest:request uploadProgress: nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"]) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:@"" forKey:ZzbRunGameId];
                [ud setObject:@"" forKey:ZzbRunGameTime];
            });
        }
    }];
    [dt resume];
    
}
@end
