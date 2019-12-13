//
//  ZzbPlayPictureModel.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/5.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN


@protocol ZzbPictureModel;

@interface ZzbPictureModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imgPath;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *iconPath;
@property (nonatomic) NSString *appletKey;
@property (nonatomic) NSString *appletAlias;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger personCount;
@end

@protocol ZzbPictureInfoModel;
@interface ZzbPictureInfoModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *webUrl;
@property (nonatomic) NSInteger modelId;
@property (nonatomic) NSString *modelName;
@property (nonatomic) NSInteger sort;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *updateTime;
@property (nonatomic) ZzbPictureModel<Optional> *appletInfo;
@end

@interface ZzbPlayPictureModel : JSONModel
@property (nonatomic) BOOL success;
@property (nonatomic) NSString *code;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *imgAddr;
@property (nonatomic) NSString *videoAddr;
@property (nonatomic) BOOL fetchAll;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSArray <ZzbPictureInfoModel> *data;
@end


NS_ASSUME_NONNULL_END
