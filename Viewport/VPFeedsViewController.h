#import <Cocoa/Cocoa.h>
#import "VPFeedView.h"
#import "VPFeed.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "TKImageLoader.h"
#import "BSRefreshableScrollView.h"
#import "VPModelDelegate.h"

@protocol VPLoginDelegate <NSObject>

-(void)loginDidFail;

@end

@interface VPFeedsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, BSRefreshableScrollViewDelegate>

@property (weak) IBOutlet NSTableView *tableview;
@property (weak) IBOutlet BSRefreshableScrollView *scrollView;

@property NSObject<VPLoginDelegate> *loginDelegate;
@property NSObject<VPModelDelegate> *modelDelegate;

@property BOOL accumulateData;

-(void)updateData:(NSData*)jsonData;
-(BOOL)startRequestWithNextMaxId:(BOOL)useNextMaxId;
-(void)prepare;
-(id)initWithNibName:(NSString *)nibNameOrNil identifier:(NSString*) identifier bundle:(NSBundle *)nibBundleOrNil;

@end
