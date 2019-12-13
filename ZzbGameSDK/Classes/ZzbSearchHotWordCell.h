//
//  ZzbSearchHotWordCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/6.
//

#import <UIKit/UIKit.h>
#import "ZzbHotWordListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^HotWordClickBlock) (NSInteger);
@interface ZzbSearchHotWordCell : UITableViewCell
@property (nonatomic, assign)BOOL isInit;
@property (nonatomic,copy) HotWordClickBlock hotWordClickBlock;
-(void)setModel:(ZzbHotWordListModel*)model;
@end

NS_ASSUME_NONNULL_END
