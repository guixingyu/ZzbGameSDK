//
//  DemoViewController.h
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <webappexts/webappexts.h>
#import <JSONModel/JSONModel.h>

@interface LogModel : JSONModel
@property (nonatomic) BOOL success;
@property (nonatomic) NSString  *code;
@property (nonatomic) NSString  *imgAddr;
@property (nonatomic) NSString  *videoAddr;
@property (nonatomic) NSString  *description;
@end

@interface DemoViewController : WAEMainViewController
- (void)setAppletId:(NSInteger)appletId;
@end
