//
//  ZzbShowAllTableViewCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import <UIKit/UIKit.h>
#import "ZzbShowAllListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CollectButtonBlock) (void);
@interface ZzbShowAllTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView* kuangView;
@property (nonatomic,strong) UIButton* btnCollect;
@property (nonatomic,copy) CollectButtonBlock collectButtonBlock;
-(void)setModel:(ZzbShowAllModel*)model;
-(void)setCollect:(BOOL)isCollect;
@end

NS_ASSUME_NONNULL_END
