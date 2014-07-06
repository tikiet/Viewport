//
//  VPImage.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPImage.h"

@implementation VPImage

@synthesize url, height, width;

-(id)initWithUrl:(NSString *)u width:(int)w height:(int)h
{
    self = [super init];
    if (self) {
        self.url = u;
        self.height = h;
        self.width = w;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *url = [dictionary objectForKey:@"url"];
    int height = [[dictionary objectForKey:@"height"] intValue];
    int width = [[dictionary objectForKey:@"width"] intValue];
    
    return [self initWithUrl:url width:width height:height];
}

@end
