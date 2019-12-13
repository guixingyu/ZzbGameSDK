//
//  ZzbLoginModel.h
//  ZzbGameSDK
//
//  Created by haoyang yu on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol LoginModel;

@interface LoginModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString <Optional> *mobile;
@property (nonatomic) NSString  *rememberToken;
@property (nonatomic) NSString  *uuid;
@end

@interface ZzbLoginModel : JSONModel
@property (nonatomic) BOOL success;
@property (nonatomic) NSString  *code;
//@property (nonatomic) NSString  *description;
@property (nonatomic) NSString  *imgAddr;
@property (nonatomic) NSString  *videoAddr;
@property (nonatomic) LoginModel *data;
@end

NS_ASSUME_NONNULL_END
