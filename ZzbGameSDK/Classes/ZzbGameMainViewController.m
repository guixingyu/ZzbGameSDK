//
//  ZzbGameMainViewController.m
//  Pods-ZzbGameSDK_Example
//
//  Created by isec on 2019/11/21.
//
#import <AFNetworking/AFNetworking.h>
#import "ZzbHeader.h"
#import "ZzbGameManager.h"
#import "ZzbGameMainViewController.h"
#import <webappexts/webappexts.h>
#import <extensions/extensions.h>
#import "DemoViewController.h"
#import "ZzbShowAllViewController.h"
#import "ZzbAllTypeViewController.h"
#import "ZzbSearchViewController.h"
#import "ZzbNewGameRecommendCell.h"
#import "ZzbWorthyGameCell.h"
#import "ZzbMineGameViewController.h"
#import "ZzbSelectionGameCell.h"
#import "ZzbKindTemplate1Cell.h"
#import "ZzbKindTemplate2Cell.h"
#import "ZzbHotGameRecommendCell.h"
#import "ZzbGameTypeCell.h"
#import "JSONModel.h"
#import "ZzbModuleListModel.h"
#import "ZzbTypeListModel.h"
#import "ZzbAllGameListModel.h"
#import "ZzbPlayPictureModel.h"
#import "ZzbPlayPictureCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ReqPacker.h"
#import "ZzbLoginModel.h"
#import <UTDID/UTDevice.h>
#import "ZzbGameRunTimeModel.h"
#import "ZzbUtil.h"

NSString * const ShowInterstitial = @"showInterstitial";
NSString * const BUDemoStrings = @"BUDemoLanguage";

@implementation NSString (LocalizedString)

+ (NSString *)localizedStringForKey:(NSString *)key {
    if (key && [key isKindOfClass:[NSString class]]) {
        NSString *localizedString = NSLocalizedStringFromTable(key, BUDemoStrings, nil);
        return localizedString;
    }
    return @"Can’t find localizedString";
}

@end

@interface ZzbGameMainViewController () <UITableViewDelegate, UITableViewDataSource>


@property(nonatomic,strong) ZzbPlayPictureModel *zzbPlayPictureModel;
@property(nonatomic,strong) ZzbModuleListModel *zzbModuleListModel;
@property(nonatomic,strong) ZzbTypeListModel *zzbTypeListModel;
@property(nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *appList;
@property(nonatomic,strong) NSMutableArray<ZzbShowAllModel*> *collectList;

@end

@implementation ZzbGameMainViewController{
    UITableView *_tableView;
    NSInteger _currentPage;
    NSInteger _totalPage;
}

+ (void)load {
    // 添加插件
    [WAEMainViewController addExtension:WAExtensions.class];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    [self setupUI];
    _appList = [NSMutableArray array];
    _collectList = [NSMutableArray array];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"zzb_LoginToken"];

    if (!token) {
        [self Login];
    }
    else{
        [self refresh];
        [self sendGameRunTime];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:ZzbEnterBackground object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:ZzbEnterForeground object:nil];
}

