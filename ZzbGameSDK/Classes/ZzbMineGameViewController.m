//
//  MineGameViewController.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/29.
//

#import "ZzbMineGameViewController.h"
#import "ZzbHeader.h"
#import "ZzbShowAllTableViewCell.h"
#import "ZzbShowAllListModel.h"
#import "DemoViewController.h"
#import "ZzbDelTipView.h"
#import "ZzbNoDataView.h"
#import "ZzbUtil.h"

@interface ZzbMineGameViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *recentBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UITableView *recentTable;
@property (nonatomic, strong) UITableView *collectTable;
@property (nonatomic, strong) ZzbNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray <ZzbShowAllModel*> *recentList;
@property (nonatomic, strong) NSMutableArray <ZzbShowAllModel*> *collectList;
@property (nonatomic, assign)NSInteger curIndex;
@end

@implementation ZzbMineGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after l_collectListview.
    _recentList = [NSMutableArray array];
    _collectList = [NSMutableArray array];
    _curIndex = 0;
    [self setNavi];
    [self setupUI];
    [self getCollectData];
    [self getMineGameData];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setNavi {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_return" ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.title = @"我的游戏";
    UIButton *rightBarButtonItem1 = [[UIButton alloc] init];
    [rightBarButtonItem1 setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/btn_huancun" ofType:@"png"]] forState:UIControlStateNormal];
    UIButton *rightBarButtonItem2 = [[UIButton alloc] init];
    [rightBarButtonItem2 setTitle:@"清除缓存" forState:UIControlStateNormal];
    [rightBarButtonItem2 setTitleColor:ZZBColorWithRGBA(255,136,0,1.0) forState:UIControlStateNormal];
    [rightBarButtonItem2.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 12]];
    
    [rightBarButtonItem1 addTarget:self action:@selector(clickClearCache) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonItem2 addTarget:self action:@selector(clickClearCache) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem1];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItem2];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//清除所有子游戏目录
- (void)clickClearCache{
    ZzbDelTipView *tipview = [[ZzbDelTipView alloc] initWithFrame:CGRectMake(0, 0, ZZBSCREEN_WIDTH, ZZBSCREEN_HEIGHT)];
    [tipview setTitle:@"您确定删除所有游戏吗？"];
    [tipview setDes:@"该操作将删除全部游戏和相关存档数据"];
    [UIApplication.sharedApplication.delegate.window addSubview:tipview];
    __weak ZzbMineGameViewController *that = self;
    tipview.didClickSureBlock = ^{
        if(that){
            ZzbMineGameViewController *ctrl = that;
            [ctrl clearAllCache];
        }
    };
}

-(void)clearAllCache {
    if (_recentList.count == 0){
        return;
    }
    for (int i = 0; i<_recentList.count; i++ ) {
        ZzbShowAllModel *model = _recentList[i];
        WAEAppControl * control = [WAEAppControl controlFromID:model.appletInfo.appletAlias];
        [control remove];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:ZzbMineGameKey];
    [self getMineGameData];
}

