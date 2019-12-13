//
//  ZzbNewGameCollectionCell.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/28.
//

#import "ZzbNewGameCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ZzbHeader.h"
//#import <Masonry/Masonry.h>

@implementation ZzbNewGameCollectionCell{
    UIImageView *iconView;
    UIView *viewBg;
    UILabel *nameLab;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView {
    iconView = [[UIImageView alloc] init];
    iconView.frame = ZZBCGRectMake(0, 0, 108.5, 110.25);
    //iconView.backgroundColor = ZZBColorWithRGBA(255, 178, 52, 1);
	UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:iconView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
	
	CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
	cornerRadiusLayer.frame = iconView.bounds;
	cornerRadiusLayer.path = cornerRadiusPath.CGPath; iconView.layer.mask = cornerRadiusLayer;
    [self.contentView addSubview:iconView];

	viewBg = [[UIView alloc] init];
	viewBg.frame = ZZBCGRectMake(0,110.25,108.5,43.25);
	cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:viewBg.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
	cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
	cornerRadiusLayer.frame = viewBg.bounds;
	cornerRadiusLayer.path = cornerRadiusPath.CGPath; viewBg.layer.mask = cornerRadiusLayer;
	[self.contentView addSubview:viewBg];
	
    nameLab = [[UILabel alloc] init];
    nameLab.frame = ZZBCGRectMake(0, 110.25, 108.5, 43.25);
    nameLab.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    nameLab.font =  [UIFont fontWithName:@"PingFang SC" size: 15];
    nameLab.text = @"开心消消乐";
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLab];
	
	
	
}

- (void)setModel:(ZzbShowAllModel *)model index:(NSInteger)index{
	nameLab.text = model.appletInfo.title;
	
	NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
	UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 3" ofType:@"png"]];
	[iconView sd_setImageWithURL:[[NSURL alloc]initWithString:model.cfgImgPath] placeholderImage:image];

	
	NSInteger colorIndex = (index+1)%3;
	switch(colorIndex) {
		case 0:
			viewBg.backgroundColor = ZZBColorWithRGBA(126, 118, 253, 1);
			break;
		case 1:
			viewBg.backgroundColor = ZZBColorWithRGBA(255, 178, 52, 1);
			break;
		case 2:
			viewBg.backgroundColor = ZZBColorWithRGBA(245, 119, 79, 1);
			break;
		default:break;
	}
}

@end


