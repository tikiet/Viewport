//
//  VPInfo.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPInfo : NSObject

+(NSURL *) retrieveSelfTimelineUrl;
+(NSURL *) retrievePopularUrl;
+(NSURL *) retrieveFavoritesUrl;

+(void)setAccessToken:(NSString*)token;
+(NSString*)accessToken;

@end