-(void)clearAllCacheByAlias:(NSString*)appletAlias andAppletid:(NSInteger)appletid{
    WAEAppControl * control = [WAEAppControl controlFromID:appletAlias];
    [control remove];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbMineGameKey];
    if (!value || [value isEqualToString:@""]) {
    }
    else{
        //拼接到最前面
        NSMutableArray <NSString*> *arr;
        NSArray *array = [value componentsSeparatedByString:@"-"];
        arr = [[NSMutableArray alloc] initWithArray:array];
        //查询有没有,找到就删除
        BOOL isFind = false;
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *newModel = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            if (newModel.appletInfo.id == appletid){
                [arr removeObjectAtIndex:i];
                isFind = true;
                break;
            }
        }
        NSString *text;
        if (arr.count == 0){
            text = @"";
        }
        else{
            text = [arr componentsJoinedByString:@"-"];
        }
        [ud setObject:text forKey:ZzbMineGameKey];
    }
    [self getMineGameData];
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = ZZBColorWithRGBA(240,240,240,1.0);
    topView.frame = CGRectMake(0, 0, ZZBSCREEN_WIDTH, [ZzbPx px:55]);
    [self.view addSubview:topView];
    
    _recentBtn = [[UIButton alloc] init];
    _recentBtn.tag = 100;
    _recentBtn.backgroundColor = [UIColor whiteColor];
    _recentBtn.frame = CGRectMake(0,[ZzbPx px:10], ZZBSCREEN_WIDTH/2, [ZzbPx px:44.5]);
    [_recentBtn setTitle:@"最近使用" forState:UIControlStateNormal];
    [_recentBtn setTitleColor:ZZBColorWithRGBA(255,137,0,1.0) forState:UIControlStateNormal];
    [_recentBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 16]];
    [topView addSubview:_recentBtn];
    [_recentBtn addTarget:self action:@selector(clickToScroll:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _collectBtn= [[UIButton alloc] init];
    _collectBtn.tag = 101;
    _collectBtn.backgroundColor = [UIColor whiteColor];
    _collectBtn.frame = CGRectMake(ZZBSCREEN_WIDTH/2,[ZzbPx px:10], ZZBSCREEN_WIDTH/2, [ZzbPx px:44.5]);
    [_collectBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:ZZBColorWithRGBA(153,153,153,1.0) forState:UIControlStateNormal];
    [_collectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 14]];
    [topView addSubview:_collectBtn];
    [_collectBtn addTarget:self action:@selector(clickToScroll:) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.backgroundColor = [UIColor whiteColor];
    CGFloat scrollHeight = self.view.frame.size.height-[ZzbPx px:55] - NavigationHeight;
    NSLog(@"view:%f",self.view.frame.size.height);
    NSLog(@"%f",ZZBSCREEN_HEIGHT);
    _scrollview.frame = CGRectMake(0,[ZzbPx px:55], ZZBSCREEN_WIDTH, scrollHeight);
    _scrollview.scrollEnabled = YES;
    [_scrollview setPagingEnabled:YES];
    _scrollview.bounces = NO;
    _scrollview.contentSize = CGSizeMake(ZZBSCREEN_WIDTH*2,scrollHeight);
    _scrollview.contentOffset = CGPointMake(0, 0);
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];

    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0,0,ZZBSCREEN_WIDTH, scrollHeight);
    [_scrollview addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(ZZBSCREEN_WIDTH,0,ZZBSCREEN_WIDTH, scrollHeight);
    [_scrollview addSubview:rightView];
    
    _recentTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ZZBSCREEN_WIDTH, scrollHeight) style:UITableViewStylePlain];
    _recentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recentTable.delegate = self;
    _recentTable.dataSource = self;
    [_recentTable registerClass:[ZzbShowAllTableViewCell class] forCellReuseIdentifier:@"ZzbShowAllTableViewCell"];
    [leftView addSubview:_recentTable];
    
    _collectTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ZZBSCREEN_WIDTH, scrollHeight) style:UITableViewStylePlain];
    _collectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _collectTable.delegate = self;
    _collectTable.dataSource = self;
    [_collectTable registerClass:[ZzbShowAllTableViewCell class] forCellReuseIdentifier:@"ZzbShowAllTableViewCell"];
    [rightView addSubview:_collectTable];
    
    _noDataView = [[ZzbNoDataView alloc] init];
    _noDataView.frame = CGRectMake(0,[ZzbPx px:55],ZZBSCREEN_WIDTH, scrollHeight);
    [self.view addSubview:_noDataView];
    _noDataView.hidden = YES;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    UIImage * image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ZzbGameSDK.bundle/Slide" ofType:@"png"]];
    _scrollLine = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_scrollLine];
    _scrollLine.frame = CGRectMake((ZZBSCREEN_WIDTH/2-[ZzbPx px:32])/2, [ZzbPx px:53], [ZzbPx px:32], [ZzbPx px:4]);
    
}

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
            if (model){
                [_collectList addObject:model];
            }
            else{
                NSLog(@"转换model错误");
            }
        }
    }
    [_collectTable reloadData];
}

-(void)getMineGameData {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud objectForKey:ZzbMineGameKey];
    [_recentList removeAllObjects];
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
            
            if (model){
                [_recentList addObject:model];
            }
            else{
                NSLog(@"转换model错误");
            }
        }
    }
    //如果此时页面停留在最近使用
    if (_curIndex == 0){
        if (_recentList.count > 0){
            _noDataView.hidden = YES;
        }
        else{
            _noDataView.hidden = NO;
        }
    }
    [_recentTable reloadData];
}

