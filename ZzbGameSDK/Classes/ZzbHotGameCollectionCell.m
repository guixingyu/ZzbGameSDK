//
//  ZzbHotGameCollectionCell.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/2.
//

#import "ZzbHotGameCollectionCell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"
@implementation ZzbHotGameCollectionCell{
    UIImageView *imgIcon;
    UILabel *labelName;
    UILabel *labelPlayer;
	
    ZzbShowAllModel *_appModel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView {
    imgIcon = [[UIImageView alloc] init];
    imgIcon.frame = ZZBCGRectMake(0,0,64,64);
    [self.contentView addSubview:imgIcon];

	
    labelName = [[UILabel alloc] init];
    labelName.frame = ZZBCGRectMake(0, 64, 108.5, 30);
    labelName.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    labelName.font =  [UIFont fontWithName:@"PingFang SC" size: 16];
    labelName.text = @"开心消消乐";
    labelName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelName];
	
	labelPlayer = [[UILabel alloc] init];
    labelPlayer.frame = ZZBCGRectMake(0, 95, 108.5, 10.5);
    labelPlayer.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    labelPlayer.font =  [UIFont fontWithName:@"PingFang SC" size: 11];
    labelPlayer.text = @"143万人在线玩";
    labelPlayer.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelPlayer];
}

- (void)setModel:(ZzbShowAllModel*)model{
	_appModel = model;
	labelName.text = model.appletInfo.title;
	
	 NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
    [imgIcon sd_setImageWithURL:[[NSURL alloc]initWithString:model.appletInfo.iconPath] placeholderImage:image];
	
	//[imgIcon sd_setImageWithURL:model.appletInfo.iconPath];
}

@end
