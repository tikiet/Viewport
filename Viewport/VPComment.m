#import "VPComment.h"

@implementation VPComment

@synthesize user, text, createdTime;

-(id) initWithUser:(VPUser *)u text:(NSString *)t createdTime:(long)c
{
    self = [super init];
    if(self){
        self.user = u;
        self.text = t;
        self.createdTime = c;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    VPUser *u = [[VPUser alloc] initWithDictionary:[dictionary objectForKey:@"from"]];
    NSString *t = [dictionary objectForKey:@"text"];
    long c = [[dictionary objectForKey:@"created_time"] intValue];
    
    return [self initWithUser:u text:t createdTime:c];
}

-(id)init
{
    return [self initWithUser:nil text:nil createdTime:0];
}
@end
