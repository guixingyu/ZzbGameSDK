//
//  ZzbKindTemplate2Cell.m
//  Pods
//
//  Created by mywl on 2019/11/29.
//

#import "ZzbKindTemplate2Cell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"

@implementation Template2View{
	UIView *viewBg;
    UIImageView *imgIcon;
    UILabel *labelName;
    UILabel *labelPlayer;
    UIButton *btnGame;
	
    ZzbShowAllModel *_model;
}

- (instancetype)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {
		
		viewBg = [[UIView alloc] init];
		viewBg.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:251/255.0 alpha:1];
		//viewBg.layer.cornerRadius = 10;


		[self addSubview:viewBg];
		
		imgIcon = [[UIImageView alloc] init];
		//imgIcon.layer.cornerRadius = 10;
		[self addSubview:imgIcon];
		
		
		labelName = [[UILabel alloc] init];
		
		labelName.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
		labelName.font =  [UIFont fontWithName:@"PingFang SC" size: 16];
		labelName.text = @"开心消消乐";
		labelName.textAlignment = NSTextAlignmentCenter;
		[self addSubview:labelName];
		
		labelPlayer = [[UILabel alloc] init];
		
		labelPlayer.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
		labelPlayer.font =  [UIFont fontWithName:@"PingFang SC" size: 11];
		labelPlayer.text = @"143万人在线玩";
		labelPlayer.textAlignment = NSTextAlignmentCenter;
		[self addSubview:labelPlayer];

		btnGame = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnGame];
        [btnGame addTarget:self action:@selector(btnGameClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnGameClick{
    NSLog(@"clickCollectButton");
    if (self.SelectionBlock) {
		self.SelectionBlock(_model);
    }
}

- (void)layoutSubviews {
	
    [super layoutSubviews];

	viewBg.frame = ZZBCGRectMake(15,115,108.5,55);
	UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:viewBg.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
	
	CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
	cornerRadiusLayer.frame = viewBg.bounds;
	cornerRadiusLayer.path = cornerRadiusPath.CGPath; viewBg.layer.mask = cornerRadiusLayer;

	imgIcon.frame = ZZBCGRectMake(15,0,108.5,115);
	cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:imgIcon.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
	
	cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
	cornerRadiusLayer.frame = imgIcon.bounds;
	cornerRadiusLayer.path = cornerRadiusPath.CGPath; imgIcon.layer.mask = cornerRadiusLayer;
	        
	labelName.frame = ZZBCGRectMake(15, 115, 108.5, 30);
	labelPlayer.frame = ZZBCGRectMake(15, 147, 108.5, 10.5);
	
	btnGame.frame = ZZBCGRectMake(0, 0, 108.5, 170);
}

- (void)setModel:(ZzbShowAllModel*)model{
	_model = model;
	labelName.text = model.appletInfo.title;
	
	NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
	UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 3" ofType:@"png"]];
	[imgIcon sd_setImageWithURL:[[NSURL alloc]initWithString:model.cfgImgPath] placeholderImage:image];
}

@end

@interface ZzbKindTemplate1Cell : UITableViewCell

@end


@implementation ZzbKindTemplate2Cell{
	NSMutableArray <Template2View *> *viewArray;
	NSArray<ZzbShowAllModel> *_apps;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		viewArray = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < 6; i++) {
			Template2View *view = [[Template2View alloc] init];
			view.hidden = true;
			[self addSubview:view];
			[viewArray addObject:view];
			view.SelectionBlock = ^(ZzbShowAllModel *model){
				if (self.SelectionBlock) {
					self.SelectionBlock(model);
				}
			};
		}

    }
    return self;
}

//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{
	for (int i = 0; i<viewArray.count; i++) {
		int column = i%3;
		int row = i/3;
		viewArray[i].frame = ZZBCGRectMake(column*(108.5+10),row*186,108.5,170);
	}
	

}

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets{
	_apps = applets;
	
	for (int i = 0; i < _apps.count; i++){
		if (i < 6) {
			viewArray[i].hidden = false;
			[viewArray[i] setModel:_apps[i]];
		}
	}
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
