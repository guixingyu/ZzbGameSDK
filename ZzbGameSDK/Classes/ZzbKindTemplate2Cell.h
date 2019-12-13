//
//  ZzbKindTemplate2Cell.h
//  Pods
//
//  Created by mywl on 2019/11/29.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface Template2View : UIView
@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);
@end

@interface ZzbKindTemplate2Cell : UITableViewCell
@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets;

@end

NS_ASSUME_NONNULL_END