//接收通知并相应的方法
- (void) enterBackground:(NSNotification *)notification{
    //进入后台
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *gameid = [ud objectForKey:ZzbRunGameId];
    if (gameid && (![gameid isEqualToString:@""])){
        NSString *gametime = [ud objectForKey:ZzbRunGameTime];
        if (!gametime || [gametime isEqualToString:@""]){
            [ud setObject:@"" forKey:ZzbRunGameId];
            return;
        }
        //进入后台,此时有小游戏正在运行,更新此时小游戏截止时间
        NSDate *datenow = [NSDate date];
        NSInteger time = [datenow timeIntervalSince1970];
        //分割成单条记录
        NSMutableArray <NSString*> *arr;
        NSArray *array = [gametime componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        //修改最后一条记录
        NSString *str = arr[arr.count-1];
        ZzbGameRunTimeModel *model = [[ZzbGameRunTimeModel alloc] initWithString:str error:nil];
        model.endTime = time;
        NSString *string = [model toJSONString];
        //更新最后一条记录
        [arr removeObjectAtIndex:arr.count-1];
        [arr addObject:string];
        NSString *text = [arr componentsJoinedByString:@"-"];
        [ud setObject:text forKey:ZzbRunGameTime];
    }
}

- (void) enterForeground:(NSNotification *)notification{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *gameid = [ud objectForKey:ZzbRunGameId];
    
    if (gameid && (![gameid isEqualToString:@""])){
        NSString *gametime = [ud objectForKey:ZzbRunGameTime];
        if (!gametime || [gametime isEqualToString:@""]){
            [ud setObject:@"" forKey:ZzbRunGameId];
            return;
        }
        //加入一条新数据
        NSDate *datenow = [NSDate date];
        NSInteger time = [datenow timeIntervalSince1970];
        ZzbGameRunTimeModel * model = [[ZzbGameRunTimeModel alloc] init];
        model.recordId = [gameid integerValue];
        model.startTime = time;
        NSString *string = [model toJSONString];
        //分割成单条记录
        NSMutableArray <NSString*> *arr;
        NSArray *array = [gametime componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        [arr addObject:string];
        NSString *text = [arr componentsJoinedByString:@"-"];
        [ud setObject:text forKey:ZzbRunGameTime];
    }
}

//发送游戏运行时间
-(void)sendGameRunTime {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *gameid = [ud objectForKey:ZzbRunGameId];
    if (gameid && (![gameid isEqualToString:@""])){
        NSString *gametime = [ud objectForKey:ZzbRunGameTime];
        if (!gametime || [gameid isEqualToString:@""]){
            [ud setObject:@"" forKey:ZzbRunGameId];
            return;
        }
        NSMutableArray <NSString*> *arr;
        NSArray *array = [gametime componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        NSString *str = arr[arr.count-1];
        ZzbGameRunTimeModel *model = [[ZzbGameRunTimeModel alloc] initWithString:str error:nil];
        if(!model.endTime){
            //某些情况没有保存到最后一条endTime(断电)
            [arr removeObjectAtIndex:arr.count-1];
        }
        
        NSMutableArray *sendArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            NSData *data = [arr[i] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dic allKeys] containsObject:@"recordId"] && [[dic allKeys] containsObject:@"startTime"] && [[dic allKeys] containsObject:@"endTime"]){
                [sendArr addObject:dic];
            }
        }
        if (sendArr.count > 0){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendArr options:NSJSONWritingPrettyPrinted error:nil];
            NSString * bodyStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //NSLog(@"bodyStr----->:%@",bodyStr);
            [ZzbUtil sendGameRunTime:bodyStr];
        }
        else{
             [ud setObject:@"" forKey:ZzbRunGameId];
             [ud setObject:@"" forKey:ZzbRunGameTime];
        }
    }
}

-(void)Login {
    NSString *url = [NSString stringWithFormat:@"%@user/login",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    NSString *uuid = [UTDevice utdid];
    NSDictionary *parameters = @{@"appId":@"sdkcn2100000014OI3QX",@"appKey":@"Z1kz6Pu1G8rN9J6JiSEIrquFgJK82qlu",@"uuid":uuid};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * bodyStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setPostStr:bodyStr];
    
    url = [req getPostUrl];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    __weak ZzbGameMainViewController *that = self;
    NSURLSessionDataTask *dt = [manager dataTaskWithRequest:request uploadProgress: nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"] && that) {
            ZzbGameMainViewController *ctrl = that;
            dispatch_async(dispatch_get_main_queue(), ^(){
                ZzbLoginModel * model = [[ZzbLoginModel alloc] initWithDictionary:responseObject error:nil];
                if (model.success){
                    NSLog(@"banner->successsuccesssuccesssuccesssuccess");
                    //保存token到本地
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *token = [ud objectForKey:@"zzb_LoginToken"];
                    if (!token) {
                        token = model.data.rememberToken;
                        [ud setObject:token forKey:@"zzb_LoginToken"];
                    }
                    [ctrl refresh];
                    [ctrl sendGameRunTime];

                }
            });
        }
    }];
    [dt resume];
}


- (void)viewWillAppear:(BOOL)animated {
	[self getCollectData];
	[_tableView reloadData];
}

