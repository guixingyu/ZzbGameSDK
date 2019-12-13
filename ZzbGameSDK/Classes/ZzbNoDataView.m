//
//  ZzbNoDataView.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/6.
//

#import "ZzbNoDataView.h"
#import "ZzbHeader.h"
@implementation ZzbNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initview];
    }
    return self;
}

-(void)initview {
    _noDataImg = [[UIImageView alloc] init];
    [self addSubview:_noDataImg];
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    _noDataImg.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/noData" ofType:@"png"]];
    [_noDataImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset([ZzbPx px:150]);
    }];
    
    _desLab = [[UILabel alloc] init];
    _desLab.textAlignment = NSTextAlignmentCenter;
    _desLab.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    _desLab.textColor = ZZBColorWithRGBA(153, 153, 153, 1.0);
    [self addSubview:_desLab];
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.noDataImg.mas_bottom).offset([ZzbPx px:29]);
    }];
    _desLab.text = @"暂无数据";
}

-(void)setDes:(NSString*)des {
    _desLab.text = des;
}

@end
