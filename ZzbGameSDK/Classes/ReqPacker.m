//
//  ReqPacker.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/3.
//

#import "ReqPacker.h"
#import <CommonCrypto/CommonDigest.h>

@interface ReqPacker()
@property(nonatomic,strong)NSString* addr;
@property(nonatomic,strong)NSMutableDictionary* params;
@property(nonatomic,strong)NSString* postBodyStr;
@end

@implementation ReqPacker

-(instancetype)init:(NSString*)addr {
    self = [super init];
    if (self != nil){
        self.addr = addr;
        if (![self.addr hasSuffix:@"?"]){
            self.addr = [self.addr stringByAppendingString:@"?"];
            //NSLog(@"self.addr:%@",self.addr);
        }
        self.params = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma 添加请求参数
-(void)addParam:(NSString *)param withString:(NSString *)value {
    [self.params setValue:value forKey:param];
}

-(void)addParam:(NSString *)param withInt:(NSInteger)value {
    NSString *strValue = [NSString stringWithFormat: @"%ld", (long)value];
    [self.params setValue:strValue forKey:param];
}

-(void)addParam:(NSString *)param withFloat:(CGFloat)value {
    NSString *strValue = [NSString stringWithFormat: @"%f", value];
    [self.params setValue:strValue forKey:param];
}

//post请求设置请求bodyStr
-(void)setPostStr:(NSString*)str {
    self.postBodyStr = str;
}

-(NSString*)getPostUrl {
    if (self.postBodyStr) {
        [self checkParam];
        for (NSString *key in self.params) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,[self.params objectForKey:key]];
            self.addr = [self.addr stringByAppendingString:str];
            self.addr = [self.addr stringByAppendingString:@"&"];
        }
        //去掉最后一个&
        if ([self.addr hasSuffix:@"&"]){
            self.addr = [self.addr substringToIndex:([self.addr length]-1)];
        }
    }
    return self.addr;
}

-(void)checkParam {
    if (![self.params.allKeys containsObject:@"timestamp"]){
        NSDate *datenow = [NSDate date];
        long time = (long)([datenow timeIntervalSince1970]);
        [self addParam:@"timestamp" withInt:time];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"zzb_LoginToken"];
    if (token) {
        [self addParam:@"token" withString:token];
    }
    if (![self.params.allKeys containsObject:@"sign"]){
        NSString* sign = [self makeSign];
        [self addParam:@"sign" withString:sign];
    }
}

-(NSString*)makeSign {
    NSMutableArray <NSString*> *signparams = [[NSMutableArray alloc] init];
    for (NSString *key in self.params) {
        [signparams addObject:key];
    }
    //排序
    NSArray *sortedparams  = [signparams sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signSrc = @"";
    for (NSString *key in sortedparams) {
        signSrc = [NSString stringWithFormat:@"%@%@=%@", signSrc,key,[self.params objectForKey:key]];
    }
    if (self.postBodyStr){
        signSrc = [signSrc stringByAppendingString:self.postBodyStr];
    }
    signSrc = [signSrc stringByAppendingString:@"0086b44cf085c1b1"];
    NSString *sign = [[self md5:signSrc] lowercaseString];
    
    return sign;
}

-(NSDictionary*)getParam {
    [self makeUrlSign];
    return [[NSDictionary alloc] initWithDictionary:self.params];
}

-(void)makeUrlSign {
    [self checkParam];
}

-(NSString*)md5:(NSString*)signSrc{
    const char *cString = signSrc.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    NSMutableString *resultString = [[NSMutableString alloc]init];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [resultString appendFormat:@"%02x", result[i]];
    }
    return resultString;
}

@end
