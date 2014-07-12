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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.height = [aDecoder decodeIntForKey:@"height"];
    self.width = [aDecoder decodeIntForKey:@"width"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInt:self.height forKey:@"height"];
    [aCoder encodeInt:self.width forKey:@"width"];
}

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
    NSString *u = [dictionary objectForKey:@"url"];
    int h = [[dictionary objectForKey:@"height"] intValue];
    int w = [[dictionary objectForKey:@"width"] intValue];
    
    return [self initWithUrl:u width:w height:h];
}

@end
