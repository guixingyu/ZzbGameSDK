//
//  DemoViewController.m
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoPlugin.h"
#import "TestView.h"
#import <objc/runtime.h>

@interface DemoViewController ()

@end

@implementation DemoViewController {
    IMP _oldImp;
//    BOOL _closed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerNativeView:TestView.class forType:@"test"];
    }
    return self;
}

- (void)initializePlugins {
    [super initializePlugins];
    
    [self registerPlugin:[DemoPlugin new]];
}

- (void)requestAppInfo:(NSString *)appID session:(nonnull NSURLSession *)session block:(nonnull WAEWebAppRequestCompleteBlock)block {
    [super requestAppInfo:appID session:session block:^(NSError * __nullable error, WAEAppResponse * __nullable info){
        block(error, info);
    }];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    Class clz = [UIApplication.sharedApplication.delegate class];
//    Method method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//    if (method) {
//        _oldImp = method_getImplementation(method);
//    }else {
//        struct objc_method_description m = protocol_getMethodDescription(@protocol(UIApplicationDelegate),
//                                      @selector(application:supportedInterfaceOrientationsForWindow:),
//                                      NO, YES);
//        _oldImp = imp_implementationWithBlock(^(id del, id app, id window) {
//            return UIInterfaceOrientationMaskPortrait;
//        });
//        class_addMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:), _oldImp, m.types);
//        method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//    }
//    method_setImplementation(method, imp_implementationWithBlock(^(id del, id app, id window){
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
//    }));
//}
//
//typedef UIInterfaceOrientationMask (*tIMP)(id obj, SEL sel, id app, id window);
//
//- (void)close {
//    Class clz = [UIApplication.sharedApplication.delegate class];
//    Method method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//
//    UIInterfaceOrientationMask mask = ((tIMP)_oldImp)(UIApplication.sharedApplication.delegate, @selector(application:supportedInterfaceOrientationsForWindow:), nil, nil);
//    if (mask == UIInterfaceOrientationMaskPortrait) {
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//        [UIViewController attemptRotationToDeviceOrientation];
//    } else if (mask == UIInterfaceOrientationMaskLandscape) {
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
//        [UIViewController attemptRotationToDeviceOrientation];
//    }
//    [UIViewController attemptRotationToDeviceOrientation];
//    [super close];
//
//    method_setImplementation(method, _oldImp);
//}

@end
