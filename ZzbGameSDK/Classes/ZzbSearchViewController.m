//
//  ZzbSearchViewController.m
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import "ZzbSearchViewController.h"
#import "ZzbHeader.h"
#import "ZzbShowAllTableViewCell.h"
#import "ZzbDelTipView.h"
#import <AFNetworking/AFNetworking.h>
//#import "DemoViewController.h"
#import <webappexts/WAEMainViewController.h>
#import "ZzbHotWordListModel.h"
#import "ZzbSearchHotWordCell.h"
#import "MJRefresh.h"
#import "ReqPacker.h"
#import "ZzbUtil.h"

@interface ZzbSearchViewController () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger totalPage;
@property (nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *searchList;
//@property (nonatomic,strong) ZzbShowAllListModel *zzbShowAllListModel;
@property (nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *collectList;
@property (nonatomic,strong) ZzbHotWordListModel *zzbHotWordListModel;
@property (nonatomic,strong) NSString *searchText;
@end

@implementation ZzbSearchViewController

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _searchList = [[NSMutableArray alloc] init];
    _collectList = [[NSMutableArray alloc] init];
    [self setNavi];
    [self setupUI];
    [self getCollectData];
    [self getHotWord];
}

- (void)setNavi {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_return" ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.title = @"搜索";
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    //顶部搜索视图
    UIView *topview = [[UIView alloc] init];
    topview.frame = CGRectMake(0, 0, ZZBSCREEN_WIDTH, [ZzbPx px:51]);
    topview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topview];

    UIView *lineview = [[UIView alloc] init];
    lineview.frame = CGRectMake(0, [ZzbPx px:50.5], ZZBSCREEN_WIDTH, [ZzbPx px:0.5]);
    lineview.backgroundColor = ZZBColorWithRGBA(233, 234, 234, 1.0);
    [topview addSubview:lineview];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake([ZzbPx px:16], [ZzbPx px:9.5], ZZBSCREEN_WIDTH - [ZzbPx px:32],[ZzbPx px:31] )];
    _searchBar.delegate = self;
    //设置searchBar背景颜色
    _searchBar.barTintColor = [UIColor whiteColor];
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
        }
    }
    [[[[_searchBar subviews] firstObject] subviews] lastObject].backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    //显示取消按钮
    _searchBar.showsCancelButton = NO;
    //设置占位字
    _searchBar.placeholder = @"快来搜索你喜欢的游戏";
    //将列表放到界面上
    [topview addSubview:_searchBar];
    CGFloat tableHeight = self.view.bounds.size.height- NavigationHeight - [ZzbPx px:51];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [ZzbPx px:51], ZZBSCREEN_WIDTH, tableHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ZzbShowAllTableViewCell class] forCellReuseIdentifier:@"ZzbShowAllTableViewCell"];
    [_tableView registerClass:[ZzbSearchHotWordCell class] forCellReuseIdentifier:@"ZzbSearchHotWordCell"];
    __weak ZzbSearchViewController * that = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [that loadMoreData];
    }];
    _tableView.mj_footer.hidden = YES;
    
}


