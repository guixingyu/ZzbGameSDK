//
//  ZzbNewGameCollectionCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/11/28.
//

#import <UIKit/UIKit.h>
#import "ZzbModuleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZzbNewGameCollectionCell : UICollectionViewCell
- (void)setModel:(ZzbShowAllModel *)model index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
