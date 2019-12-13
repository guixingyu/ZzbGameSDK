//
//  ZzbHotGameRecommendCell.h
//  Pods
//
//  Created by mywl on 2019/12/2.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZzbHotGameRecommendCell : UITableViewCell
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets;
@end

NS_ASSUME_NONNULL_END
