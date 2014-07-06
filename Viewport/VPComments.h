//
//  VPComments.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPComment.h"

@interface VPComments : NSObject

@property int count;
@property NSArray *comments;

-(id) initWithCount:(int) count comments:(NSArray *)comments;
-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
