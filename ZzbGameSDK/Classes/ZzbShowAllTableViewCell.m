//
//  ZzbShowAllTableViewCell.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import "ZzbShowAllTableViewCell.h"
#import "ZzbHeader.h"
#import  "UIImageView+WebCache.h"

@implementation ZzbShowAllTableViewCell {
    UIImageView *iconView;
    UILabel *nameLab;
    UILabel *desLab;
    UIButton *collectBtn;
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
            make.top.equalTo(self.contentView).offset([ZzbPx px:15.5]);
            make.size.mas_equalTo(CGSizeMake([ZzbPx px:64], [ZzbPx px:64]));
        }];
        NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
        //iconView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
        
        nameLab = [[UILabel alloc] init];
        nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        nameLab.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        //nameLab.text = @"开心消消乐";
        [self.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:93.5]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:33]);
            make.right.equalTo(self.contentView).offset([ZzbPx px:-120]);
        }];
        
        desLab = [[UILabel alloc] init];
        desLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        desLab.font = [UIFont fontWithName:@"PingFang SC" size: 11];
        //desLab.text = @"即时战斗 容易上手";
        [self.contentView addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([ZzbPx px:93.5]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:56]);
            make.right.equalTo(self.contentView).offset([ZzbPx px:-120]);
        }];
        
        _kuangView = [[UIImageView alloc] init];
        _kuangView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_kuang" ofType:@"png"]];
        [self.contentView addSubview:_kuangView];
        [_kuangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset([ZzbPx px:-15.5]);
            make.top.equalTo(self.contentView).offset([ZzbPx px:37]);
            make.size.mas_equalTo(CGSizeMake([ZzbPx px:100], [ZzbPx px:28]));
        }];

        _btnCollect = [[UIButton alloc] init];
        [self.contentView addSubview:_btnCollect];
        [_btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
            make.width.mas_equalTo([ZzbPx px:38]);
        }];
        
        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang" ofType:@"png"]];
        [collectBtn setImage:image forState:UIControlStateNormal];
        [self.contentView addSubview:collectBtn];
        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset([ZzbPx px:-27.5]);
            //make.top.equalTo(self.contentView).offset([ZzbPx px:43.5]);
            make.centerY.equalTo(self.kuangView);
            //make.size.mas_equalTo(CGSizeMake([ZzbPx px:14.5], [ZzbPx px:12]));
        }];
        
        [collectBtn addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
        [_btnCollect addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
 
    }
    return self;
}

-(void)setModel:(ZzbShowAllModel *)model{
    nameLab.text = model.appletInfo.title;
    desLab.text = model.appletInfo.desc;
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
    [iconView sd_setImageWithURL:[[NSURL alloc]initWithString:model.appletInfo.iconPath] placeholderImage:image];
}

-(void)setCollect:(BOOL)isCollect{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    if (isCollect){
        UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang2" ofType:@"png"]];
        [collectBtn setImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_shoucang" ofType:@"png"]];
        [collectBtn setImage:image forState:UIControlStateNormal];
    }
}


//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{

}

- (void)clickCollectButton{
    NSLog(@"clickCollectButton");
    if (_collectButtonBlock) {
        _collectButtonBlock();
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

