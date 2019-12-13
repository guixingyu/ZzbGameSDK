//
//  ZzbRootNavViewController.m
//  ZzbGameSDK
//
//  Created by isec on 2019/11/27.
//

#import "ZzbRootNavViewController.h"
#import <objc/runtime.h>
@interface ZzbRootNavViewController ()<UINavigationControllerDelegate>

@end

@implementation ZzbRootNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Method m = class_getInstanceMethod(UIViewController.class, @selector(shouldAutorotate));
    method_setImplementation(m, imp_implementationWithBlock(^(id obj){
        return NO;
    }));
    m = class_getInstanceMethod(UIViewController.class, @selector(supportedInterfaceOrientations));
    method_setImplementation(m, imp_implementationWithBlock(^(id obj){
        return UIInterfaceOrientationMaskPortrait;
    }));
    m = class_getInstanceMethod(UIViewController.class, @selector(preferredInterfaceOrientationForPresentation));
    method_setImplementation(m, imp_implementationWithBlock(^(id obj){
        return UIInterfaceOrientationPortrait;
    }));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

@end
