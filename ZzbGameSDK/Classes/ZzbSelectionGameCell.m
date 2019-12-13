//
//  ZzbSelectionGameCell.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/11/29.
//

#import "ZzbSelectionGameCell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"
@implementation ZzbSelectionGameCell{
	UIImageView *imgIcon;
    UILabel *labelName;
    UILabel *labelPlayers;
	UILabel *labelDesc;
	
	UIImageView *imgKuang;
	UIImageView *imgCollect;
    UILabel *labelWan;
	
	UIButton *btnPlay;
	UIButton *btnCollect;
	NSArray<ZzbShowAllModel> *_apps;
	ZzbShowAllModel *_model;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:imgIcon];
		
		

        labelName = [[UILabel alloc] init];
        labelName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        labelName.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        labelName.text = @"开心消消乐";
        [self.contentView addSubview:labelName];
		
        labelPlayers = [[UILabel alloc] init];
        labelPlayers.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        labelPlayers.font = [UIFont fontWithName:@"PingFang SC" size: 11];
        labelPlayers.text = @"143万人玩过";
        [self.contentView addSubview:labelPlayers];
		[labelPlayers mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self->labelName.mas_right).offset([ZzbPx px:9.5]);
			make.top.equalTo(self.contentView).offset([ZzbPx px:193]);
		}];
		
        labelDesc = [[UILabel alloc] init];
        labelDesc.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        labelDesc.font = [UIFont fontWithName:@"PingFang SC" size: 11];
        labelDesc.text = @"即时战斗 容易上手 老少皆宜";
        [self.contentView addSubview:labelDesc];
		
		imgKuang = [[UIImageView alloc] init];
		NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_kuang" ofType:@"png"]];
		[imgKuang setImage:image];
		[self.contentView addSubview:imgKuang];
		[imgKuang mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-15.5]);
			make.bottom.equalTo(self.contentView).offset([ZzbPx px:-20.5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:100], [ZzbPx px:28]));
		}];
		
		imgCollect = [[UIImageView alloc] init];
		bundle = [NSBundle bundleForClass:self.classForCoder];
		image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang" ofType:@"png"]];
		[imgCollect setImage:image];
		[self.contentView addSubview:imgCollect];
		[imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-26.5]);
			make.bottom.equalTo(self.contentView).offset([ZzbPx px:-24.5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:17], [ZzbPx px:17]));
		}];
		
		btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btnPlay];
		[btnPlay addTarget:self action:@selector(BtnPlayClick) forControlEvents:UIControlEventTouchUpInside];
		[btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(self.contentView);
			make.height.equalTo(self.contentView);
		}];

        btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btnCollect];
        [btnCollect addTarget:self action:@selector(BtnCollectClick) forControlEvents:UIControlEventTouchUpInside];
		[btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView);
			make.bottom.equalTo(self.contentView).offset([ZzbPx px:-24.5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:53], [ZzbPx px:17]));
		}];
 
    }
    return self;
}

//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{
    //CGFloat a = [ZzbPx px:(15)];
    //printf("\na==========%f\n",a);
	
    imgIcon.frame = ZZBCGRectMake(15,2,345,174);
	
    imgIcon.layer.masksToBounds = YES;
    imgIcon.layer.cornerRadius = [ZzbPx px:4];

	
    labelName.frame = ZZBCGRectMake(22.5,191.5,100,15);
    //labelPlayers.frame = ZZBCGRectMake(105,196,100,10.5);
    labelDesc.frame = ZZBCGRectMake(22.5,214.5,200,10.5);
    //btnPlay.frame = ZZBCGRectMake(262.5,195,97,25);

}

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets{
	_apps = applets;
	

	ZzbShowAllModel *model = _apps[0];
	_model = model;
	labelName.text = model.appletInfo.title;
	labelDesc.text = model.appletInfo.desc;
	
	NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
	UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 2" ofType:@"png"]];
	[imgIcon sd_setImageWithURL:[[NSURL alloc]initWithString:model.cfgImgPath] placeholderImage:image];

}

-(void)setCollect:(BOOL)isCollect{
    if (isCollect){
		NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang2" ofType:@"png"]];
		[imgCollect setImage:image];
    }
    else{
		NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang" ofType:@"png"]];
		[imgCollect setImage:image];
    }
}

- (void)BtnPlayClick{
    NSLog(@"clickCollectButton");
    if (self.playButtonBlock) {
		self.playButtonBlock(_model);
    }
}

- (void)BtnCollectClick{
    NSLog(@"clickCollectButton");
    if (self.collectButtonBlock) {
		self.collectButtonBlock(_model);
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
