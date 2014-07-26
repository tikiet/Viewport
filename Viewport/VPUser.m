//
//  VPUser.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-1.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPUser.h"

@implementation VPUser

@synthesize name, fullName, userId, profilePicture, followerCount, followingCount, postCount;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self.userId = [aDecoder decodeIntForKey:@"userId"];
    self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.profilePicture = [aDecoder decodeObjectForKey:@"profilePicture"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.profilePicture forKey:@"profilePicture"];
    [aCoder encodeInt:self.userId forKey:@"userId"];
}

-(id)initWithID:(int) uid
           name:(NSString *) userName
       fullName:(NSString *)userFullname
 profilePicture:(NSString *) picture
        webSite:(NSString *)webSite
      biography:(NSString *)biography
          stats:(NSDictionary *)stats
{
    self = [super init];
    if (self) {
        self.name = userName;
        self.fullName = userFullname;
        self.userId = uid;
        self.profilePicture = picture;
        self.website = webSite;
        self.bio = biography;
        
        NSLog(@"stats:%@", stats);
        if (stats && ![stats isEqual:[NSNull null]]) {
            self.followingCount = [[stats objectForKey:@"follows"] intValue];
            self.followerCount = [[stats objectForKey:@"followed_by"] intValue];
            self.postCount = [[stats objectForKey:@"media"] intValue];
        }
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"dic:%@, counts:%@", dictionary, [dictionary valueForKey:@"counts"]);
    return [self initWithID:[[dictionary objectForKey:@"id"] intValue]
                       name:[dictionary objectForKey:@"username"]
                   fullName:[dictionary objectForKey:@"full_name"]
             profilePicture:[dictionary objectForKey:@"profile_picture"]
                    webSite:[dictionary objectForKey:@"website"]
                  biography:[dictionary objectForKey:@"bio"]
                      stats:[dictionary objectForKey:@"counts"]
            ];
}

-(id)init
{
    return [self initWithID:0 name:nil fullName:nil profilePicture:nil webSite:nil biography:nil stats:nil];
}
@end
