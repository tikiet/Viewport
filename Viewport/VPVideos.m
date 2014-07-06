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

-(id)initWithStandardResolution:(VPVideo *)standard lowResolution:(VPVideo *)lowResolution lowBandwidth:(VPVideo *)lowBandwidth
{
    self = [super init];
    if (self) {
        self.lowResolution = lowResolution;
        self.lowBandwidth = lowBandwidth;
        self.standardResolution = standard;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionray
{
    VPVideo *standard = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"standard_resolution"]];
    VPVideo *lowResolution = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"low_resolution"]];
    VPVideo *lowBandwidth = [[VPVideo alloc] initWithDictionary:[dictionray objectForKey:@"low_bandwidth"]];
    
    return [self initWithStandardResolution:standard lowResolution:lowResolution lowBandwidth:lowBandwidth];
}
@end
