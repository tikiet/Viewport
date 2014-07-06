//
//  VPComments.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPComments.h"

@implementation VPComments

@synthesize count, comments;

-(id) initWithCount:(int)cnt comments:(NSArray *)cmt
{
    self = [super init];
    if (self){
        self.count = cnt;
        self.comments = cmt;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    int cnt = [[dictionary objectForKey:@"count"] intValue];
    NSArray *rawArray = [dictionary objectForKey:@"data"];
    NSMutableArray *cmts = [[NSMutableArray alloc]initWithCapacity:rawArray.count];
    for (NSDictionary *commentDictionary in rawArray) {
        [cmts addObject:[[VPComment alloc] initWithDictionary: commentDictionary]];
    }
    return [self initWithCount:cnt comments:cmts];
}
@end
