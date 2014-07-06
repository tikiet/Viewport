//
//  VPLikes.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPUser.h"

@interface VPLikes : NSObject

@property int count;
@property NSArray *users;

-(id)initWithCount:(int)count users:(NSArray *) users;
-(id)initWithDictionary:(NSDictionary*) dictionray;

@end
