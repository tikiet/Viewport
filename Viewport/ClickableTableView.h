//
//  ClickableTableView.h
//  Viewport
//
//  Created by 吴旭东 on 8/9/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ExtendedTableViewDelegate <NSObject>

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row;

@end

@interface ClickableTableView : NSTableView

@property (nonatomic, weak) id<ExtendedTableViewDelegate> extendedDelegate;

@end
