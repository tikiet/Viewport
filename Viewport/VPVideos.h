//
//  VPVideos.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPVideo.h"

@interface VPVideos : NSObject

@property VPVideo *lowBandwidth;
@property VPVideo *lowResolution;
@property VPVideo *standardResolution;

-(id)initWithStandardResolution:(VPVideo*)standard lowResolution:(VPVideo*)lowResolution lowBandwidth:(VPVideo*)lowBandwidth;
-(id)initWithDictionary:(NSDictionary*)dictionray;

@end
