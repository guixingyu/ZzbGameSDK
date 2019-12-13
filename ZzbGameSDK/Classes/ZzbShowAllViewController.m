//
//  ZzbShowAllViewController.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import "ZzbShowAllViewController.h"
#import "ZzbShowAllTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ZzbShowAllListModel.h"
#import "ZzbHeader.h"
#import "DemoViewController.h"
#import "MJRefresh.h"
#import "ZzbNoDataView.h"
#import "ReqPacker.h"
#import "ZzbUtil.h"
@interface ZzbShowAllViewController () <UITableViewDelegate, UITableViewDataSource>
//@property(nonatomic,strong) ZzbShowAllListModel *zzbShowAllListModel;
@property(nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *allshowList;
@property(nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *collectList;
@property(nonatomic,assign) NSInteger gameTypeId;
@property(nonatomic,assign) NSInteger modelId;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSInteger totalPage;
@property(nonatomic,strong) ZzbNoDataView *noDataView;
@end

@implementation ZzbShowAllViewController{
    UITableView *_tableView;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    self.view.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    [self setupUI];
    _allshowList = [NSMutableArray array];
    _collectList = [NSMutableArray array];
    [self getCollectData];
}

-(void)setTypeId:(NSInteger)gameTypeId{
    _gameTypeId = gameTypeId;
    _currentPage = 1;
    [self getData];
}

-(void)setmodelId:(NSInteger)modelId{
    _modelId = modelId;
    _currentPage = 1;
    [self getData];
}

- (void)setNavi {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_return" ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[ZzbPx px:10],ZZBSCREEN_WIDTH, self.view.bounds.size.height - NavigationHeight - [ZzbPx px:10]) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
     [_tableView registerClass:[ZzbShowAllTableViewCell class] forCellReuseIdentifier:@"ZzbShowAllTableViewCell"];
    [self.view addSubview:_tableView];
    __weak ZzbShowAllViewController * that = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [that refresh];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [that loadMoreData];
    }];
    _tableView.mj_footer.hidden = YES;
    
    _noDataView = [[ZzbNoDataView alloc] init];
    _noDataView.frame = CGRectMake(0,0,ZZBSCREEN_WIDTH, self.view.bounds.size.height - NavigationHeight);
    [self.view addSubview:_noDataView];
    _noDataView.hidden = YES;
}

-(void)refresh {
    _currentPage = 1;
    [self getData];
}

-(void)loadMoreData {
    if (_allshowList.count>0){
        if(_totalPage == _currentPage){
             _tableView.mj_footer.state  = MJRefreshStateNoMoreData;
        }
        else{
            _currentPage += 1;
            [self getData];
        }
    }
}

//收藏
-(void)collect:(NSInteger)row{
    ZzbShowAllModel *model = _allshowList[row];
    NSString *string = [model toJSONString];
   
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbCollectKey];

    if (!value || [value isEqualToString:@""]) {
        [ud setObject:string forKey:ZzbCollectKey];
    }
    else{
        //拼接到最前面
        NSMutableArray <NSString*> *arr;
        NSArray *array = [value componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        
        //查询有没有,找到就删除,没找到插入到第一行
        BOOL isFind = NO;
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *newModel = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            if (newModel.appletInfo.id == model.appletInfo.id){
                [arr removeObjectAtIndex:i];
                isFind = YES;
                break;
            }
        }
        
        if (!isFind){
            //没有找到,插入
            [arr insertObject:string atIndex:0];
        }
        NSString *text;
        if (arr.count == 0){
            text = @"";
        }
        else{
            text = [arr componentsJoinedByString:@"-"];
        }
        [ud setObject:text forKey:ZzbCollectKey];
    }
    [self getCollectData];
    [_tableView reloadData];
}

