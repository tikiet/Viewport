#import "VPFeed.h"

@implementation VPFeed

@synthesize user, images, createdTime, feedId, likes, comments, videos;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.user = [aDecoder decodeObjectForKey:@"user"];
    self.images = [aDecoder decodeObjectForKey:@"images"];
    self.createdTime = [aDecoder decodeIntForKey:@"createdTime"];
    self.feedId = [aDecoder decodeObjectForKey:@"feedId"];
    self.comments = [aDecoder decodeObjectForKey:@"comments"];
    self.likes = [aDecoder decodeObjectForKey:@"likes"];
    self.videos = [aDecoder decodeObjectForKey:@"videos"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeObject:self.feedId forKey:@"feedId"];
    [aCoder encodeInt:self.createdTime forKey:@"createdTime"];
    [aCoder encodeObject:self.likes forKey:@"likes"];
    [aCoder encodeObject:self.comments forKey:@"comments"];
    [aCoder encodeObject:self.videos forKey:@"videos"];
}

-(id)initWithUser:(VPUser *)u
           images:(VPImages *)i
          caption:(VPCaption *)c
      createdTime:(int)ct
               id:(NSString*)fid
            likes:(VPLikes *)l
         comments:(VPComments *)cm
           videos:(VPVideos*) v
{
    self = [super init];
    if (self) {
        self.user = u;
        self.images = i;
        self.caption = c;
        self.createdTime = ct;
        self.feedId = fid;
        self.likes = l;
        self.comments = cm;
        self.videos = v;
    }
    return self;
}

-(id)initWithDictionray:(NSDictionary *)dictionary
{
    VPUser *u = [[VPUser alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
    VPImages *i = [[VPImages alloc] initWithDictionray:[dictionary objectForKey:@"images"]];
    VPCaption *c = [[VPCaption alloc] initWithDictionary:[dictionary objectForKey:@"caption"]];
    int ct = [[dictionary objectForKey:@"created_time"] intValue];
    NSString *fid = [dictionary objectForKey:@"id"];
    VPLikes *l = [[VPLikes alloc] initWithDictionary: [dictionary objectForKey:@"likes"]];
    VPComments *cm = [[VPComments alloc] initWithDictionary:[dictionary objectForKey:@"comments"]];
    VPVideos *v = [[VPVideos alloc] initWithDictionary:[dictionary objectForKey:@"videos"]];
    
    return [self initWithUser:u images:i caption:c createdTime:ct id:fid likes:l comments:cm videos:v];
}

-(NSUInteger) hash
{
    return self.feedId.hash;
}

-(BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || !([other isKindOfClass:[self class]])) {
        return NO;
    }
    
    VPFeed *feed = other;
    if (![self.feedId isEqualToString:feed.feedId]) {
        return NO;
    }
    return YES;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"feed id: %@, time:%d", self.feedId, self.createdTime];
}
@end
