#import <Foundation/Foundation.h>

@interface VPRelationship : NSObject

enum status { follows, requested, followed_by, requested_by, blocked_by_you, none };

@property enum status outgoingStatus;
@property enum status incomingStatus;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
