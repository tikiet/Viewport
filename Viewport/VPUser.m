//
//  VPUser.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPUser.h"

@implementation VPUser

@synthesize name, fullName, userId, profilePicture;

-(id) initWithID:(int)userId name:(NSString *)name fullName:(NSString *)fullName profilePicture:(NSString *)profilePicture
{
    return [self initWithID:userId name:name fullName:fullName profilePicture:profilePicture];
}

-(id)initWithID:(int) uid name:(NSString *) userName fullName:(NSString *)userFullname profilePicture:(NSString *) picture
        webSite:(NSString *)webSite biography:(NSString *)biography
{
    self = [super init];
    if (self) {
        self.name = userName;
        self.fullName = userFullname;
        self.userId = uid;
        self.profilePicture = picture;
        self.website = webSite;
        self.bio = biography;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithID:[[dictionary objectForKey:@"id"] intValue]
                       name:[dictionary objectForKey:@"username"]
                   fullName:[dictionary objectForKey:@"full_name"]
             profilePicture:[dictionary objectForKey:@"profile_picture"]
                    webSite:[dictionary objectForKey:@"website"]
                  biography:[dictionary objectForKey:@"bio"]];
}

-(id)init
{
    return [self initWithID:0 name:nil fullName:nil profilePicture:nil];
}
@end