-(void)loadMoreData {
    if (_searchList.count > 0){
        if(_totalPage == _currentPage){
            _tableView.mj_footer.state  = MJRefreshStateNoMoreData;
        }
        else{
            _currentPage += 1;
            [self getData];
        }
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //[_searchBar setText:[searchText substringToIndex:20]];
    //NSLog(@"searchBar searchText：%@",searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //NSLog(@"searchBar searchText：%@",searchBar.text);
    NSString *searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([searchText isEqualToString:@""]){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *comfirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:comfirmAc];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    _searchText = [NSString stringWithString:searchBar.text];
    _currentPage = 1;
    [self getData];
    [_searchBar resignFirstResponder];
}

-(void)getHotWord {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@search/hotWord",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"count" withInt: 5];
    NSDictionary *prarm = [req getParam];
    __weak ZzbSearchViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (that){
            ZzbSearchViewController *ctrl = that;
            dispatch_async(dispatch_get_main_queue(), ^(){
                ZzbHotWordListModel *model =[[ZzbHotWordListModel alloc] initWithDictionary:responseObject error:nil];
                if (model.success){
                    ctrl->_zzbHotWordListModel = model;
                    [ctrl->_tableView reloadData];
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}


-(void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@search/applet/match/keyword/%@",apiUrl,_searchText];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: _currentPage];
    [req addParam:@"pageSize" withInt: 10];
    NSDictionary *prarm = [req getParam];
    
    __weak ZzbSearchViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (that){
            ZzbSearchViewController *ctrl = that;
            [ctrl->_tableView.mj_footer endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                ZzbShowAllListModel * model = [[ZzbShowAllListModel alloc] initWithDictionary:responseObject error:nil];
                
                if (model.success){
                    if(model.currentPage == 1){
                        [ctrl->_searchList removeAllObjects];
                    }
                    for (int i = 0; i < model.data.count; i++) {
                        [ctrl->_searchList addObject:model.data[i]];
                    }
                    ctrl->_currentPage = model.currentPage;
                    ctrl->_totalPage = model.totalPage;
                    [ctrl->_tableView reloadData];
                }
                if (model.totalPage > model.currentPage){
                    //不止一页
                    ctrl->_tableView.mj_footer.hidden = NO;
                }
                if (model.data.count == 0){
                    ctrl->_tableView.mj_footer.hidden = YES;
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
        if (that){
            ZzbSearchViewController *ctrl = that;
            [ctrl->_tableView.mj_footer endRefreshing];
        }
    }];
}


-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height{
    CGSize sizeToFit = [value sizeWithFont:[UIFont fontWithName:@"PingFang SC" size: fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        if (_searchList.count > 0){
            return _searchList.count;
        }
    }
    else if (section == 1){
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (_searchList.count > 0){
            return [ZzbPx px:10];
        }
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    return footer;
}

-(void) handleTap:(UITapGestureRecognizer *)recognizer{
    [_searchBar resignFirstResponder];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footer = [[UIView alloc] init];
//    footer.backgroundColor = [UIColor redColor];
//    return footer;
    //添加手势收起键盘
    //单击的手势
    /*
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognize];
    if (!_zzbHotWordListModel){
        return footer;
    }
    UILabel *title = [[UILabel alloc] init];
    title.textColor = ZZBColorWithRGBA(51, 51, 51, 1.0);
    title.font = [UIFont fontWithName:@"PingFang SC" size: 14];
    title.frame = CGRectMake([ZzbPx px:15], [ZzbPx px:13], [ZzbPx px:100], [ZzbPx px:13.5]);
    [footer addSubview:title];
    title.text = @"热门搜索";

    CGFloat btnX = [ZzbPx px:17.5];
    CGFloat btnY = [ZzbPx px:40];
    int rowNum = 1;

    for (int i = 0; i< _zzbHotWordListModel.data.count; i++) {
        HotWordModel *model = _zzbHotWordListModel.data[i];
        UIButton *btn = [self createHotSearchBtn:model.hotWord];
        [btn setTag: i];
        [btn addTarget:self action:@selector(clickHotWord:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnWidth = [self widthForString:model.hotWord fontSize:12 andHeight:[ZzbPx px:30]];
        CGFloat btn_width = btnWidth + [ZzbPx px:26];
        if (btnX + btn_width > ZZBSCREEN_WIDTH - [ZzbPx px:17.5]){
            //换行
            btnY += ([ZzbPx px:40] + [ZzbPx px:10]);
            btnX = [ZzbPx px:17.5];
            rowNum += 1;
        }
        btn.frame = CGRectMake(btnX,btnY,btn_width,[ZzbPx px:30]);
        [footer addSubview:btn];
        btnX += (btn_width + [ZzbPx px:10]);
    }
    return footer;*/
//}

-(void)clickHotWord:(NSInteger)btnTag {
    HotWordModel *model = _zzbHotWordListModel.data[btnTag];
    NSString * searcgText = [NSString stringWithString:model.hotWord];
    _searchBar.text = searcgText;
    _searchText = [NSString stringWithString:searcgText];
    _currentPage = 1;
    [self getData];
    [_searchBar resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
       return [ZzbPx px:80];
    }
    else if(indexPath.section == 1){
        return [ZzbPx px:200];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //新游推荐
    if (indexPath.section == 0){
        ZzbShowAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbShowAllTableViewCell"];
        if (!cell) {
            cell = [[ZzbShowAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZzbShowAllTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_searchList.count > 0){
            ZzbShowAllModel *model = _searchList[indexPath.row];
            [cell setModel:model];
            BOOL isCollect = false;
            for (int i = 0; i < _collectList.count; i++) {
                if (_collectList[i].appletInfo.id == model.appletInfo.id){
                    isCollect = true;
                    break;
                }
            }
            [cell setCollect:isCollect];
        }
        //收藏按钮点击回调
        __weak ZzbSearchViewController *that = self;
        NSInteger row = indexPath.row;
        cell.collectButtonBlock = ^{
            if (that){
                ZzbSearchViewController *ctrl = that;
                [ctrl collect: row];
            }
        };
        return cell;
    }
    else if (indexPath.section == 1){
        ZzbSearchHotWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbSearchHotWordCell"];
        if (!cell) {
            cell = [[ZzbSearchHotWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZzbSearchHotWordCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_zzbHotWordListModel){
            [cell setModel:_zzbHotWordListModel];
        }
        __weak ZzbSearchViewController *that = self;
        cell.hotWordClickBlock = ^(NSInteger btnTag) {
            if (that){
                ZzbSearchViewController *ctrl = that;
                [ctrl clickHotWord:btnTag];
            }
        };
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

//收藏
-(void)collect:(NSInteger)row{
    ZzbShowAllModel *model = _searchList[row];
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

//读取本地收藏信息
-(void)getCollectData {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbCollectKey];
    if (!value || [value isEqualToString:@""]) {
    }
    else{
        //说明有数据
        NSMutableArray <NSString*> *arr;
        NSArray *array = [value componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        [_collectList removeAllObjects];
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *model = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            [_collectList addObject:model];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ZzbShowAllModel *model = _searchList[indexPath.row];
        if (model.appletInfo.id && model.appletInfo.appletKey) {
            NSLog(@"appletKey%@",model.appletInfo.appletKey);
            [ZzbUtil handleEnterGame:model.appletInfo.id andAppkey: model.appletInfo.appletKey];
        }
        WAEMainViewController *ctrl = [[WAEMainViewController alloc] init];
        ctrl.apiHost = HOST_URL;
        
        if (model.appletInfo.appletAlias) {
            NSLog(@"appletAlias%@",model.appletInfo.appletAlias);
            ctrl.appID = model.appletInfo.appletAlias;
        }
        [self addToMine:indexPath.row];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}

//添加到我的游戏
-(void)addToMine:(NSInteger)row{
    ZzbShowAllModel *model = _searchList[row];
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

@end
