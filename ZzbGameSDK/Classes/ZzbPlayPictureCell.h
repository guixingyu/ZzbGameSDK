//
//  ZzbPlayPictureCell.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/6.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#include "ZzbPlayPictureModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZzbPlayPictureCell : UITableViewCell
@property (nonatomic, copy) void(^selectPictureBlock)(ZzbPictureInfoModel *model);
- (void)setModel:(ZzbPlayPictureModel*)model;
@end

NS_ASSUME_NONNULL_END
