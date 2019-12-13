//
//  ZzbModuleListModel.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/3.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "ZzbShowAllListModel.h"
NS_ASSUME_NONNULL_BEGIN
/***************首页-模块列表**************/
////app真实信息
//@protocol AppInfo
//
//@end
//@interface AppInfo: JSONModel
//@property (nonatomic) NSInteger id;
//@property (nonatomic) NSString  *title;
//@property (nonatomic) NSString  *imgPath;
//@property (nonatomic) NSString  *desc;
//@property (nonatomic) NSInteger type;
//@property (nonatomic) NSString<Optional>  *tag;
//@property (nonatomic) NSString  *iconPath;
//@property (nonatomic) NSString  *appletKey;
//@property (nonatomic) NSString  *appletAlias;
//@end
//
//
//
//
////app在模块中的信息
//
//@protocol AppModel
//
//@end
//@interface AppModel : JSONModel
//@property (nonatomic) NSInteger id;
//@property (nonatomic) NSInteger  modelId;
//@property (nonatomic) NSString  *cfgImgPath;
//@property (nonatomic) AppInfo *appletInfo;
//@end
//


//模块信息
@protocol ModuleItemModel
@end
@interface ModuleItemModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString  *name;
@property (nonatomic) NSInteger sort;
@property (nonatomic) NSInteger styleId;
@property (nonatomic) BOOL readMore;
@property (nonatomic) BOOL hide;
@property (nonatomic) NSString  *createTime;
@property (nonatomic) NSString  *updateTime;
@property (nonatomic) NSArray<ZzbShowAllModel> *applets;
@end



@interface ZzbModuleListModel : JSONModel
@property (nonatomic) BOOL success;
@property (nonatomic) NSString<Optional> *code;
@property (nonatomic) NSString<Optional> *description;
@property (nonatomic) NSString<Optional> *imgAddr;
@property (nonatomic) NSString<Optional> *videoAddr;
@property (nonatomic) BOOL fetchAll;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSArray<ModuleItemModel> *data;
@end

/*********************************************/


NS_ASSUME_NONNULL_END
