//
//  ZzbGameTypeCell.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/2.
//

#import "ZzbGameTypeCell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"
@implementation TypeView{
	UIView *viewBg;
    UIImageView *imgIcon;
    UILabel *labelName;
    UIButton *btnType;
	
    int iconId;
    NSInteger _index;
    NSArray *arrayColors;
    NSArray *arrayGameName;
    NSArray *arrayIconName;
    ZzbTypeModel *_model;
}

- (instancetype)initWithFrame:(CGRect)frame {

	iconId = 0;

	arrayGameName = @[@"体育",@"卡牌",@"休闲益智",@"竞速",@"射击",@"角色扮演"] ;
	
	arrayIconName = @[@"icon_tiyu",@"icon_kapai",@"icon_xiuxian",@"icon_jingsu",@"icon_sheji",@"icon_juese"];
    self = [super initWithFrame:frame];
    if (self) {
		
		viewBg = [[UIView alloc] init];

		viewBg.layer.cornerRadius = 10;
		[self addSubview:viewBg];

		labelName = [[UILabel alloc] init];
		labelName.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
		labelName.font =  [UIFont fontWithName:@"PingFang SC" size: 12];
		labelName.textAlignment = NSTextAlignmentCenter;
		[self addSubview:labelName];
		[labelName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset([ZzbPx px:12]);
			make.right.equalTo(self.mas_right).offset([ZzbPx px:0]);
			make.width.offset([ZzbPx px:85]);
		}];

		imgIcon = [[UIImageView alloc] init];
		[self addSubview:imgIcon];
		[imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset([ZzbPx px:10]);
			make.right.equalTo(self->labelName.mas_left).offset([ZzbPx px:5]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:20], [ZzbPx px:20]));
		}];
		
        btnType = [UIButton buttonWithType:UIButtonTypeCustom];
        NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
        [self addSubview:btnType];
        [btnType addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickCollectButton{
    NSLog(@"clickCollectButton");
	if (self.TypeClickBlock){
		self.TypeClickBlock(_model.id,_model.name);
	}
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
	viewBg.frame = ZZBCGRectMake(0,0,111,40);
	//imgIcon.frame = ZZBCGRectMake(14,10,20,20);
	//labelName.frame = ZZBCGRectMake(35, 14, 70, 11.5);
	btnType.frame = ZZBCGRectMake(0, 0, 111, 40);
}

- (void)setIndex:(int)index{
	_index = index;
	switch(index){
		case 0:
			viewBg.backgroundColor = ZZBColorFromRGB(0x9571F2);
			break;
		case 1:
			viewBg.backgroundColor = ZZBColorFromRGB(0x1FBDFF);
			break;
		case 2:
			viewBg.backgroundColor = ZZBColorFromRGB(0xFF9042);
			break;
		case 3:
			viewBg.backgroundColor = ZZBColorFromRGB(0x57D96C);
			break;
		case 4:
			viewBg.backgroundColor = ZZBColorFromRGB(0xFFBD23);
			break;
		case 5:
			viewBg.backgroundColor = ZZBColorFromRGB(0xFD7CA9);
			break;
		default:
			break;
	}
	
}

- (void)setModel:(ZzbTypeModel*)model{
	_model = model;
	NSString *strGamecount;
	strGamecount = model.gameCount>99 ? @"99+":[NSString stringWithFormat: @"%ld", (long)model.gameCount];
	labelName.text = [NSString stringWithFormat:@"%@(%@)",model.name,strGamecount];

	NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
	UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/pic_default 1" ofType:@"png"]];
	[imgIcon sd_setImageWithURL:[[NSURL alloc]initWithString:model.miconPath] placeholderImage:image];
	
}

@end

@implementation ZzbGameTypeCell{
	NSMutableArray <TypeView *> *viewArray;
	ZzbTypeListModel *listModel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		viewArray = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < 6; i++) {
			TypeView *view = [[TypeView alloc] init];
			[view setIndex:i];
			[self addSubview:view];
			[viewArray addObject:view];
			view.TypeClickBlock = ^(NSInteger type,NSString* title){
				if (self.TypeClickBlock) {
					self.TypeClickBlock(type,title);
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
		viewArray[i].frame = ZZBCGRectMake(15+column*(111+6),row*58,111,40);
	}
}

- (void)setModel:(ZzbTypeListModel*)model {
	listModel = model;
	for (int i = 0; i < listModel.data.count; i++){
		if (i >= viewArray.count){
			break;
		}
		[viewArray[i] setModel:listModel.data[i]];
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
