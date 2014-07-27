#import <Cocoa/Cocoa.h>
#import "VPFeed.h"
#import "VPFeedDetailCommentView.h"
#import "VPFeedDetailPhotoView.h"
#import "VPModelDelegate.h"

@interface VPFeedDetailViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property VPFeed *feed;

@property NSObject<VPModelDelegate> *modelDelegate;

-(void)show;
-(void)prepare;

@end
