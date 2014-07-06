//
//  VPUser.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPUser : NSObject

@property int userId;
@property NSString *fullName;
@property NSString *name;
@property NSString *profilePicture;
@property NSString *website;
@property NSString *bio;

-(id)initWithID:(int) userId name:(NSString *) name fullName:(NSString*) fullName profilePicture:(NSString*) profilePicture webSite:(NSString*) webSite biography:(NSString*) biography;

-(id)initWithID:(int) userId name:(NSString *) name fullName:(NSString*) fullName profilePicture:(NSString*) profilePicture;

-(id)initWithDictionary:(NSDictionary*) dictionary;

@end