//添加到我的游戏
-(void)addToMine:(NSInteger)row{
    ZzbShowAllModel *model = _allshowList[row];
    NSString *string = [model toJSONString];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbMineGameKey];
    
    if (!value || [value isEqualToString:@""]) {
        [ud setObject:string forKey:ZzbMineGameKey];
    }
    else{
        //拼接到最前面
        NSMutableArray <NSString*> *arr;
        NSArray *array = [value componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        
        //查询有没有,找到就删除
        BOOL isFind = NO;
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *newModel = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            if (newModel.appletInfo.id == model.appletInfo.id){
                [arr removeObjectAtIndex:i];
                isFind = YES;
                break;
            }
        }
        [arr insertObject:string atIndex:0];
        NSString *text;
        if (arr.count == 0){
            text = @"";
        }
        else{
            text = [arr componentsJoinedByString:@"-"];
        }
        [ud setObject:text forKey:ZzbMineGameKey];
    }
}

//读取本地收藏信息
-(void)getCollectData {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbCollectKey];
    [_collectList removeAllObjects];
    if (!value || [value isEqualToString:@""]) {
    }
    else{
        //说明有数据
        NSMutableArray <NSString*> *arr;
        NSArray *array = [value componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *model = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            [_collectList addObject:model];
        }
    }
}

-(void)getData {
    
    if (!_gameTypeId && !_modelId ){
        [_tableView.mj_footer endRefreshing];
        _noDataView.hidden = NO;
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url;
    if (_gameTypeId != 0){
        url = [NSString stringWithFormat:@"%@type/%ld/applet",apiUrl,(long)_gameTypeId];
    }
    else if (_modelId != 0){
        url = [NSString stringWithFormat:@"%@model/%ld/applet",apiUrl,(long)_modelId];
    }
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: _currentPage];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"false"];
    NSDictionary *prarm = [req getParam];
   
    __weak ZzbShowAllViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"请求成功：%@",responseObject);
        if (that){
            ZzbShowAllViewController *ctrl = that;
            [ctrl->_tableView.mj_header endRefreshing];
            [ctrl->_tableView.mj_footer endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^(){
                ZzbShowAllListModel * model = [[ZzbShowAllListModel alloc] initWithDictionary:responseObject error:nil];
                if (model.success){
                    if (model.data.count == 0){
                        ctrl->_noDataView.hidden = NO;
                    }
                    else{
                        ctrl->_noDataView.hidden = YES;
                    }
                    if(model.currentPage == 1){
                        [ctrl->_allshowList removeAllObjects];
                    }
                    for (int i = 0; i < model.data.count; i++) {
                        [ctrl->_allshowList addObject:model.data[i]];
                    }
                    ctrl->_totalPage = model.totalPage;
                    ctrl->_currentPage = model.currentPage;
                    [ctrl->_tableView reloadData];
    
                }
                if (model.totalPage > model.currentPage){
                    //不止一页
                    ctrl->_tableView.mj_footer.hidden = NO;
                }
                
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
        if (that){
            ZzbShowAllViewController *ctrl = that;
            [ctrl->_tableView.mj_header endRefreshing];
            [ctrl->_tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allshowList.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_zzbShowAllListModel.data.count > 0){
//        return [ZzbPx px:10];
//    }
//    return 0;
//}
//
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * header = [[UIView alloc] init];
//    header.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
//    return header;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZzbPx px:80];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ZzbShowAllTableViewCell";
    ZzbShowAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZzbShowAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //收藏按钮点击回调
    __weak ZzbShowAllViewController *that = self;
    NSInteger row = indexPath.row;
    cell.collectButtonBlock = ^{
        if (that){
            ZzbShowAllViewController *ctrl = that;
            [ctrl collect: row];
        }
    };
    ZzbShowAllModel *model = _allshowList[indexPath.row];
    [cell setModel: model];
    BOOL isCollect = false;
    for (int i = 0; i < _collectList.count; i++) {
        if (_collectList[i].appletInfo.id == model.appletInfo.id){
            isCollect = true;
            break;
        }
    }
    [cell setCollect:isCollect];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZzbShowAllModel *model = _allshowList[indexPath.row];
    if (model.appletInfo.id && model.appletInfo.appletKey) {
        [ZzbUtil handleEnterGame:model.appletInfo.id andAppkey: model.appletInfo.appletKey];
    }
    DemoViewController *ctrl = [[DemoViewController alloc] init];
    ctrl.apiHost = HOST_URL;

    if (model.appletInfo.appletAlias) {
        ctrl.appID = model.appletInfo.appletAlias;
    }
    [self addToMine:indexPath.row];
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

@end
