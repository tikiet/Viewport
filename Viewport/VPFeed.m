//
//  VPFeed.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPFeed.h"

@implementation VPFeed

@synthesize user, images;

-(id)initWithUser:(VPUser *)u images:(VPImages *)i caption:(VPCaption *)c
{
    self = [super init];
    if (self) {
        self.user = u;
        self.images = i;
        self.caption = c;
    }
    return self;
}

-(id)initWithDictionray:(NSDictionary *)dictionary
{
    VPUser *u = [[VPUser alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
    VPImages *i = [[VPImages alloc] initWithDictionray:[dictionary objectForKey:@"images"]];
    VPCaption *c = [[VPCaption alloc] initWithDictionary:[dictionary objectForKey:@"caption"]];
    
    return [self initWithUser:u images:i caption:c];
}
@end
