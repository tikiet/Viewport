//
//  VPInfo.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPInfo.h"

@implementation VPInfo

static NSString *popularUrl = @"https://api.instagram.com/v1/media/popular?client_id=%@";
static NSString *selfTimelineUrl = @"https://api.instagram.com/v1/users/self/feed?access_token=%@";
static NSString *favoritesUrl = @"https://api.instagram.com/v1/users/self/media/liked?access_token=%@";

#define ACCESS_TOKEN @"ACCESS_TOKEN"
#define CLIENT_ID @"CLIENT_ID"

+(void)initialize
{
    if (![self clientId]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:nil
                                              errorDescription:nil];
        if (!temp) {
            NSLog(@"Error reading plist");
        } else {
            [self setClientId:[temp objectForKey:@"CLIENT_ID"]];
        }}
}

+(NSURL*)retrievePopularUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:popularUrl, [self clientId]]];
}

+(NSURL*)retrieveSelfTimelineUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:selfTimelineUrl, [self accessToken]]];
}

+(NSURL*)retrieveFavoritesUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:favoritesUrl, [self accessToken]]];
}

+(NSString*)clientId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:CLIENT_ID];
}

+(void)setClientId:(NSString*)clientId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clientId forKey:CLIENT_ID];
}

+(NSString*)accessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:ACCESS_TOKEN];
}

+(void)setAccessToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:ACCESS_TOKEN];
}
@end
