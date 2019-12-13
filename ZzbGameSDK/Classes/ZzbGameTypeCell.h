//
//  ZzbGameTypeCell.h
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/2.
//

#import <UIKit/UIKit.h>
#import "ZzbTypeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TypeView : UIView
@property (nonatomic, copy) void(^TypeClickBlock)(NSInteger type,NSString *title);
@end

@interface ZzbGameTypeCell : UITableViewCell
@property (nonatomic, copy) void(^TypeClickBlock)(NSInteger type,NSString *title);

- (void)setModel:(ZzbTypeListModel*)model;
@end

NS_ASSUME_NONNULL_END
