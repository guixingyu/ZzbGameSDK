//
//  ZzbTypeListModel.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/3.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol ZzbTypeModel;

@interface ZzbTypeModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString  *name;
@property (nonatomic) NSString  *enName;
@property (nonatomic) NSInteger gameCount;
@property (nonatomic) NSString  *siconPath;
@property (nonatomic) NSString  *miconPath;
@property (nonatomic) NSString  *biconPath;
@end

@interface ZzbTypeListModel : JSONModel
@property (nonatomic) BOOL success;

@property (nonatomic) NSString  *code;
@property (nonatomic) NSString  *description;
@property (nonatomic) NSString  *imgAddr;
@property (nonatomic) NSString  *videoAddr;

@property (nonatomic) BOOL fetchAll;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSArray <ZzbTypeModel> *data;
@end

NS_ASSUME_NONNULL_END