- (void)setNavi {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIButton *rightBarButtonItem1 = [[UIButton alloc] init];
    [rightBarButtonItem1 setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/icon_wode" ofType:@"png"]] forState:UIControlStateNormal];
    UIButton *rightBarButtonItem2 = [[UIButton alloc] init];
    [rightBarButtonItem2 setTitle:@"我的游戏" forState:UIControlStateNormal];
    [rightBarButtonItem2 setTitleColor:ZZBColorWithRGBA(255,136,0,1.0) forState:UIControlStateNormal];
    [rightBarButtonItem2.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 12]];
    [rightBarButtonItem1 addTarget:self action:@selector(clickToMineGame) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonItem2 addTarget:self action:@selector(clickToMineGame) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem1];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem2];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *titleview = [[UIView alloc] init];
    titleview.frame =CGRectMake(0, 0, [ZzbPx px:248], [ZzbPx px:31]);
    titleview.backgroundColor = ZZBColorWithRGBA(246, 246, 246, 1.0);
    titleview.layer.cornerRadius = [ZzbPx px:15.5];
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSearchTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    //tapRecognize.delegate = self;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    
    [titleview addGestureRecognizer:tapRecognize];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/search" ofType:@"png"]];
    icon.frame = CGRectMake([ZzbPx px:16.5], [ZzbPx px:3.5],[ZzbPx px:25] , [ZzbPx px:25]);
    [titleview addSubview:icon];
    
    UILabel *searchDes = [[UILabel alloc] init];
    searchDes.text = @"快来搜索你喜欢的游戏";
    searchDes.textColor = ZZBColorWithRGBA(153, 153, 153, 1.0);
    searchDes.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    searchDes.frame = CGRectMake([ZzbPx px:44.5], [ZzbPx px:9.5],[ZzbPx px:130] , [ZzbPx px:12]);
    [titleview addSubview:searchDes];
    self.navigationItem.titleView = titleview;
    //隐藏导航栏下划线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}



- (void)clickToMineGame{
    ZzbMineGameViewController *vc = [[ZzbMineGameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) handleSearchTap:(UITapGestureRecognizer *)recognizer {
    ZzbSearchViewController *vc = [[ZzbSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setupUI {
    CGRect rect;
    if (self.tabBarController){
        rect = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height-NavigationHeight-TabbarHeight);
    }
    else{
        rect = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height-NavigationHeight);
    }
    _tableView = [[UITableView alloc] initWithFrame:rect  style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
	_tableView.estimatedRowHeight = 0;

    _tableView.estimatedSectionHeaderHeight = 0;

    _tableView.estimatedSectionFooterHeight = 0;


	
	
	[_tableView registerClass:[ZzbPlayPictureCell class] forCellReuseIdentifier:@"ZzbPlayPictureCell"];
    [_tableView registerClass:[ZzbNewGameRecommendCell class] forCellReuseIdentifier:@"ZzbNewGameRecommendCell"];
    [_tableView registerClass:[ZzbWorthyGameCell class] forCellReuseIdentifier:@"ZzbWorthyGameCell"];
	[_tableView registerClass:[ZzbSelectionGameCell class] forCellReuseIdentifier:@"ZzbSelectionGameCell"];
	[_tableView registerClass:[ZzbKindTemplate1Cell class] forCellReuseIdentifier:@"ZzbKindTemplate1Cell"];
	[_tableView registerClass:[ZzbHotGameRecommendCell class] forCellReuseIdentifier:@"ZzbHotGameRecommendCell"];
	
	[_tableView registerClass:[ZzbGameTypeCell class] forCellReuseIdentifier:@"ZzbGameTypeCell"];

    [self.view addSubview:_tableView];
	
	__weak ZzbGameMainViewController * that = self;
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[that refresh];
	}];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		[that loadMoreData];
	}];
	_tableView.mj_footer.hidden = YES;
}

-(void)refresh {
	_currentPage = 0;
	_totalPage = 1;
	_zzbPlayPictureModel = nil;
	_zzbModuleListModel = nil;
	_zzbTypeListModel = nil;
	[_appList removeAllObjects];

	[self requestPlayPictureList];
}

-(void)loadMoreData {
	[self requestAllGamelList];
}

