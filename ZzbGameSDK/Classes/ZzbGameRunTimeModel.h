//
//  ZzbGameRunTimeModel.h
//  ZzbGameSDK
//
//  Created by haoyang yu on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZzbGameRunTimeModel : JSONModel
@property (nonatomic) NSInteger recordId;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;
@end

NS_ASSUME_NONNULL_END
