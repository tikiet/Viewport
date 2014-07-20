#import <Cocoa/Cocoa.h>
#import "VPFeed.h"
#import "VPFeedDetailCommentView.h"
#import "VPFeedDetailPhotoView.h"

@interface VPFeedDetailViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property VPFeed *feed;

-(void)show;

@end
