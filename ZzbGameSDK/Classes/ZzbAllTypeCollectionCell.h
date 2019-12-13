//
//  ZzbAllTypeCollectionCell.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import <UIKit/UIKit.h>
#import "ZzbTypeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZzbAllTypeCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIView *kuangView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *title1Lab;
@property(nonatomic,strong)UILabel *title2Lab;
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)UIImageView *markView;

-(void)setModel:(ZzbTypeModel*)model;

@end

NS_ASSUME_NONNULL_END
