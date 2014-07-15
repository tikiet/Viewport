//
//  VPInfo.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_CLEAR_CACHE @"VPClearCache"

@interface VPInfo : NSObject

+(NSURL *)retrieveSelfTimelineUrl;
+(NSURL *)retrievePopularUrl;
+(NSURL *)retrieveFavoritesUrl;

+(void)cacheFeedData:(NSData*)data withIdentifier:(NSString*)identifier;
+(NSData*)retrieveCachedFeedDataWithIdentifier:(NSString*)identifier;

+(void)setAccessToken:(NSString*)token;
+(NSString*)accessToken;

@end
