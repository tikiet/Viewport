#import <Foundation/Foundation.h>
#import "VPUser.h"

@interface VPComment : NSObject

@property VPUser *user;
@property NSString *text;
@property long createdTime;

-(id)initWithUser:(VPUser*)user text:(NSString*)text createdTime:(long)createdTime;
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
