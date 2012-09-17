//
//  AppEngineChannel.h
//  AppEngineChannel
//
//  Created by 菊池 淳 on 12/08/29.
//  Copyright (c) 2012年 Jun Kikuchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppEngineChannel;

@protocol AppEngineChannelDelegate <NSObject>
@optional
- (void) appEngineChannelOpen:(AppEngineChannel *)channel;
- (void) appEngineChannel:(AppEngineChannel *)channel message:(NSDictionary *)message;
- (void) appEngineChannel:(AppEngineChannel *)channel error:(NSDictionary *)error;
- (void) appEngineChannelClose:(AppEngineChannel *)channel;
@end

@interface AppEngineChannel : NSObject
- (id)initWithBaseURL:(NSURL *)baseURL token:(NSString *)token delegate:(id <AppEngineChannelDelegate>)delegate;
@end
