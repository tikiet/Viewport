//
//  VPComment.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPUser.h"

@interface VPComment : NSObject

@property VPUser *user;
@property NSString *text;
@property long createdTime;

-(id)initWithUser:(VPUser*)user text:(NSString*)text createdTime:(long)createdTime;
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
