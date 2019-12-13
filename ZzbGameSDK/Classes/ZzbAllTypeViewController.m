//
//  ZzbAllTypeViewController.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import "ZzbAllTypeViewController.h"
#import "ZzbHeader.h"
#import "ZzbAllTypeCollectionCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ZzbTypeListModel.h"
#import "ZzbShowAllViewController.h"
#import "MJRefresh.h"
#import "ReqPacker.h"
@interface ZzbAllTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView *collView;
@property(nonatomic,strong) ZzbTypeListModel *zzbTypeListModel;
@end

@implementation ZzbAllTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    [self setNavi];
    [self setupUI];
    [self getData];
}

- (void)setNavi {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_return" ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.title = @"全部类型";
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (ZZBSCREEN_WIDTH - [ZzbPx px:60])/2;
    layout.itemSize = CGSizeMake(itemWidth, [ZzbPx px:68.5]);
    // 设置最小行间距
    layout.minimumLineSpacing = [ZzbPx px:22];
    // 设置垂直间距
    layout.minimumInteritemSpacing = [ZzbPx px:16];
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat collHeight = self.view.bounds.size.height - NavigationHeight - [ZzbPx px:10];
    _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [ZzbPx px:10], ZZBSCREEN_WIDTH, collHeight) collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor whiteColor];
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    [_collView registerClass:[ZzbAllTypeCollectionCell class] forCellWithReuseIdentifier:@"ZzbAllTypeCollectionCell"];
    [self.view addSubview:_collView];
    __weak ZzbAllTypeViewController * that = self;
    _collView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [that refresh];
    }];
    /*
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, [ZzbPx px:-10], ZZBSCREEN_WIDTH, [ZzbPx px:10]);
    header.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    [_collView addSubview:header];
    _collView.contentInset = UIEdgeInsetsMake([ZzbPx px:10], 0, 0, 0);*/
    
}

-(void)refresh {
    [self getData];
}

-(void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@type",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: 1];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"true"];
    NSDictionary *prarm = [req getParam];
    __weak ZzbAllTypeViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"请求成功：%@",responseObject);
        //NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (that){
            ZzbAllTypeViewController *ctrl = that;
            [ctrl->_collView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^(){
                ZzbTypeListModel * model = [[ZzbTypeListModel alloc] initWithDictionary:responseObject error:nil];
                if (model.success){
                    ctrl->_zzbTypeListModel = model;
                    [ctrl->_collView reloadData];
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZzbAllTypeViewController *ctrl = that;
        [ctrl->_collView.mj_header endRefreshing];
    }];
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_zzbTypeListModel){
        return _zzbTypeListModel.data.count;
    }
    return 0;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZzbAllTypeCollectionCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZzbAllTypeCollectionCell" forIndexPath:indexPath];
    if(_zzbTypeListModel){
        [collcell setModel:_zzbTypeListModel.data[indexPath.row]];
    }
    return collcell;
}

// MARK: - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake([ZzbPx px:16], [ZzbPx px:22], [ZzbPx px:16], [ZzbPx px:16]);
}

// MARK: - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZzbTypeModel *model = _zzbTypeListModel.data[indexPath.row];
    ZzbShowAllViewController *vc = [[ZzbShowAllViewController alloc] init];
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:YES];
    [vc setTypeId:model.id];
}

@end

