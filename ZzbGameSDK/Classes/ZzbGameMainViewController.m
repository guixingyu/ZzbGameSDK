//
//  ZzbGameMainViewController.m
//  Pods-ZzbGameSDK_Example
//
//  Created by isec on 2019/11/21.
//

#import "ZzbGameMainViewController.h"
#import <webappexts/webappexts.h>
#import <extensions/extensions.h>
#import "DemoViewController.h"

@interface DemoData : NSObject
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *appID;
@property (nonatomic, strong) NSURL     *url;
@property (nonatomic, strong) NSURL     *defaultURL;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *aID;
@property (nonatomic, strong) NSString *aKey;
@property (nonatomic, strong) WAEMainViewController *ctrl;
@end

#   define HOST_URL     @"https://azgw.884029.com"
#   define APP_ID       @"2"
#   define APP_KEY      @"iU6wDkWwfudMADm4"
#   define APP_TOKEN    @"c07d1ec7140245dd0052f155414d5158"
#   define API_HOST_KET @"api_host"

@implementation DemoData

@end

@interface ZzbGameMainViewController ()

@end

@implementation ZzbGameMainViewController{
    NSMutableArray <DemoData *> *_onlineDemos;
    NSURLSession    *_session;
}

+ (void)load {
    // 添加插件
    NSLog(@"loadloadloadload添加插件");
    [WAEMainViewController addExtension:WAExtensions.class];
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.title = @"小程序Demo";
    _onlineDemos = [NSMutableArray array];
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [self configData];
    [self requestList];
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
    [btn setTitle:@"click Me" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(clickToDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)configData {
    NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:API_HOST_KET];
    if (!host) {
        [[NSUserDefaults standardUserDefaults] setObject:HOST_URL
                                                  forKey:API_HOST_KET];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *_id = [ud objectForKey:@"wapp_id"];
    NSString *key = [ud objectForKey:@"wapp_key"];
    NSString *token = [ud objectForKey:@"wapp_token"];
    if (!_id) {
        _id = APP_ID;
        [ud setObject:_id forKey:@"wapp_id"];
    }
    if (!key) {
        key = APP_KEY;
        [ud setObject:key forKey:@"wapp_key"];
    }
    if (!token) {
        token = APP_TOKEN;
        [ud setObject:token forKey:@"wapp_token"];
    }
    
    [WAEMainViewController setup:@{@"id": _id,@"key": key}];
}

- (void)requestList {
    
    [_onlineDemos removeAllObjects];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *_id = [ud objectForKey:@"wapp_id"];
    NSString *token = [ud objectForKey:@"wapp_token"];
    if (_id && token) {
        NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:API_HOST_KET];
        NSString *urlPath = [NSString stringWithFormat:@"%@%@?id=%@&token=%@", host, @"/api/open/applet/queryAllAppletList", _id, token];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        request.HTTPMethod = @"GET";
        __weak ZzbGameMainViewController *that = self;
        
        [[_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) return;
            id json = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableLeaves
                                                        error:nil];
            
            if ([json objectForKey:@"success"] && that) {
                NSLog(@"successsuccesssuccesssuccess");
                ZzbGameMainViewController *ctrl = that;
                dispatch_async(dispatch_get_main_queue(), ^(){
                    NSArray *rows = [json objectForKey:@"data"];
                    if ([rows isKindOfClass:NSArray.class]) {
                        NSString *imgAddr = [json objectForKey:@"imgAddr"];
                        for (id row in rows) {
                            DemoData *data = [[DemoData alloc] init];
                            data.title = [row objectForKey:@"title"];
                            data.appID = [row objectForKey:@"appId"];
                            data.aID = [row objectForKey:@"id"];
                            data.aKey = [row objectForKey:@"key"];
                            data.imageURL = [imgAddr stringByAppendingString:[row objectForKey:@"imgPath"]];
                            NSString *param = [row objectForKey:@"param"];
                            
                            if (param) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                NSArray *arr = [param componentsSeparatedByString:@"&"];
                                for (NSString *seg in arr) {
                                    NSArray *parts = [seg componentsSeparatedByString:@"="];
                                    if (parts.count == 2) {
                                        [dic setObject:[parts[1] stringByRemovingPercentEncoding]
                                                forKey:[parts[0] stringByRemovingPercentEncoding]];
                                    }
                                }
                                data.params = dic;
                            }
                            [ctrl->_onlineDemos addObject:data];
                        }
                    }
                    
                });
            }
        }] resume];
    }
}

- (void)clickToDismiss{
    //[self dismissViewControllerAnimated:YES completion:nil];
    DemoData *data = [_onlineDemos objectAtIndex:0];
    if (data.aID && data.aKey) {
        [WAEMainViewController setup:@{
                                       @"id": [data.aID description],
                                       @"key": [data.aKey description]
                                       }];
    }
    
    DemoViewController *ctrl = [[DemoViewController alloc] init];
    
    ctrl.apiHost = [[NSUserDefaults standardUserDefaults] objectForKey:API_HOST_KET];
    if (data.url) {
        ctrl.workURL = data.url;
    }
    if (data.appID) {
        ctrl.appID = data.appID;
    }
    if (data.defaultURL) {
        ctrl.defaultsURL = data.defaultURL;
    }
    if (data.params) {
        ctrl.params = data.params;
    }
    [self presentViewController:ctrl animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
