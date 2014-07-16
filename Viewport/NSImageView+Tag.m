//
//  NSImageView+Tag.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-16.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "NSImageView+Tag.h"

@implementation NSImageView (Tag)

NSURL *tag;

-(NSURL*)tag
{
    return tag;
}

-(void)setTag:(NSURL*)t
{
    tag = t;
}
@end
