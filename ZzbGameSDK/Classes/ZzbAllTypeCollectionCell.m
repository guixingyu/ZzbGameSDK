//
//  ZzbAllTypeCollectionCell.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import "ZzbAllTypeCollectionCell.h"
#import "ZzbHeader.h"
#import  "UIImageView+WebCache.h"
@implementation ZzbAllTypeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}


-(void)setUpAllChildView {
    _kuangView = [[UIView alloc] init];
    _kuangView.backgroundColor = [UIColor colorWithRed:248/255.0 green:247/255.0 blue:252/255.0 alpha:1.0];
    [self.contentView addSubview:_kuangView];
    [_kuangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    _kuangView.layer.cornerRadius = [ZzbPx px:18];
    
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset([ZzbPx px:2.5]);
        make.size.mas_equalTo(CGSizeMake([ZzbPx px:63.5], [ZzbPx px:63.5]));
    }];
    
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    _iconView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
    
    
    _title1Lab = [[UILabel alloc] init];
    _title1Lab.font = [UIFont fontWithName:@"PingFang SC" size: [ZzbPx px:17]];
    _title1Lab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_title1Lab];
    [_title1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([ZzbPx px:79]);
        make.top.equalTo(self.contentView).offset([ZzbPx px:10.5]);
        make.height.mas_equalTo([ZzbPx px:16]);
    }];
    //_title1Lab.text = @"竞速";
    
    _title2Lab = [[UILabel alloc] init];
    _title2Lab.font = [UIFont fontWithName:@"PingFang SC" size: 10];
    _title2Lab.textColor = ZZBColorWithRGBA(136, 136, 137, 1.0);
    [self.contentView addSubview:_title2Lab];
    [_title2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([ZzbPx px:79]);
        make.top.equalTo(self.contentView).offset([ZzbPx px:29.5]);
    }];
    //_title2Lab.text = @"Race";
    
    _countLab = [[UILabel alloc] init];
    _countLab.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    _countLab.textColor = ZZBColorWithRGBA(136, 136, 137, 1.0);
    [self.contentView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([ZzbPx px:79]);
        make.top.equalTo(self.contentView).offset([ZzbPx px:52]);
    }];
    //_countLab.text = @"45款";
    
    _markView = [[UIImageView alloc] init];
    [self.contentView addSubview:_markView];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset([ZzbPx px:-9]);
        make.bottom.equalTo(self.contentView).offset([ZzbPx px:-4]);
        make.size.mas_equalTo(CGSizeMake([ZzbPx px:13], [ZzbPx px:13]));
    }];
    _markView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/mark_1" ofType:@"png"]];
}

-(void)setModel:(ZzbTypeModel*)model {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
    [_iconView sd_setImageWithURL:[[NSURL alloc]initWithString:model.biconPath] placeholderImage:image];
    _title1Lab.text = model.name;
    _title2Lab.text = model.enName;
    if(model.gameCount > 99){
        _countLab.text = @"99+款";
    }
    else{
       _countLab.text = [NSString stringWithFormat:@"%ld款",(long)model.gameCount];
    }
    [_markView sd_setImageWithURL:[[NSURL alloc]initWithString:model.siconPath] placeholderImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/mark_1" ofType:@"png"]]];
}

@end
