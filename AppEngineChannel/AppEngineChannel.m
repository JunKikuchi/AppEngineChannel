//
//  AppEngineChannel.m
//  AppEngineChannel
//
//  Created by 菊池 淳 on 12/08/29.
//  Copyright (c) 2012年 Jun Kikuchi. All rights reserved.
//

#import <UIKit/UIWebView.h>
#import "AppEngineChannel.h"

#define isRespond(a, s) [_delegate respondsToSelector:(s)] && [action isEqualToString:(a)]
#define NSLog(...)

@implementation AppEngineChannel {
    NSString *_token;
    UIWebView *_webView;
    id <AppEngineChannelDelegate> _delegate;
}

- (id)initWithDelegate:(id<AppEngineChannelDelegate>)delegate {
    if(self = [self init]) {
        _delegate = delegate;
    }
    
    return self;
}

- (void)connectWithToken:(NSString *)token baseURL:(NSURL *)baseURL {
    _token = token;
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    
    extern unsigned char AppEngineChannel_html[];
    extern unsigned int AppEngineChannel_html_len;
    
    NSData *data = [NSData dataWithBytes:AppEngineChannel_html length:AppEngineChannel_html_len];
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [_webView loadHTMLString:[NSString stringWithFormat:html, _token] baseURL:baseURL];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest: %@", request.URL);

    if(![request.URL.scheme isEqualToString:@"appenginechannel"]) {
        return YES;
    }
    
    NSString *json = [_webView stringByEvaluatingJavaScriptFromString:@"fetch();"];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *commands = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"json: %@", json);
    for (NSArray *command in commands) {
        NSString *action = [command objectAtIndex:0];
        NSDictionary *params = [command objectAtIndex:1];
        
        if (isRespond(@"onmessage", @selector(appEngineChannel:didReceiveMessage:))) {
            [_delegate appEngineChannel:self didReceiveMessage:params];
        } else if (isRespond(@"onerror", @selector(appEngineChannel:didReceiveError:))) {
            [_delegate appEngineChannel:self didReceiveError:params];
        } else if(isRespond(@"onopen", @selector(appEngineChannelDidConnect:))) {
            [_delegate appEngineChannelDidConnect:self];
        } else if (isRespond(@"onclose", @selector(appEngineChannelDidDisconnect:))) {
            [_delegate appEngineChannelDidDisconnect:self];
        }
    }
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad:%@", webView.request.URL);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webVeiw:didFailLoadWithError:%@", error);
}

@end