//
//  ZzbSearchHotWordCell.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/6.
//

#import "ZzbSearchHotWordCell.h"
#import "ZzbHeader.h"

@implementation ZzbSearchHotWordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initview];
    }
    return self;
}

-(void)initview {
    
}


-(void)setModel:(ZzbHotWordListModel*)model {
    if (_isInit) {return;}
    _isInit = YES;
    NSLog(@"setModelsetModelsetModel");
    UILabel *title = [[UILabel alloc] init];
    title.textColor = ZZBColorWithRGBA(51, 51, 51, 1.0);
    title.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    title.frame = CGRectMake([ZzbPx px:15], [ZzbPx px:13], [ZzbPx px:100], [ZzbPx px:13.5]);
    [self.contentView addSubview:title];
    title.text = @"热门搜索";
    
    CGFloat btnX = [ZzbPx px:17.5];
    CGFloat btnY = [ZzbPx px:40];
    int rowNum = 1;
    for (int i = 0; i< model.data.count; i++) {
        HotWordModel *model1 = model.data[i];
        UIButton *btn = [self createHotSearchBtn:model1.hotWord];
        [btn setTag: i];
        [btn addTarget:self action:@selector(clickHotWord:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnWidth = [self widthForString:model1.hotWord fontSize:12 andHeight:[ZzbPx px:30]];
        CGFloat btn_width = btnWidth + [ZzbPx px:26];
        if (btnX + btn_width > ZZBSCREEN_WIDTH - [ZzbPx px:17.5]){
            //换行
            btnY += ([ZzbPx px:40] + [ZzbPx px:10]);
            btnX = [ZzbPx px:17.5];
            rowNum += 1;
        }
        btn.frame = CGRectMake(btnX,btnY,btn_width,[ZzbPx px:30]);
        [self.contentView addSubview:btn];
        btnX += (btn_width + [ZzbPx px:10]);
    }
}

- (UIButton*)createHotSearchBtn:(NSString*) btnTitle {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];;
    btn.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    [btn setTitle:btnTitle forState: UIControlStateNormal];
    [btn setTitleColor:ZZBColorWithRGBA(53, 53, 53, 1) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 12]];
    btn.layer.cornerRadius = [ZzbPx px:15];
    return btn;
}

-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height{
    CGSize sizeToFit = [value sizeWithFont:[UIFont fontWithName:@"PingFang SC" size: fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.width;
}

-(void)clickHotWord:(UIButton*)sender {
    NSInteger btnTag = sender.tag;
    if (self.hotWordClickBlock) {
        self.hotWordClickBlock(btnTag);
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
