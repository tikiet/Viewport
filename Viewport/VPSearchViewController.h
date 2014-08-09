#import <Cocoa/Cocoa.h>
#import "VPModelDelegate.h"

@interface VPSearchViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;

@property id<VPModelDelegate> delegate;

@end
