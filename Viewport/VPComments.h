#import <Foundation/Foundation.h>
#import "VPComment.h"

@interface VPComments : NSObject

@property int count;
@property NSArray *comments;

-(id) initWithCount:(int) count comments:(NSArray *)comments;
-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
