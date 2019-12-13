//
//  ZzbNewGameRecommendCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/11/28.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZzbNewGameRecommendCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets;

@property (nonatomic, copy) void(^SelectionBlock)(ZzbShowAllModel *model);
@end

NS_ASSUME_NONNULL_END
