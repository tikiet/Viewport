#import "VPLikes.h"

@implementation VPLikes

@synthesize count, users;

-(id)initWithCount:(int)c users:(NSArray *) u
{
    self = [super init];
    
    if (self) {
        self.count = c;
        self.users = u;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionray
{
    int c = [[dictionray objectForKey:@"count"] intValue];
    NSMutableArray *u = [[NSMutableArray alloc] init];
    NSArray *array = [dictionray objectForKey:@"data"];
    for (NSDictionary *dic in array){
        [u addObject:[[VPUser alloc] initWithDictionary:dic]];
    }
    
    return [self initWithCount:c users:u];
    
}

@end
