//
//  MHImageView.h
//  webapps
//
//  Created by Gen2 on 2019/1/8.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "symbols.h"

@class WAEImageView;

@protocol WAEImageViewDelegate <NSObject>

@optional

- (void)imageView:(WAEImageView*)imageView download:(NSData*)data;
- (void)imageView:(WAEImageView*)imageView image:(UIImage *)image;

@end

@interface WAEImageView : UIImageView

@property (nonatomic, weak) id <WAEImageViewDelegate> delegate;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSURL *url;

@end
