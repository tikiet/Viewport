//
//  TKImageLoader.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-13.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "TKImageLoader.h"

@implementation TKImageLoader
{
    NSURL *url;
    NSImageView *imageView;
    NSMutableData *receivedData;
}

-(id)initWithURL:(NSURL *)u imageView:(NSImageView *)iv
{
    self = [super init];
    if (self) {
        url = u;
        imageView = iv;
        receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)start
{
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData: data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    imageView.image = [[NSImage alloc]initWithData:receivedData];
}
@end
