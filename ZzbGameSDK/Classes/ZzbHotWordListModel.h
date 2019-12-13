//
//  ZzbHotWordListModel.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol HotWordModel;

@interface HotWordModel : JSONModel
@property (nonatomic) NSString  *hotWord;
@property (nonatomic) NSInteger searchCount;
@end

@interface ZzbHotWordListModel : JSONModel
@property (nonatomic) BOOL success;
@property (nonatomic) NSString  *code;
@property (nonatomic) NSString  *imgAddr;
@property (nonatomic) NSString  *videoAddr;
@property (nonatomic) NSArray <HotWordModel> *data;
@end

NS_ASSUME_NONNULL_END
