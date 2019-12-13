//
//  ZZBTabBarController.m
//  ZzbGameSDK_Example
//
//  Created by isec on 2019/12/6.
//  Copyright © 2019年 guixingyu. All rights reserved.
//

#import "ZZBTabBarController.h"
#import "ZZBDemoViewController.h"
#import <ZzbGameSDK/ZzbGameManager.h>
@interface ZZBTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZZBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使用系统自带的tabBar注意这两个函数的先后顺序
    [self createViewControllers];
    //[self createMyTabBarItem];
}

- (void)createViewControllers {
    NSMutableArray * viewControllers = [[NSMutableArray alloc] init];

    ZZBDemoViewController * demoVC = [[ZZBDemoViewController alloc] init];
    UINavigationController * Mnav = [[UINavigationController alloc] initWithRootViewController:demoVC];
    [viewControllers addObject:Mnav];
    demoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_shouye_weixuanzhong"] selectedImage:[UIImage imageNamed:@"tab_shouye_xuanzhong"]];
    
    ZzbGameManager * gameManager = [ZzbGameManager sharedManager];
    UINavigationController *gameNav = [gameManager createGameNavController];
    [viewControllers addObject:gameNav];
    gameNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"小游戏" image:[UIImage imageNamed:@"tab_gerenziliao_weixuanzhong"] selectedImage:[UIImage imageNamed:@"tab_gerenziliao_xuanzhong"]];
	

    UINavigationController *budaNav = [BUDAdManager createGameNavController];
    [viewControllers addObject:budaNav];
    budaNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"广告" image:[UIImage imageNamed:@"tab_gerenziliao_weixuanzhong"] selectedImage:[UIImage imageNamed:@"tab_gerenziliao_xuanzhong"]];
    



    self.viewControllers = viewControllers;
    self.tabBar.tintColor = [UIColor colorWithRed:255.0/255 green:204.0/255 blue:13.0/255 alpha:1];
    self.tabBar.translucent = NO;
    self.delegate = self;
}

# pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}


@end
