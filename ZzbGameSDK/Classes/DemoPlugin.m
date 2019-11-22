//
//  DemoPlugin.m
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "DemoPlugin.h"

@implementation DemoPlugin

- (id)init {
    self = [super initWithName:@"demo"];
    return self;
}

- (void)process:(id)input block:(WAWebPluginBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Demo"
                                                                   message:input
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                block(@{
                                                        @"success": @(YES),
                                                        @"id": @"12345"
                                                        });
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                block(@{@"success": @(NO)});
                                            }]];
    [self.webViewController presentViewController:alert
                                         animated:YES
                                       completion:nil];
}

@end
