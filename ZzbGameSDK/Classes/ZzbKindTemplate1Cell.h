//
//  ZzbKindTemplate1Cell.h
//  Pods
//
//  Created by mywl on 2019/11/29.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface Template1View : UIView
@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);
@end

@interface ZzbKindTemplate1Cell : UITableViewCell


@property (nonatomic, copy) void(^ShowAllByModule)(NSInteger moduleid);
@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);

- (void)setStyleId:(NSInteger)_moduleid;
- (void)setModel:(NSArray<ZzbShowAllModel> *)applets;
@end

NS_ASSUME_NONNULL_END
