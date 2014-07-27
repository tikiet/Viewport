//
//  VPInfo.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_CLEAR_CACHE @"VPClearCache"
#define ID_SELF @"self"
#define ID_POPULAR @"popular"
#define ID_FAVORITES @"favorites"

@interface VPInfo : NSObject

+(NSURL *)retrieveUserDetailUrlWithUserId:(NSString*)userId;
+(NSURL *)retrieveUserRecentsUrlWithUserId:(NSString*)userId nextMaxId:(NSString*)maxId;

+(NSURL *)retrieveUrlWithIdentifier:(NSString*)identifier nextMaxId:(NSString*)nextMaxId;

+(void)cacheFeedData:(NSData*)data withIdentifier:(NSString*)identifier;
+(NSData*)retrieveCachedFeedDataWithIdentifier:(NSString*)identifier;

+(void)setAccessToken:(NSString*)token;
+(NSString*)accessToken;

@end
