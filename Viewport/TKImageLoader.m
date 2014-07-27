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


static CFMutableDictionaryRef currentBindings;
static NSCache *cache;

+(void)initialize
{
    currentBindings = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                0,
                                                &kCFTypeDictionaryKeyCallBacks,
                                                &kCFTypeDictionaryValueCallBacks);
    cache = [[NSCache alloc] init];
    cache.totalCostLimit = 30 * 1024 * 1024;
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
    NSImage *image = [cache objectForKey:url];
    if (image) {
        imageView.image = image;
    } else {
        imageView.image = nil;
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        NSURLConnection *previousConnection = CFDictionaryGetValue(currentBindings, (__bridge const void*)(imageView));
        
        if (previousConnection && ![previousConnection isEqual:[NSNull null]]) {
            CFDictionaryReplaceValue(currentBindings, (__bridge const void *)(imageView), (__bridge const void *)(connection));
        } else {
            CFDictionaryAddValue(currentBindings, (__bridge const void *)(imageView), (__bridge const void *)(connection));
        }
        
        [connection start];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData: data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLConnection *conn = CFDictionaryGetValue(currentBindings, (__bridge const void *)(imageView));
    if ([connection isEqual:conn]){
        NSImage *image = [[NSImage alloc]initWithData:receivedData];
        if (image) {
            imageView.image = image;
            [cache setObject:image forKey:url cost:receivedData.length];
            CFDictionaryRemoveValue(currentBindings, (__bridge const void *)(imageView));
        }
    }
}
@end
