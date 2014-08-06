//
//  VPSearchViewController.h
//  Viewport
//
//  Created by 吴旭东 on 8/6/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VPSearchViewController : NSViewController

@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;

@end
