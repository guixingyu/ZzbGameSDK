//
//  ZZBDemo1ViewController.m
//  ZzbGameSDK_Example
//
//  Created by isec on 2019/12/6.
//  Copyright © 2019年 guixingyu. All rights reserved.
//

#import "ZZBDemoViewController.h"
#import <ZzbGameSDK/ZzbGameManager.h>

@interface ZZBDemoViewController ()

@end

@implementation ZZBDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, self.view.frame.size.width, 50);
    [btn setTitle:@"调用SDK接口" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickToDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickToDismiss{
    
    ZzbGameManager * gameManager = [ZzbGameManager sharedManager];
    [self presentViewController:[gameManager createGameNavController] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
