//
//  VPInfo.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPInfo.h"

@implementation VPInfo

static NSString *clientId;
static NSString *popularUrl = @"https://api.instagram.com/v1/media/popular?client_id=%@";
static NSString *selfTimelineUrl = @"https://api.instagram.com/v1/users/self/feed?access_token=%@";
static NSString *accessToken;

+(void)initialize
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:nil
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@", errorDesc);
    } else {
        clientId = [temp objectForKey:@"CLIENT_ID"];
    }
}

+(NSURL*)retrievePopularUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:popularUrl, clientId]];
}

+(NSURL*)retrieveSelfTimelineUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:selfTimelineUrl, accessToken]];
}

+(NSString*)accessToken
{
    return accessToken;
}

+(void)setAccessToken:(NSString *)token
{
    accessToken = token;
}
@end
