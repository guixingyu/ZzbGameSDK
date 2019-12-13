//
//  ZzbShowAllListModel.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/3.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AppletInfoModel;

@interface AppletInfoModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imgPath;
@property (nonatomic) NSString <Optional> *desc;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString <Optional> *tag;
@property (nonatomic) NSString *iconPath;
@property (nonatomic) NSString *appletKey;
@property (nonatomic) NSString *appletAlias;
@end

@protocol ZzbShowAllModel;

@interface ZzbShowAllModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger modelId;
@property (nonatomic) NSString *cfgImgPath;
//@property (nonatomic) NSInteger sort;
@property (nonatomic) AppletInfoModel *appletInfo;
@end

@interface ZzbShowAllListModel : JSONModel
@property (nonatomic) NSString *code;
@property (nonatomic) BOOL success;
@property (nonatomic) BOOL fetchAll;
@property (nonatomic) NSString *imgAddr;
@property (nonatomic) NSString *videoAddr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSArray <ZzbShowAllModel> *data;
@end

NS_ASSUME_NONNULL_END
