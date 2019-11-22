//
//  ZZBViewController.m
//  ZzbGameSDK
//
//  Created by guixingyu on 11/21/2019.
//  Copyright (c) 2019 guixingyu. All rights reserved.
//

#import "ZZBViewController.h"
#import <ZzbGameSDK/ZzbGameMainViewController.h>
@interface ZZBViewController ()

@end

@implementation ZZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}


- (void)setupUI {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, self.view.frame.size.width, 50);
    [btn setTitle:@"click Me" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickToDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickToDismiss{
    ZzbGameMainViewController *vc = [[ZzbGameMainViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
