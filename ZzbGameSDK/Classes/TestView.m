//
//  TestView.m
//  Project1
//
//  Created by Gen2 on 2019/8/28.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self registerMethod:@"send"
                    selector:@selector(send:block:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)onInitialize:(NSDictionary *)params {
    [super onInitialize:params];
    NSLog(@"on init:\n %@", params);
}

- (void)send:(NSArray *)arr block:(WAWebPluginBlock)block {
    NSLog(@"Got send event");
    block(nil);
}

- (void)onDestroy {
    [super onDestroy];
    NSLog(@"destroy");
}

- (void)clicked {
    [self sendEvent:@{
                      @"type": @"click",
                      @"value": @{
                              @"data": @(10)
                              }
                      }
              block:nil];
}

@end
