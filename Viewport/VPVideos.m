//
//  VPVideos.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPVideos.h"

@implementation VPVideos

@synthesize lowBandwidth, lowResolution, standardResolution;

-(id)initWithStandardResolution:(VPVideo *)s lowResolution:(VPVideo *)lr lowBandwidth:(VPVideo *)lb
{
    self = [super init];
    if (self) {
        self.lowResolution = lr;
        self.lowBandwidth = lb;
        self.standardResolution = s;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionray
{
    VPVideo *s = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"standard_resolution"]];
    VPVideo *lr = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"low_resolution"]];
    VPVideo *lb = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"low_bandwidth"]];
    
    return [self initWithStandardResolution:s lowResolution:lr lowBandwidth:lb];
}
@end
