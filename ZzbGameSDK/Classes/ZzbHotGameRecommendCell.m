//
//  ZzbHotGameRecommendCell.m
//  Pods
//
//  Created by mywl on 2019/12/2.
//

#import "ZzbHotGameRecommendCell.h"
#import "ZzbHeader.h"
#import "ZzbHotGameCollectionCell.h"
#import "UIImageView+WebCache.h"
@implementation ZzbHotGameRecommendCell{
    UICollectionView *_collView;
    NSArray<ZzbShowAllModel> *_apps;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([ZzbPx px:100], [ZzbPx px:121]);
        // 设置最小行间距
        layout.minimumLineSpacing = [ZzbPx px:10];
        // 设置垂直间距
        //layout.minimumInteritemSpacing = 10;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZZBSCREEN_WIDTH, [ZzbPx px:121]) collectionViewLayout:layout];
        _collView.backgroundColor = [UIColor whiteColor];
        _collView.showsHorizontalScrollIndicator = NO;
        _collView.delegate = self;
        _collView.dataSource = self;
        [_collView registerClass:[ZzbHotGameCollectionCell class] forCellWithReuseIdentifier:@"ZzbHotGameCollectionCell"];
        [self.contentView addSubview:_collView];
		
    }
    return self;
}

- (void)setModel:(NSArray<ZzbShowAllModel> *)applets{
	_apps = applets;
	[_collView reloadData];
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (_apps == nil) {
		return 0;
	}
	else {
		return _apps.count;
	}
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    ZzbHotGameCollectionCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZzbHotGameCollectionCell" forIndexPath:indexPath];
	[collcell setModel:_apps[indexPath.row]];
    return collcell;
}

// MARK: - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([ZzbPx px:100], [ZzbPx px:121]);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}
// MARK: - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.SelectionBlock) {
        self.SelectionBlock(_apps[indexPath.row]);
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
