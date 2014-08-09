//
//  ClickableTableView.m
//  Viewport
//
//  Created by 吴旭东 on 8/9/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import "ClickableTableView.h"

@implementation ClickableTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    NSPoint globalLocation = [theEvent locationInWindow];
    NSPoint localLocation = [self convertPoint:globalLocation fromView:nil];
    NSInteger clickedRow = [self rowAtPoint:localLocation];
    
    [super mouseDown:theEvent];
    
    if (clickedRow != -1) {
        [self.extendedDelegate tableView:self didClickedRow:clickedRow];
    }
}

@end
