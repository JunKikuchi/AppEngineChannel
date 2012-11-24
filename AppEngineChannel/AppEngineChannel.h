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
- (void) appEngineChannelDidConnect:(AppEngineChannel *)channel;
- (void) appEngineChannelDidDisconnect:(AppEngineChannel *)channel;
- (void) appEngineChannel:(AppEngineChannel *)channel didReceiveMessage:(NSDictionary *)message;
- (void) appEngineChannel:(AppEngineChannel *)channel didReceiveError:(NSDictionary *)error;
@end

@interface AppEngineChannel : NSObject <UIWebViewDelegate>
- (id)initWithDelegate:(id<AppEngineChannelDelegate>)delegate;
- (void)connectWithToken:(NSString *)token baseURL:(NSURL *)baseURL;
@end
