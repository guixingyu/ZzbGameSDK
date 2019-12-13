//
//  ZzbSelectionGameCell.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/11/29.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

//typedef void(^SelectionBlock)(NSString *);
@interface ZzbSelectionGameCell : UITableViewCell

@property (nonatomic, copy) void(^collectButtonBlock)(ZzbShowAllModel *model);
@property (nonatomic, copy) void(^playButtonBlock)(ZzbShowAllModel *model);
- (void)setModel:(NSArray<ZzbShowAllModel> *)applets;
- (void)setCollect:(BOOL)isCollect;
@end

NS_ASSUME_NONNULL_END
