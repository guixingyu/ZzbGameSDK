//
//  ZzbShowAllTableViewCell.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import "ZzbWorthyGameCell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"
@implementation ZzbWorthyGameCell {
	NSInteger ranking;
    UIImageView *iconView;
	
    UIImageView *imgRanking;
    UILabel *labelRanking;
	
    UILabel *nameLab;
    UILabel *desLab;

	UIImageView *imgKuang;
	UIImageView *imgCollect;
	UIButton *btnPlay;
	UIButton *btnCollect;
	
	ZzbShowAllModel *_model;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        iconView.layer.cornerRadius = [ZzbPx px:16];
        iconView.layer.masksToBounds = YES;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:15]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:1.5]);
            make.size.mas_equalTo(CGSizeMake([ZzbPx px:64], [ZzbPx px:64]));
        }];
        NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
        iconView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
		
        imgRanking = [[UIImageView alloc] init];
        [self.contentView addSubview:imgRanking];
        [imgRanking mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:93]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:17]);
            make.size.mas_equalTo(CGSizeMake([ZzbPx px:18], [ZzbPx px:18]));
        }];
		
		labelRanking = [[UILabel alloc] init];
		labelRanking.textAlignment = NSTextAlignmentCenter;
        labelRanking.textColor = ZZBColorWithRGBA(153,153,153,1);
        labelRanking.font = [UIFont fontWithName:@"PingFang SC" size: 12];
        [self.contentView addSubview:labelRanking];
        [labelRanking mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:87]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:17]);
            make.width.offset([ZzbPx px:30]);
        }];
		
        nameLab = [[UILabel alloc] init];
        nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        nameLab.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        //nameLab.text = @"开心消消乐";
        [self.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:120]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:14]);
			make.width.offset([ZzbPx px:140]);
        }];
		
        desLab = [[UILabel alloc] init];
        desLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        desLab.font = [UIFont fontWithName:@"PingFang SC" size: 11];
        desLab.text = @"即时战斗 容易上手";
        [self.contentView addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:120]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:42]);
            make.width.offset([ZzbPx px:140]);
        }];
		
        imgKuang = [[UIImageView alloc] init];
		bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_kuang" ofType:@"png"]];
		[imgKuang setImage:image];
		[self.contentView addSubview:imgKuang];
		[imgKuang mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-15.5]);
			make.top.equalTo(self.contentView).offset([ZzbPx px:21]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:100], [ZzbPx px:28]));
		}];
		
		imgCollect = [[UIImageView alloc] init];
		bundle = [NSBundle bundleForClass:self.classForCoder];
		image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang" ofType:@"png"]];
		[imgCollect setImage:image];
		[self.contentView addSubview:imgCollect];
		[imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset([ZzbPx px:-26.5]);
			make.top.equalTo(self.contentView).offset([ZzbPx px:25]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:17], [ZzbPx px:17]));
		}];
		
		btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btnPlay];
		[btnPlay addTarget:self action:@selector(BtnPlayClick) forControlEvents:UIControlEventTouchUpInside];
		[btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView);
			make.width.equalTo(self.contentView);
			make.height.equalTo(self.contentView);
		}];

        btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btnCollect];
        [btnCollect addTarget:self action:@selector(BtnCollectClick) forControlEvents:UIControlEventTouchUpInside];
		[btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView);
			make.top.equalTo(self.contentView).offset([ZzbPx px:21]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:53], [ZzbPx px:25]));
		}];
 
    }
    return self;
}

-(void)setModel:(NSInteger)index model:(ZzbShowAllModel*)model{
	_model = model;
	ranking = index;
	imgRanking.hidden = true;
	labelRanking.hidden = true;
	if (ranking < 3){
		imgRanking.hidden = false;
		NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
		UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource: [NSString stringWithFormat:@"ZzbGameSDK.bundle/icon_%ld", ranking+1 ] ofType:@"png"]];
		
		[imgRanking setImage:image];
	}
	else {
		labelRanking.hidden = false;
		labelRanking.text = [NSString stringWithFormat:@"%ld",ranking+1];
	}
	
    nameLab.text = model.appletInfo.title;
    desLab.text = model.appletInfo.desc;
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
    [iconView sd_setImageWithURL:[[NSURL alloc]initWithString:model.appletInfo.iconPath] placeholderImage:image];
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




//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{

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

