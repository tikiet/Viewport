//
//  VPImages.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPImages.h"

@implementation VPImages

@synthesize standardResolution, lowResolution, thumbnail;

-(id)initWithStandardResolution:(VPImage *)s lowResolution:(VPImage *)l thumbnail:(VPImage *)t
{
    self = [super init];
    if (self) {
        self.standardResolution = s;
        self.lowResolution = l;
        self.thumbnail = t;
    }
    return self;
}

-(id)initWithDictionray:(NSDictionary *)dictionary
{
    VPImage *s = [[VPImage alloc] initWithDictionary:[dictionary objectForKey:@"standard_resolution"]];
    VPImage *l = [[VPImage alloc] initWithDictionary:[dictionary objectForKey:@"low_resolution"]];
    VPImage *t = [[VPImage alloc] initWithDictionary:[dictionary objectForKey:@"thumbnail"]];
    
    return [self initWithStandardResolution:s lowResolution:l thumbnail:t];
}
@end
