#import <Cocoa/Cocoa.h>
#import "VPModelDelegate.h"
#import "ClickableTableView.h"

@interface VPSearchViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, ExtendedTableViewDelegate>

@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet ClickableTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;

@property id<VPModelDelegate> delegate;

@end
