//
//  BUDARewardedVideoViewController.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/11.
//

#import "BUDARewardedVideoViewController.h"
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import "BUDMacros.h"
#import "BUDNormalButton.h"
#import "BUDAdManager.h"
@interface BUDARewardedVideoViewController () <BURewardedVideoAdDelegate>
@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@property (nonatomic, strong) BUDNormalButton *button;
@end

@implementation BUDARewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = @"123";
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:[BUDAdManager RewardedVideoId] rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [self.view addSubview:self.button];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.button.center = CGPointMake(self.view.center.x, self.view.center.y*1.5);
}

#pragma mark Lazy loading
- (UIButton *)button {
    if (!_button) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _button = [[BUDNormalButton alloc] initWithFrame:CGRectMake(0, size.height*0.75, 0, 0)];
        [_button setTitle:@"showRewardVideo" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonTapped:(id)sender {
    // Return YES when material is effective,data is not empty and has not been displayed.
    //Repeated display is not charged.
    [self.rewardedVideoAd showAdFromRootViewController:self.navigationController ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
//    [self.rewardedVideoAd showAdFromRootViewController:self.navigationController ritScene:BURitSceneType_custom ritSceneDescribe:@"scene_custom"];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
     //BUD_Log(@"rewardedVideoAd video did close");
}
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    BUD_Log(@"rewardedVideoAd video did click");
}
@end
