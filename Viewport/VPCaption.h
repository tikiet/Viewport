//
//  VPCaption.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPUser.h"

@interface VPCaption : NSObject

@property NSString *createdTime;
@property NSString *text;
@property NSString *captionId;
@property VPUser *user;

-(id)initWithUser:(VPUser*)user text:(NSString*)text createdTime:(NSString*)createdTime id:(NSString*)captionId;
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
