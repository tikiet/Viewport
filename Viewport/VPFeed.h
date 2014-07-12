//
//  VPFeed.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPUser.h"
#import "VPImages.h"
#import "VPCaption.h"

@interface VPFeed : NSObject

@property VPUser *user;
@property VPImages *images;
@property VPCaption *caption;
@property int createdTime;
@property NSString *feedId;

-(id)initWithUser:(VPUser*)user images:(VPImages*)images caption:(VPCaption*)caption createdTime:(int)createdTime id:(NSString*)feedId;
-(id)initWithDictionray:(NSDictionary*)dictionary;

@end
