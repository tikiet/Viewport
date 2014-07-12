//
//  VPImage.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPImage : NSObject <NSCoding>

@property NSString *url;
@property int height;
@property int width;

-(id) initWithUrl:(NSString*)url width:(int)width height:(int)height;
-(id) initWithDictionary:(NSDictionary*)dictionary;

@end