//收藏和取消收藏
-(void)collect:(NSInteger)row andTableid:(NSInteger)tableid{
    ZzbShowAllModel *model;
    if(tableid == 1){
        model = _recentList[row];
    }
    else if (tableid == 2){
        model = _collectList[row];
    }
    NSString *string = [NSString stringWithString: [model toJSONString]];
    
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
        BOOL isFind = false;
        for (int i = 0; i< arr.count; i++) {
            NSString *str = arr[i];
            ZzbShowAllModel *newModel = [[ZzbShowAllModel alloc] initWithString:str error:nil];
            if (newModel.appletInfo.id == model.appletInfo.id){
                [arr removeObjectAtIndex:i];
                isFind = true;
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
    if(_collectList.count == 0){
        _noDataView.hidden = NO;
    }
    else{
        _noDataView.hidden = YES;
    }
    [_recentTable reloadData];
}


- (void)clickToScroll:(UIButton*)sender {
    NSInteger itag = sender.tag;
    if (itag == 100){
        if (_curIndex == 0){
            return;
        }
        _curIndex = 0;
        [_scrollview setContentOffset:CGPointMake(0,0) animated:YES];
        
        [_recentBtn setTitleColor:ZZBColorWithRGBA(255,137,0,1.0) forState:UIControlStateNormal];
        [_recentBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 16]];
        [_collectBtn setTitleColor:ZZBColorWithRGBA(153,153,153,1.0) forState:UIControlStateNormal];
        [_collectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 14]];
        __weak ZzbMineGameViewController *that = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (that){
                ZzbMineGameViewController *ctrl = that;
                [ctrl->_scrollLine setFrame:CGRectMake((ZZBSCREEN_WIDTH/2-[ZzbPx px:32])/2, [ZzbPx px:53], [ZzbPx px:32], [ZzbPx px:4])];
            }
        }];
        
        if(_recentList.count == 0){
            _noDataView.hidden = NO;
        }
        else{
            _noDataView.hidden = YES;
        }
        
    }
    else if (itag == 101){
        if (_curIndex == 1){
            return;
        }
        _curIndex = 1;
        [_scrollview setContentOffset:CGPointMake(ZZBSCREEN_WIDTH,0) animated:YES];
        
        [_collectBtn setTitleColor:ZZBColorWithRGBA(255,137,0,1.0) forState:UIControlStateNormal];
        [_collectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 16]];
        [_recentBtn setTitleColor:ZZBColorWithRGBA(153,153,153,1.0) forState:UIControlStateNormal];
        [_recentBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 14]];
        __weak ZzbMineGameViewController *that = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (that){
                ZzbMineGameViewController *ctrl = that;
                [ctrl->_scrollLine setFrame:CGRectMake((ZZBSCREEN_WIDTH/2-[ZzbPx px:32])/2 + ZZBSCREEN_WIDTH/2, [ZzbPx px:53], [ZzbPx px:32], [ZzbPx px:4])];
            }
        }];
        if(_collectList.count == 0){
            _noDataView.hidden = NO;
        }
        else{
            _noDataView.hidden = YES;
        }
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _collectTable){
        return _collectList.count;
    }
    else if (tableView == _recentTable){
        return _recentList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZzbPx px:80];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *identifier = @"ZzbShowAllTableViewCell";
    ZzbShowAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZzbShowAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //收藏按钮点击回调 取消收藏,从列表中移除
    __weak ZzbMineGameViewController *that = self;
    NSInteger row = indexPath.row;
    
    if (tableView == _collectTable){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel: _collectList[indexPath.row]];
        [cell setCollect:true];
        
        cell.collectButtonBlock = ^{
            if (that){
                ZzbMineGameViewController *ctrl = that;
                [ctrl collect: row andTableid:2];
            }
        };
    }
    else if (tableView == _recentTable){
        
        cell.collectButtonBlock = ^{
            if (that){
                ZzbMineGameViewController *ctrl = that;
                [ctrl collect: row andTableid:1];
            }
        };
        
        ZzbShowAllModel *model = _recentList[indexPath.row];
        [cell setModel: model];
        BOOL isCollect = false;
        for (int i = 0; i < _collectList.count; i++) {
            if (_collectList[i].appletInfo.id == model.appletInfo.id){
                isCollect = true;
                break;
            }
        }
        [cell setCollect:isCollect];
        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
    }
    return cell;
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        CGPoint location = [longRecognizer locationInView:_recentTable];
        NSIndexPath * indexPath = [_recentTable indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        NSLog(@"LongPress row ---->%ld",(long)indexPath.row);
        //在此添加你想要完成的功能
        ZzbDelTipView *tipview = [[ZzbDelTipView alloc] initWithFrame:CGRectMake(0, 0, ZZBSCREEN_WIDTH, ZZBSCREEN_HEIGHT)];
        [tipview setTitle:@"您确定删除该款游戏吗？"];
        [tipview setDes:@"该操作将删除此游戏及其存档数据"];
        ZzbShowAllModel *model = _recentList[indexPath.row];
        NSString *appletAlias = [NSString stringWithString:model.appletInfo.appletAlias];
        NSInteger appletid = model.appletInfo.id;
       
        [UIApplication.sharedApplication.delegate.window addSubview:tipview];
        __weak ZzbMineGameViewController *that = self;
        tipview.didClickSureBlock = ^{
            if(that){
                ZzbMineGameViewController *ctrl = that;
                [ctrl clearAllCacheByAlias:appletAlias andAppletid:appletid];
            }
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    NSLog(@"cachesPath：%@",cachesPath);
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSArray *allPath =[manager subpathsAtPath:cachesPath];
//    //4.遍历所有的子路径
//    for (NSString *subPath in allPath) {
//        NSLog(@"subPath：%@",subPath);
//    }
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZzbShowAllModel *model;
    if (tableView == _collectTable){
        model = _collectList[indexPath.row];
    }
    else if (tableView == _recentTable){
        model = _recentList[indexPath.row];
    }
    if (model.appletInfo.id && model.appletInfo.appletKey) {
        [ZzbUtil handleEnterGame:model.appletInfo.id andAppkey: model.appletInfo.appletKey];
    }
    DemoViewController *ctrl = [[DemoViewController alloc] init];
    ctrl.apiHost = HOST_URL;
    
    if (model.appletInfo.appletAlias) {
        ctrl.appID = model.appletInfo.appletAlias;
    }
   
    [self presentViewController:ctrl animated:YES completion:nil];
    
    if (tableView == _recentTable){
        [self addToMine:indexPath.row andTableid:1];
    }
    else if (tableView == _collectTable){
        [self addToMine:indexPath.row andTableid:2];
    }
}

//添加到我的游戏
-(void)addToMine:(NSInteger)row andTableid:(NSInteger)tableid{
    ZzbShowAllModel *model;
    if(tableid == 1){
        model = _recentList[row];
    }
    else if (tableid == 2){
        model = _collectList[row];
    }
    NSString *string = [NSString stringWithString: [model toJSONString]];

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
    [self getMineGameData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == _recentTable){
        return;
    }
    if(scrollView == _collectTable){
        
        return;
    }
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
   
    if (index == 0){
        _curIndex = 0;
        [_recentBtn setTitleColor:ZZBColorWithRGBA(255,137,0,1.0) forState:UIControlStateNormal];
        [_recentBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 16]];
        [_collectBtn setTitleColor:ZZBColorWithRGBA(153,153,153,1.0) forState:UIControlStateNormal];
        [_collectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 14]];
        if(_recentList.count == 0){
            _noDataView.hidden = NO;
        }
        else{
            _noDataView.hidden = YES;
        }
    }
    else if (index == 1){
        _curIndex = 1;
        [_collectBtn setTitleColor:ZZBColorWithRGBA(255,137,0,1.0) forState:UIControlStateNormal];
        [_collectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 16]];
        [_recentBtn setTitleColor:ZZBColorWithRGBA(153,153,153,1.0) forState:UIControlStateNormal];
        [_recentBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size: 14]];
        if(_collectList.count == 0){
            _noDataView.hidden = NO;
        }
        else{
            _noDataView.hidden = YES;
        }
    }
    __weak ZzbMineGameViewController *that = self;
    [UIView animateWithDuration:0.2 animations:^{
        if (that){
            ZzbMineGameViewController *ctrl = that;
            if(index == 1){
                [ctrl->_scrollLine setFrame:CGRectMake((ZZBSCREEN_WIDTH/2-[ZzbPx px:32])/2 + ZZBSCREEN_WIDTH/2, [ZzbPx px:53], [ZzbPx px:32], [ZzbPx px:4])];
            }
            else if (index == 0){
                [ctrl->_scrollLine setFrame:CGRectMake((ZZBSCREEN_WIDTH/2-[ZzbPx px:32])/2, [ZzbPx px:53], [ZzbPx px:32], [ZzbPx px:4])];
            }
        }
    }];
}

@end
