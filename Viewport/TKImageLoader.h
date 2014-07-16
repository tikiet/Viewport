//
//  TKImageLoader.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-13.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSImageView+Tag.h"

@interface TKImageLoader : NSObject <NSURLConnectionDataDelegate>

-(id)initWithURL:(NSURL *)url imageView:(NSImageView*)imageView;
-(void)start;

@end
