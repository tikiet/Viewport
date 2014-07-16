//
//  NSImageView+Tag.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-16.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImageView (Tag)

-(NSURL*)tag;
-(void)setTag:(NSURL*)t;

@end
