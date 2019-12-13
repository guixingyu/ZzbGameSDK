//
//  ZzbPlayPictureCell.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/6.
//

#import "ZzbPlayPictureCell.h"
#import "ZzbHeader.h"
#import "UIImageView+WebCache.h"

@interface ZzbPlayPictureCell () <SDCycleScrollViewDelegate>

@end

@implementation ZzbPlayPictureCell{
	SDCycleScrollView *cycleScrollView;
	ZzbPlayPictureModel *_model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ZZBSCREEN_WIDTH, [ZzbPx px:168]) delegate:self placeholderImage:[UIImage imageNamed:@"PlacehoderImage.png"]];

		cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
		
		cycleScrollView.showPageControl = YES;
		cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;

		
		cycleScrollView.delegate = self;
		cycleScrollView.infiniteLoop = YES;
		cycleScrollView.autoScrollTimeInterval = 5;

		cycleScrollView.pageDotColor = [UIColor grayColor]; // 自定义分页控件小圆标颜色
		[self.contentView addSubview:cycleScrollView];

    }
    return self;
}

//重写layoutSubviews方法，给视图设置位置大小
- (void)layoutSubviews{
	[super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZzbPlayPictureModel*)model {
	_model = model;
	NSMutableArray *urlArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < model.data.count; i++){
		ZzbPictureInfoModel *pictureModel = model.data[i];
		[urlArray addObject:pictureModel.imageUrl];


	}

	cycleScrollView.imageURLStringsGroup = urlArray;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index

{
    NSLog(@"---点击了第%ld张图片", index);
	if(_selectPictureBlock) {
		ZzbPictureInfoModel *pictureModel = _model.data[index];
		_selectPictureBlock(pictureModel);
	}
}

@end
