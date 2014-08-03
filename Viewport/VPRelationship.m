#import "VPRelationship.h"

@implementation VPRelationship

@synthesize incomingStatus, outgoingStatus;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.outgoingStatus = none;
        self.incomingStatus = none;
        
        if (dictionary && ![dictionary isEqualTo:[NSNull null]]) {
            NSString *outgoing = [dictionary objectForKey:@"outgoing_status"];
            if ([@"follows" isEqualTo:outgoing]) {
                self.outgoingStatus = follows;
            } else if ([@"requested" isEqualTo:outgoing]) {
                self.outgoingStatus = requested;
            }
            
            NSString *incoming = [dictionary objectForKey:@"incoming_status"];
            if ([@"followed_by" isEqualTo:incoming]) {
                self.incomingStatus = followed_by;
            } else if ([@"requested_by" isEqualTo:incoming]) {
                self.incomingStatus = requested_by;
            } else if ([@"blocked_by_you" isEqualTo:incoming]) {
                self.incomingStatus = blocked_by_you;
            }
        }
    }
    return self;
}


@end
