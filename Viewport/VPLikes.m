//
//  VPLikes.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPLikes.h"

@implementation VPLikes

@synthesize count, users;

-(id)initWithCount:(int)count users:(NSArray *) users
{
    self = [super init];
    
    if (self) {
        self.count = count;
        self.users = users;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionray
{
    int count = [[dictionray objectForKey:@"count"] intValue];
    NSMutableArray *users = [[NSMutableArray alloc] init];
    NSArray *array = [dictionray objectForKey:@"data"];
    for (NSDictionary *dic in array){
        [users addObject:[[VPUser alloc] initWithDictionary:dic]];
    }
    
    return [self initWithCount:count users:users];
    
}

@end