- (void)requestPlayPictureList {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
    //manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    //[manager.securityPolicy setValidatesDomainName:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@banner",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: 1];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"false"];
    NSDictionary *prarm = [req getParam];
	
    __weak ZzbGameMainViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
		
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"] && that) {
            ZzbGameMainViewController *ctrl = that;
			dispatch_async(dispatch_get_main_queue(), ^(){
			ZzbPlayPictureModel * model = [[ZzbPlayPictureModel alloc] initWithDictionary:responseObject error:nil];
				if (model.success){
					ctrl->_zzbPlayPictureModel = model;
                    //[ctrl->_tableView reloadData];
					
					for (int i = 0; i < model.data.count; i++){
						ZzbPictureInfoModel *pictureModel = model.data[i];
						UIImageView *img = [[UIImageView alloc] init];
						[img sd_setImageWithURL:(NSURL*)pictureModel.imageUrl];
					}
					[ctrl requestModuleList];
				}
            });
        }
		
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
		
    }];
}

- (void)requestModuleList {
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@model",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: 1];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"false"];
    NSDictionary *prarm = [req getParam];
	
    __weak ZzbGameMainViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
		
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"] && that) {
            ZzbGameMainViewController *ctrl = that;
			dispatch_async(dispatch_get_main_queue(), ^(){
				ZzbModuleListModel * model = [[ZzbModuleListModel alloc] initWithDictionary:responseObject error:nil];
				if (model.success){
					ctrl->_zzbModuleListModel = model;
					[ctrl->_tableView.mj_header endRefreshing];
					[ctrl requestTypelList];
                    //[ctrl->_tableView reloadData];

				}
            });
        }
		
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
		
    }];
}

- (void)requestTypelList {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
    NSString *url = [NSString stringWithFormat:@"%@type",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: 1];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"false"];
    NSDictionary *prarm = [req getParam];
	
    __weak ZzbGameMainViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
		
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"] && that) {
            ZzbGameMainViewController *ctrl = that;
			dispatch_async(dispatch_get_main_queue(), ^(){
				ZzbTypeListModel * model = [[ZzbTypeListModel alloc] initWithDictionary:responseObject error:nil];
				if (model.success){
					ctrl->_zzbTypeListModel = model;
					[ctrl requestAllGamelList];
					

				}
            });
        }
		
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
		
    }];
}

- (void)requestAllGamelList {
	if (_currentPage >= _totalPage){
	
		return;
	}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
    NSString *url = [NSString stringWithFormat:@"%@applet",apiUrl];
    ReqPacker *req = [[ReqPacker alloc] init: url];
    [req addParam:@"currentPage" withInt: _currentPage+1];
    [req addParam:@"pageSize" withInt: 10];
    [req addParam:@"fetchAll" withString:@"false"];
    NSDictionary *prarm = [req getParam];
	
    __weak ZzbGameMainViewController *that = self;
    [manager GET:url parameters:prarm progress:^(NSProgress * _Nonnull downloadProgress) {
		
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"请求成功：%@",responseObject);
        if ([responseObject objectForKey:@"success"] && that) {
            ZzbGameMainViewController *ctrl = that;
			dispatch_async(dispatch_get_main_queue(), ^(){

				ZzbShowAllListModel * model = [[ZzbShowAllListModel alloc] initWithDictionary:responseObject error:nil];
				if (model.success){

					for(int i = 0; i<model.data.count; i++){
						[ctrl->_appList addObject:model.data[i]];
					}
					ctrl->_currentPage = model.currentPage;
					ctrl->_totalPage = model.totalPage;
					if (model.totalPage > model.currentPage){
						//不止一页
						ctrl->_tableView.mj_footer.hidden = NO;
						[ctrl->_tableView.mj_footer endRefreshing];
					}
					else{
						[ctrl->_tableView.mj_footer endRefreshingWithNoMoreData];
					}
					[ctrl->_tableView reloadData];

				}
            });
        }
		
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
		
    }];
}

