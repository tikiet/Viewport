//
//  VPSearchViewController.m
//  Viewport
//
//  Created by 吴旭东 on 8/6/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import "VPSearchViewController.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"

@interface VPSearchViewController ()

@end

@implementation VPSearchViewController

-(void)awakeFromNib
{
}

- (IBAction)enter:(id)sender {
    [self startSearch:((NSSearchField *)sender).stringValue];
}

- (void) startSearch:(NSString*)query
{
    NSURL *url = [VPInfo retrieveUserSearchUrlWithQueryParameter:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self updateData:data];
                                              } failBlock:^(NSError *error){
                                                  NSLog(@"error:%@", error);
                                              }]];
    [con start];
}

-(void)updateData:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"raw:%@", raw);
}
@end
