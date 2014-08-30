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

-(id)initWithUrl:(NSString *)u width:(int)w height:(int)h
{
    self = [super init];
    if (self) {
        self.url = u;
        self.width = w;
        self.height = h;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    int w = [[dictionary objectForKey:@"width"] intValue];
    int h = [[dictionary objectForKey:@"height"] intValue];
    NSString *u = [dictionary objectForKey:@"url"];
    
    return [self initWithUrl:u width:w height:h];
}
@end
