//
//  VPCaption.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPCaption.h"

@implementation VPCaption

@synthesize captionId, createdTime, user, text;

-(id)initWithUser:(VPUser *)u text:(NSString *)t createdTime:(NSString *)ct id:(NSString *)cid
{
    self = [super init];
    if (self) {
        self.user = u;
        self.text = t;
        self.createdTime = ct;
        self.captionId = cid;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary != nil && ![dictionary isEqual:[NSNull null]]){
        VPUser *u = [[VPUser alloc] initWithDictionary:[dictionary objectForKey:@"from"]];
        NSString *t = [dictionary objectForKey:@"text"];
        NSString *ct = [dictionary objectForKey:@"created_time"];
        NSString *cid = [dictionary objectForKey:@"id"];
        
        return [self initWithUser:u text:t createdTime:ct id:cid];
    }
    return nil;
}
@end
