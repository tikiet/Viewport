//
//  VPConnectionDataDepot.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPConnectionDataDepot : NSObject <NSURLConnectionDataDelegate>

-(id)initWithSuccessBlock:(void (^)(NSData *))sb failBlock:(void (^)(NSError *))fb;

@end
