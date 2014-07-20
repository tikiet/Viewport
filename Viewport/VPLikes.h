#import <Foundation/Foundation.h>
#import "VPUser.h"

@interface VPLikes : NSObject

@property int count;
@property NSArray *users;

-(id)initWithCount:(int)count users:(NSArray *) users;
-(id)initWithDictionary:(NSDictionary*) dictionray;

@end
