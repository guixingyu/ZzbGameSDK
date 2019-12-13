//
//  ZzbKindTemplate1Cell.m
//  Pods
//
//  Created by mywl on 2019/11/29.
//

#import "ZzbKindTemplate1Cell.h"
#import "UIImageView+WebCache.h"
#import "ZzbHeader.h"
@implementation Template1View{
	UIImageView *imgGame;
    UILabel *labelName;
	UIView * viewGray;
	UIButton *btnGame;
	ZzbShowAllModel *_model;
}

- (instancetype)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {
		
        imgGame = [[UIImageView alloc] init];
        [self addSubview:imgGame];
		
		viewGray = [[UIView alloc] init];
		[self addSubview:viewGray];
		
        labelName = [[UILabel alloc] init];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        labelName.font = [UIFont fontWithName:@"PingFang SC" size: 12];
        labelName.text = @"开心消消乐";
        [self addSubview:labelName];


        btnGame = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnGame];
        [btnGame addTarget:self action:@selector(btnGameClick) forControlEvents:UIControlEventTouchUpInside];
		[btnGame mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.offset([ZzbPx px:0]);
			make.left.offset([ZzbPx px:0]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:109], [ZzbPx px:70]));
		}];
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
	
	imgGame.frame = ZZBCGRectMake(0,2,109,70);
    imgGame.layer.masksToBounds = YES;
    imgGame.layer.cornerRadius = [ZzbPx px:4];

    viewGray.frame = ZZBCGRectMake(0,48,109,24);
	viewGray.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
	viewGray.layer.cornerRadius = 4;
	labelName.frame = ZZBCGRectMake(0,48,109,24);
}

- (void)setModel:(ZzbShowAllModel*)model{
	_model = model;
	labelName.text = model.appletInfo.title;


	NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
	UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 4" ofType:@"png"]];
	[imgGame sd_setImageWithURL:[[NSURL alloc]initWithString:model.cfgImgPath] placeholderImage:image];
}

@end

@implementation ZzbKindTemplate1Cell{

	NSMutableArray <Template1View *> *viewArray;
    UIButton *btnCollect;
	NSInteger _moduleid;
    NSArray<ZzbShowAllModel> *_apps;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		viewArray = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < 4; i++) {
			Template1View *view = [[Template1View alloc] init];
			view.hidden = true;
			[self.contentView addSubview:view];
			[viewArray addObject:view];
			view.SelectionBlock = ^(ZzbShowAllModel *model){
				NSLog(@"xxxx1111");
				if (self.SelectionBlock) {
					self.SelectionBlock(model);
				}
			};
		}
		
		UIView *viewOther = [[UIView alloc] init];
		viewOther.layer.masksToBounds = YES;
		viewOther.layer.cornerRadius = [ZzbPx px:10];
		viewOther.backgroundColor = ZZBColorWithRGBA(255, 201, 52, 1);
		[self.contentView addSubview:viewOther];
		[viewOther mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-15]);
			make.top.equalTo(self.contentView).offset([ZzbPx px:87.5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:227], [ZzbPx px:70]));
		}];
		
		UIImageView *imgOther1 = [[UIImageView alloc] init];
		NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_1" ofType:@"png"]];
		[imgOther1 setImage:image];
		[viewOther addSubview:imgOther1];
		[imgOther1 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(viewOther).offset([ZzbPx px:9.5]);
			make.top.equalTo(viewOther).offset([ZzbPx px:7]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:61], [ZzbPx px:56]));
		}];
		
		UIImageView *imgOther2 = [[UIImageView alloc] init];
		bundle = [NSBundle bundleForClass:self.classForCoder];
		image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/icon_gengduo" ofType:@"png"]];
		[imgOther2 setImage:image];
		[viewOther addSubview:imgOther2];
		[imgOther2 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(viewOther).offset([ZzbPx px:192.5]);
			make.top.equalTo(viewOther).offset([ZzbPx px:24]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:22], [ZzbPx px:22]));
		}];
		
		UILabel *labelOther1 = [[UILabel alloc] init];
        labelOther1.textAlignment = NSTextAlignmentCenter;
        labelOther1.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        labelOther1.font = [UIFont fontWithName:@"PingFang SC" size: 12];
        labelOther1.text = @"其他游戏";
        [viewOther addSubview:labelOther1];
		[labelOther1 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(viewOther).offset([ZzbPx px:80.5]);
			make.top.equalTo(viewOther).offset([ZzbPx px:22]);
		}];
		
		UILabel *labelOther2 = [[UILabel alloc] init];
        labelOther2.textAlignment = NSTextAlignmentCenter;
        labelOther2.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        labelOther2.font = [UIFont fontWithName:@"PingFang SC" size: 8];
        labelOther2.text = @"查看更多";
        [viewOther addSubview:labelOther2];
		[labelOther2 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(viewOther).offset([ZzbPx px:81.5]);
			make.top.equalTo(viewOther).offset([ZzbPx px:40]);
		}];
		
        btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.contentView addSubview:btnCollect];
        [btnCollect addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
 		[btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-15]);
			make.top.equalTo(self.contentView).offset([ZzbPx px:87.5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:227], [ZzbPx px:70]));
		}];
    }
    return self;
}
- (void)setStyleId:(NSInteger)_moduleid {
	_moduleid = _moduleid;
}

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets{
	_apps = applets;
	for (int i = 0; i < _apps.count; i++){
		if (i < 4) {
			viewArray[i].hidden = false;
			[viewArray[i] setModel:_apps[i]];
		}
	}
}

- (void)clickCollectButton{
    NSLog(@"clickCollectButton");
    if (self.ShowAllByModule) {
		self.ShowAllByModule(_moduleid);
	}

}

//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{

	for (int i = 0; i<viewArray.count; i++) {
		int column = i%3;
		int row = i/3;
		viewArray[i].frame = ZZBCGRectMake(15+column*(109+9.5),row*85.5,109,70);
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
