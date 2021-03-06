#import "VPInfo.h"

@implementation VPInfo

static NSString *popularUrl = @"https://api.instagram.com/v1/media/popular?client_id=%@";
static NSString *selfTimelineUrl = @"https://api.instagram.com/v1/users/self/feed?access_token=%@";
static NSString *favoritesUrl = @"https://api.instagram.com/v1/users/self/media/liked?access_token=%@";
static NSString *userDetailUrl = @"https://api.instagram.com/v1/users/%@/?access_token=%@";
static NSString *userRecentUrl = @"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@&count=60";
static NSString *userRelationshipUrl = @"https://api.instagram.com/v1/users/%@/relationship?access_token=%@";
static NSString *userSearchUrl = @"https://api.instagram.com/v1/users/search?q=%@&access_token=%@";
static NSMutableDictionary *mapping;

#define ACCESS_TOKEN @"ACCESS_TOKEN"
#define CLIENT_ID @"CLIENT_ID"
#define FEED_CACHE @"feed_cache"

+(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCache)
                                                 name:NOTIFICATION_CLEAR_CACHE
                                               object:nil];
    
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
        }
    }
}

+(NSURL*)retrieveUrlWithIdentifier:(NSString *)identifier nextMaxId:(NSString*)nextMaxId
{
    if ([ID_FAVORITES isEqual:identifier]) {
        return [self retrieveFavoritesUrlWithNextMaxId:nextMaxId];
    } else if ([ID_POPULAR isEqual:identifier]) {
        return [self retrievePopularUrlWithNextMaxId:nextMaxId];
    } else if ([ID_SELF isEqual:ID_SELF]) {
        return [self retrieveSelfTimelineUrlWithNextMatId:nextMaxId];
    } else {
        return nil;
    }
}

+(void)clearCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FEED_CACHE];
}

+(NSData*)retrieveCachedFeedDataWithIdentifier:(NSString *)identifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!defaults){
        return nil;
    }
    
    NSMutableDictionary *dic = [defaults objectForKey:FEED_CACHE];
    return [dic objectForKey:identifier];
}

+(void)cacheFeedData:(NSData *)data withIdentifier:(NSString *)identifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *feedCache = [defaults objectForKey:FEED_CACHE];
    if (!feedCache) {
        feedCache = [[NSMutableDictionary alloc]init];
    } else {
        feedCache = [NSMutableDictionary dictionaryWithDictionary:feedCache];
    }
    [feedCache setObject:data forKey:identifier];
    [defaults setObject:feedCache forKey:FEED_CACHE];
}

+(NSURL*)retrievePopularUrlWithNextMaxId:(NSString*)nextMaxId
{
    NSString *url = [NSString stringWithFormat:popularUrl, [self clientId]];
    if (nextMaxId) {
        url = [NSString stringWithFormat:@"%@&max_id=%@", url, nextMaxId];
    }
    return [NSURL URLWithString:url];
}

+(NSURL*)retrieveSelfTimelineUrlWithNextMatId:(NSString*)nextMaxId
{
    NSString *url = [NSString stringWithFormat:selfTimelineUrl, [self accessToken]];
    if (nextMaxId) {
        url = [NSString stringWithFormat:@"%@&max_id=%@", url, nextMaxId];
    }
    return [NSURL URLWithString: url];
}

+(NSURL*)retrieveFavoritesUrlWithNextMaxId:(NSString*)nextMaxId;
{
    NSString *url = [NSString stringWithFormat:favoritesUrl, [self accessToken]];
    if (nextMaxId) {
        url = [NSString stringWithFormat:@"%@&max_id=%@", url, nextMaxId];
    }
    return [NSURL URLWithString: url];
}


+(NSURL*)retrieveUserDetailUrlWithUserId:(NSString *)userId
{
    return [NSURL URLWithString:[NSString stringWithFormat:userDetailUrl, userId, [self accessToken]]];
}

+(NSURL*)retrieveUserRecentsUrlWithUserId:(NSString *)userId nextMaxId:(NSString *)maxId
{
    NSString *url = [NSString stringWithFormat:userRecentUrl, userId, [self accessToken]];
    if (maxId) {
        url = [NSString stringWithFormat:@"%@&max_id=%@", url, maxId];
    }
    return [NSURL URLWithString:url];
}

+(NSURL*)retrieveUserRelationshipWithUserId:(NSString *)userId
{
    NSString *url = [NSString stringWithFormat:userRelationshipUrl, userId, [self accessToken]];
    return [NSURL URLWithString:url];
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

+(NSURL *)retrieveUserSearchUrlWithQueryParameter:(NSString *)q
{
    NSString *url = [NSString stringWithFormat:userSearchUrl, q, [self accessToken]];
    return [NSURL URLWithString:url];
}
@end
