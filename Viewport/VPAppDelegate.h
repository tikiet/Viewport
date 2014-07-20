#import <Cocoa/Cocoa.h>
#import "VPFeed.h"
#import "VPFeedView.h"
#import "VPLoginViewController.h"
#import "VPFeedsViewController.h"
#import "VPInfo.h"
#import "MASPreferencesWindowController.h"
#import "VPPreferenceAdvancedViewController.h"
#import "TKNavigationController.h"

@interface VPAppDelegate : NSObject <NSApplicationDelegate, VPLoginViewDelegate, VPLoginDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSView *contentArea;
@property (strong) IBOutlet NSView *navigationArea;
@property (weak) IBOutlet NSView *rootView;

@end
