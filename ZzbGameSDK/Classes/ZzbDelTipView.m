//
//  ZzbDelTipView.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import "ZzbDelTipView.h"
#import "ZzbHeader.h"
@implementation ZzbDelTipView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ZZBColorWithRGBA(0, 0, 0, 0.3);
        [self initview];
    }
    return self;
}

-(void)initview {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 10;
    _backView.layer.masksToBounds = YES;
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset([ZzbPx px:43.5]);
        make.right.equalTo(self).offset([ZzbPx px:-43.5]);
        make.height.mas_equalTo([ZzbPx px:178]);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont fontWithName:@"PingFang SC" size: 18];
    _titleLab.textColor = ZZBColorWithRGBA(51, 51, 51, 1.0);
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset([ZzbPx px:46]);
        make.left.right.equalTo(self.backView);
    }];
    
    
    _desLab = [[UILabel alloc] init];
    _desLab.font = [UIFont fontWithName:@"PingFang SC" size: 11];
    _desLab.textColor = ZZBColorWithRGBA(153, 153, 153, 1.0);
    _desLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_desLab];
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset([ZzbPx px:74.5]);
        make.left.right.equalTo(self.backView);
    }];
    
    
    _cancleBtn = [[UIButton alloc] init];
    _cancleBtn.backgroundColor = ZZBColorWithRGBA(239, 239, 239, 1.0);
    [_cancleBtn setTitle:@"否" forState: UIControlStateNormal];
    [_cancleBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: [ZzbPx px:12]]];
    [_cancleBtn setTitleColor:ZZBColorWithRGBA(153, 153, 153, 1.0) forState: UIControlStateNormal];
    _cancleBtn.layer.cornerRadius = 4;
    [_backView addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset([ZzbPx px:-32.5]);
        make.left.equalTo(self.backView).offset([ZzbPx px:20.5]);
        make.size.mas_equalTo(CGSizeMake([ZzbPx px:111], [ZzbPx px:30]));
    }];
    [_cancleBtn addTarget:self action:@selector(clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
   
    _sureBtn = [[UIButton alloc] init];
    _sureBtn.backgroundColor = ZZBColorWithRGBA(239, 136, 0, 1.0);
    [_sureBtn setTitle:@"是" forState: UIControlStateNormal];
    [_sureBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: [ZzbPx px:12]]];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    _sureBtn.layer.cornerRadius = 4;
    [_backView addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset([ZzbPx px:-32.5]);
        make.right.equalTo(self.backView).offset([ZzbPx px:-20.5]);
        make.size.mas_equalTo(CGSizeMake([ZzbPx px:111], [ZzbPx px:30]));
    }];
    [_sureBtn addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setTitle:(NSString*)title {
     _titleLab.text = title;
}

-(void)setDes:(NSString*)des {
    _desLab.text = des;
}

-(void)clickCancleButton {
    [self removeFromSuperview];
}

-(void)clickSureButton {
    if (self.didClickSureBlock) {
        self.didClickSureBlock();
    }
    [self removeFromSuperview];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
