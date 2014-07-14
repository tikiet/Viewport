//
//  VPAppDelegate.h
//  Viewport
//
//  Created by 吴旭东 on 14-6-29.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VPFeed.h"
#import "VPFeedView.h"
#import "VPLoginViewController.h"
#import "VPFeedsViewController.h"
#import "VPInfo.h"
#import "MASPreferencesWindowController.h"
#import "VPPreferenceAdvancedViewController.h"

@interface VPAppDelegate : NSObject <NSApplicationDelegate, VPLoginViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSView *contentArea;
@property (strong) IBOutlet NSView *navigationArea;
@property (weak) IBOutlet NSView *rootView;

@end
