//
//  VPSearchUserResultView.h
//  Viewport
//
//  Created by 吴旭东 on 8/9/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VPSearchUserResultView : NSView

@property (weak) IBOutlet NSImageView *profilePicture;
@property (weak) IBOutlet NSTextField *nickname;
@property (weak) IBOutlet NSTextField *fullname;

@end
