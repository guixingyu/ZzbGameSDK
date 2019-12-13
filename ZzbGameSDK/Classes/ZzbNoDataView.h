//
//  ZzbNoDataView.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZzbNoDataView : UIView
@property(nonatomic,strong) UIImageView* noDataImg;
@property(nonatomic,strong) UILabel* desLab;
-(void)setDes:(NSString*)des;
@end

NS_ASSUME_NONNULL_END
