//
//  ReqPacker.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReqPacker : NSObject
-(instancetype)init:(NSString*)addr;
-(void)addParam:(NSString*)param withString:(NSString*)value;
-(void)addParam:(NSString*)param withInt:(NSInteger)value;
-(void)addParam:(NSString*)param withFloat:(CGFloat)value;
-(NSDictionary*)getParam;
-(NSString*)getPostUrl;
-(void)setPostStr:(NSString*)str;
@end

NS_ASSUME_NONNULL_END
