#import <Foundation/Foundation.h>
#import "VPUser.h"
#import "VPImages.h"
#import "VPCaption.h"
#import "VPComments.h"
#import "VPLikes.h"

@interface VPFeed : NSObject <NSCoding>

@property VPUser *user;
@property VPImages *images;
@property VPCaption *caption;
@property int createdTime;
@property NSString *feedId;
@property VPComments *comments;
@property VPLikes *likes;

-(id)initWithDictionray:(NSDictionary*)dictionary;

@end