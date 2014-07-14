//
//  VPFeedView.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-5.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPFeedView.h"

@implementation VPFeedView

-(NSSize) intrinsicContentSize
{
    NSSize size = NSSizeFromCGSize(CGSizeMake(300, 360));
    return size;
}
@end