- (void)createHeadView:(UIView *)headview styleid:(NSInteger)styleid {
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    if (self.zzbModuleListModel != nil && self.zzbPlayPictureModel != nil){
		if (self.appList.count > 0 && self.zzbTypeListModel != nil){
			return self.zzbModuleListModel.data.count+3;
		}
		else {
			return self.zzbModuleListModel.data.count+1;
		}
		
	}
	else {
		return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == self.zzbModuleListModel.data.count + 2){
		return self.appList.count;
    }
    else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	if (section == 0 ){
		return [[UIView alloc] init];
	}
	

	
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0];
    line.frame = CGRectMake(15, 16, 4, 20);
    [headerView addSubview:line];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"PingFang SC" size: 16];
    
    title.frame = CGRectMake(27.5, 18, 150, 16);
    [headerView addSubview:title];
	

	
    if (section <= self.zzbModuleListModel.data.count){
		ModuleItemModel *itemModel = self.zzbModuleListModel.data[section-1];
		title.text = itemModel.name;
		if (itemModel.readMore == true){
			UIButton *btnShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
			btnShowAll.tag = section-1;

			[btnShowAll setTitleColor:ZZBColorWithRGBA(255, 137, 0, 1) forState:UIControlStateNormal];
			btnShowAll.titleLabel.font = [UIFont systemFontOfSize:11];
			btnShowAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
			    
			[btnShowAll setTitle:@"查看全部>" forState:UIControlStateNormal];
			[headerView addSubview:btnShowAll];
			[btnShowAll addTarget:self action:@selector(on_ShowAllByModule:) forControlEvents:UIControlEventTouchUpInside];
			[btnShowAll mas_makeConstraints:^(MASConstraintMaker *make) {
				make.right.equalTo(headerView).offset([ZzbPx px:-16]);
				make.top.equalTo(headerView).offset([ZzbPx px:10]);
				make.size.mas_equalTo(CGSizeMake([ZzbPx px:100], [ZzbPx px:42]));
			}];
		}
	}
	else if(section == self.zzbModuleListModel.data.count + 1){
		title.text = @"游戏类型";
		UIButton *btnShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnShowAll setTitleColor:ZZBColorWithRGBA(255, 137, 0, 1) forState:UIControlStateNormal];
		btnShowAll.titleLabel.font = [UIFont systemFontOfSize:11];
		btnShowAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		[btnShowAll setTitle:@"查看全部>" forState:UIControlStateNormal];
		[headerView addSubview:btnShowAll];
		[btnShowAll addTarget:self action:@selector(on_ShowAllType_click) forControlEvents:UIControlEventTouchUpInside];
		[btnShowAll mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headerView).offset([ZzbPx px:-16]);
			make.top.equalTo(headerView).offset([ZzbPx px:10]);
			make.size.mas_equalTo(CGSizeMake([ZzbPx px:100], [ZzbPx px:42]));
		}];
	}
	else if(section == self.zzbModuleListModel.data.count + 2){
		title.text = @"值得玩的小游戏";
	}
    return headerView;
}


