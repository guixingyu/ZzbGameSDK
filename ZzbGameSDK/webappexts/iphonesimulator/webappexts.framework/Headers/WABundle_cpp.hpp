//
//  WABundle_cpp.hpp
//  webapp
//
//  Created by Gen2 on 2019/11/6.
//  Copyright © 2019 Gen2. All rights reserved.
//

#ifndef WABundle_cpp_h
#define WABundle_cpp_h

#import <UIKit/UIKit.h>
#include <vector>
#include <map>
#include <string>


struct WABundleItem {
    std::vector<uint8_t> buffer;
    int scale;
};


@interface WABundle(WABundleCPP)

+ (void)setup:(const std::map<std::string, std::map<std::string, WABundleItem> > &)data;

@end

#endif /* WABundle_cpp_h */
