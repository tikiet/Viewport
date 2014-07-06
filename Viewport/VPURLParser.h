//
//  VPURLParser.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPURLParser : NSObject

-(id)initWithURL:(NSURL*)url;
-(id)initWithString:(NSString*)string;

-(NSString*) parameterForKey:(NSString*)key;

@end