- (void)on_ShowAllByModule:(UIButton *)btn{
    ZzbShowAllViewController *vc = [[ZzbShowAllViewController alloc] init];
	
    ModuleItemModel *itemModel = _zzbModuleListModel.data[btn.tag];
    [vc setmodelId:itemModel.id];
    vc.title = itemModel.name;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)ShowAllByType:(NSInteger)type title:(NSString*)title{
    ZzbShowAllViewController *vc = [[ZzbShowAllViewController alloc] init];
    [vc setTypeId:type];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)on_ShowAllType_click{
    ZzbAllTypeViewController *vc = [[ZzbAllTypeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)on_DeservePlay_click{
    ZzbShowAllViewController *vc = [[ZzbShowAllViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if(section == 0 ){
		return [ZzbPx px:0.1];
	}
	else {
		return [ZzbPx px:50];
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if(section == 0){
		return [ZzbPx px:0.1];
	}
	else{
		return [ZzbPx px:10];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

	if(indexPath.section == 0){
		return [ZzbPx px:168];
	}
	NSInteger count = self.zzbModuleListModel.data.count;
	if (indexPath.section <= self.zzbModuleListModel.data.count){
		ModuleItemModel *itemModel = self.zzbModuleListModel.data[indexPath.section-1];

		if(itemModel.styleId == 1){
			return [ZzbPx px:171];
		}
		else if(itemModel.styleId == 2){
			return [ZzbPx px:172.5];
		}
		else if(itemModel.styleId == 3){
			return [ZzbPx px:240.5];
		}
		else if(itemModel.styleId == 4){
			return [ZzbPx px:121];
		}
		else if(itemModel.styleId == 5){
			return [ZzbPx px:372.5];
		}
	}
	
    //最后两个固定cell
	if (indexPath.section == self.zzbModuleListModel.data.count + 1)
	{
		return [ZzbPx px:114.5];
	}
	else if (indexPath.section == self.zzbModuleListModel.data.count + 2)
	{
		return [ZzbPx px:80];
	}

    return [ZzbPx px:80];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0){
		__weak ZzbGameMainViewController *that = self;
		ZzbPlayPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbPlayPictureCell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (!cell) {
			cell = [[ZzbPlayPictureCell alloc] initWithStyle:UITableViewCellStyleDefault
												  reuseIdentifier:@"ZzbPlayPictureCell"];
		}
		cell.selectPictureBlock = ^(ZzbPictureInfoModel *model){
				if(model.type == 1){
					[that gameClick:model.appletInfo.id appletKey:model.appletInfo.appletKey appletAlias:model.appletInfo.appletAlias];
					ZzbPictureInfoModel *tmpModel = [that convertPictureModel2ShowAllModel:model];
					[that addToMine:tmpModel];

				}
				else if(model.type == 2){
					NSURL *URL = [NSURL URLWithString:model.webUrl];
					
					[[UIApplication sharedApplication]openURL:URL];

				}
		};
		[cell setModel:_zzbPlayPictureModel];
		return cell;
	}
	//模块列表cell
    if (indexPath.section <= self.zzbModuleListModel.data.count){
		ModuleItemModel *itemModel = self.zzbModuleListModel.data[indexPath.section-1];

		if(itemModel.styleId == 1){
			//新游推荐
			__weak ZzbGameMainViewController *that = self;
			ZzbNewGameRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbNewGameRecommendCell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (!cell) {
				cell = [[ZzbNewGameRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault
													  reuseIdentifier:@"ZzbNewGameRecommendCell"];
			}
			[cell setModel:itemModel.applets];
			cell.SelectionBlock = ^(ZzbShowAllModel *model){
				[that gameClick:model];
			};
			return cell;
		}
		else if(itemModel.styleId == 2){
			__weak ZzbGameMainViewController *that = self;
			ZzbKindTemplate1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbKindTemplate1Cell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (!cell) {
				cell = [[ZzbKindTemplate1Cell alloc] initWithStyle:UITableViewCellStyleDefault
												   reuseIdentifier:@"ZzbKindTemplate1Cell"];
			}
			cell.ShowAllByModule = ^(NSInteger moduleid){
				ZzbShowAllViewController *vc = [[ZzbShowAllViewController alloc] init];
				
				[vc setmodelId:itemModel.id];
				[that.navigationController pushViewController:vc animated:YES];
				vc.title = itemModel.name;
			};
			cell.SelectionBlock = ^(ZzbShowAllModel *model){
				[that gameClick:model];
			};
			[cell setStyleId:itemModel.styleId];
			[cell setModel:itemModel.applets];
			return cell;
		}
		else if(itemModel.styleId == 3){
			//精选游戏
			__weak ZzbGameMainViewController *that = self;
			ZzbSelectionGameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbSelectionGameCell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (!cell) {
				cell = [[ZzbSelectionGameCell alloc] initWithStyle:UITableViewCellStyleDefault
												   reuseIdentifier:@"ZzbSelectionGameCell"];
			}
			
			cell.playButtonBlock = ^(ZzbShowAllModel *model){
				[that gameClick:model];
			};
			cell.collectButtonBlock = ^(ZzbShowAllModel *model) {
				[that collect:itemModel.applets[0]];
			};
			
			[cell setModel:itemModel.applets];
			ZzbShowAllModel *model = itemModel.applets[0];
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
		else if(itemModel.styleId == 4){
			__weak ZzbGameMainViewController *that = self;
			ZzbHotGameRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbHotGameRecommendCell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (!cell) {
				cell = [[ZzbHotGameRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault
													  reuseIdentifier:@"ZzbHotGameRecommendCell"];
			}
			cell.SelectionBlock = ^(ZzbShowAllModel *model){
				[that gameClick:model];
			};
			[cell setModel:itemModel.applets];
			return cell;
		}
		else if(itemModel.styleId == 5){
			__weak ZzbGameMainViewController *that = self;
			ZzbKindTemplate2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbKindTemplate2Cell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (!cell) {
				cell = [[ZzbKindTemplate2Cell alloc] initWithStyle:UITableViewCellStyleDefault
												   reuseIdentifier:@"ZzbKindTemplate2Cell"];
			}
			cell.SelectionBlock = ^(ZzbShowAllModel *model){
				[that gameClick:model];
			};
			[cell setModel:itemModel.applets];
			return cell;
		}
    }
    //最后两个固定cell
	if (indexPath.section == self.zzbModuleListModel.data.count + 1)
	{
		//游戏类型
		__weak ZzbGameMainViewController *that = self;
		ZzbGameTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbGameTypeCell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (!cell) {
			cell = [[ZzbGameTypeCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:@"ZzbGameTypeCell"];
		}
		cell.TypeClickBlock = ^(NSInteger type, NSString *title){
			[that ShowAllByType:type title:title];
		};
		[cell setModel:self.zzbTypeListModel];
		return cell;
	}
    else if (indexPath.section == self.zzbModuleListModel.data.count + 2){
        //值得玩的小游戏
        __weak ZzbGameMainViewController *that = self;
        ZzbWorthyGameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZzbWorthyGameCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[ZzbWorthyGameCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"ZzbWorthyGameCell"];
        }
		cell.collectButtonBlock = ^(ZzbShowAllModel *model){
			[that collect:that.appList[indexPath.row]];
		};
		cell.playButtonBlock = ^(ZzbShowAllModel *model){
			[that gameClick:model];
		};
		[cell setModel:indexPath.row model:that.appList[indexPath.row]];
		
		ZzbShowAllModel *model = self.appList[indexPath.row];
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
	
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ssssssss");
	
//	GameInfoModel *model = self.zzbAllGameListModel.data[indexPath.row];
//
//    [self gameClick:model.appletInfo.id appletKey:model.appletInfo.appletKey];
}

- (void)gameClick:(ZzbShowAllModel*)model{
	[self addToMine:model];

    [ZzbUtil handleEnterGame:model.appletInfo.id andAppkey:model.appletInfo.appletKey];
	
    DemoViewController *ctrl = [[DemoViewController alloc] init];
	[ctrl setAppletId:model.appletInfo.id];
    ctrl.apiHost = HOST_URL;
	ctrl.appID = model.appletInfo.appletAlias;
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)gameClick:(NSInteger)appletid appletKey:(NSString*)appletKey appletAlias:(NSString*)appletAlias{
	//[self addToMine:model];
    [ZzbUtil handleEnterGame:appletid andAppkey:appletKey];
    DemoViewController *ctrl = [[DemoViewController alloc] init];
    [ctrl setAppletId:appletid];
    ctrl.apiHost = HOST_URL;
	ctrl.appID = appletAlias;
    [self presentViewController:ctrl animated:YES completion:nil];
}

-(ZzbShowAllModel*)convertPictureModel2ShowAllModel:(ZzbPictureInfoModel*)model{
	ZzbShowAllModel *tmpModel = [[ZzbShowAllModel alloc] init];
	tmpModel.id = model.id;
	tmpModel.modelId = model.modelId;
	tmpModel.cfgImgPath = model.imageUrl;
	tmpModel.appletInfo = [[AppletInfoModel alloc] init];
	tmpModel.appletInfo.id = model.appletInfo.id;
	tmpModel.appletInfo.title = model.appletInfo.title;
	tmpModel.appletInfo.imgPath = model.appletInfo.imgPath;
	tmpModel.appletInfo.desc = model.appletInfo.desc;
	tmpModel.appletInfo.type = model.appletInfo.type;
	tmpModel.appletInfo.tag = model.appletInfo.tag;
	tmpModel.appletInfo.iconPath = model.appletInfo.iconPath;
	tmpModel.appletInfo.appletKey = model.appletInfo.appletKey;
	tmpModel.appletInfo.appletAlias = model.appletInfo.appletAlias;
	return tmpModel;
}

//添加到我的游戏
-(void)addToMine:(ZzbShowAllModel*)model{
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

//收藏
-(void)collect:(ZzbShowAllModel*)model{
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

@end
