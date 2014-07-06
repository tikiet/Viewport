//
//  VPVideo.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPVideo.h"

@implementation VPVideo

@synthesize url, height, width;

-(id)initWithUrl:(NSString *)url width:(int)width height:(int)height
{
    self = [super init];
    if (self) {
        self.url = url;
        self.width = width;
        self.height = height;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    int width = [[dictionary objectForKey:@"width"] intValue];
    int height = [[dictionary objectForKey:@"height"] intValue];
    NSString *url = [dictionary objectForKey:@"url"];
    
    return [self initWithUrl:url width:width height:height];
}
@end
