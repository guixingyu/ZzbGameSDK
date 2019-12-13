//
//  ZzbWorthyGameCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import <UIKit/UIKit.h>
#import "ZzbShowAllListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZzbWorthyGameCell : UITableViewCell

@property (nonatomic, copy) void(^collectButtonBlock)(ZzbShowAllModel *model);
@property (nonatomic, copy) void(^playButtonBlock)(ZzbShowAllModel *model);
-(void)setModel:(NSInteger)index model:(ZzbShowAllModel*)model;
-(void)setCollect:(BOOL)isCollect;
@end

NS_ASSUME_NONNULL_END
