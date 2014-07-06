//
//  VPComment.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPComment.h"

@implementation VPComment

@synthesize user, text, createdTime;

-(id) initWithUser:(VPUser *)user text:(NSString *)text createdTime:(long)createdTime
{
    self = [super init];
    if(self){
        self.user = user;
        self.text = text;
        self.createdTime = createdTime;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    VPUser *user = [[VPUser alloc] initWithDictionary:[dictionary objectForKey:@"from"]];
    NSString *text = [dictionary objectForKey:@"text"];
    long createdTime = [[dictionary objectForKey:@"created_time"] longValue];
    
    return [self initWithUser:user text:text createdTime:createdTime];
}

-(id)init
{
    return [self initWithUser:nil text:nil createdTime:0];
}
@end
