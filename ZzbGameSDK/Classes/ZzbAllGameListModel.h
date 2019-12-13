//
//  ZzbAllGameListModel.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol GameModel
@end
@interface GameModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imgPath;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *iconPath;
@property (nonatomic) NSString *appletKey;
@property (nonatomic) NSString *appletAlias;

@end

@protocol GameInfoModel
@end
@interface GameInfoModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger modelId;
@property (nonatomic) NSString *cfgImgPath;
@property (nonatomic) GameModel *appletInfo;

@end

@interface ZzbAllGameListModel : JSONModel
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
@property (nonatomic) NSArray <GameInfoModel> *data;
@end

NS_ASSUME_NONNULL_END
