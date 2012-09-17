//
//  AppEngineChannel.m
//  AppEngineChannel
//
//  Created by 菊池 淳 on 12/08/29.
//  Copyright (c) 2012年 Jun Kikuchi. All rights reserved.
//

#import <UIKit/UIWebView.h>
#import "AppEngineChannel.h"

@interface AppEngineChannelProtocol : NSURLProtocol
@end

@implementation AppEngineChannelProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [request.URL.scheme isEqualToString:@"appenginechannel"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:@"appEngineChannelEvent" object:self.request];
    [center postNotification:notification];
}

- (void)stopLoading {}
@end

@implementation AppEngineChannel {
    UIWebView *_webView;
    id <AppEngineChannelDelegate> _delegate;
}

static NSString *html = @""
"<html>"
"<head><title></title></head>"
"<body>"
"<script src=\"/_ah/channel/jsapi\"></script>"
"<script>"
"var dispatch = function(request) { document.open(); document.write('<iframe src=appenginechannel://' + request + '></iframe>'); document.close(); }; "
"var channel  = new goog.appengine.Channel('%@');"
"var socket   = channel.open({"
    "onmessage: function(data)  { dispatch('onmessage?data=' + JSON.stringify(data));  },"
    "onerror:   function(error) { dispatch('onerror?error='  + JSON.stringify(error)); },"
    "onopen:    function()      { dispatch('onopen'); },"
    "onclose:   function()      { dispatch('onclose'); },"
"});"
"</script>"
"</body>"
"</html>"
"";

- (id)initWithDelegate:(id<AppEngineChannelDelegate>)delegate {
    if(self = [self init]) {
        _delegate = delegate;

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(appEngineChannelEvent:) name:@"appEngineChannelEvent" object:nil];

        [NSURLProtocol registerClass:[AppEngineChannelProtocol class]];
    }
    
    return self;
}

- (void)connectWithToken:(NSString *)token baseURL:(NSURL *)baseURL {
    _webView = [[UIWebView alloc] init];
    [_webView loadHTMLString:[NSString stringWithFormat:html, token] baseURL:baseURL];
}

- (void)appEngineChannelEvent:(NSNotification *)notification {
    NSURLRequest *request = (NSURLRequest *)notification.object;
    NSURL *url = request.URL;
    NSArray *params = [url.query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    for (int i=0; i < params.count; i += 2) {
        NSString *value = [params objectAtIndex:i + 1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *key = [params objectAtIndex:i];
        
        [query setObject:value forKey:key];
    }
    
    if ([url.host isEqualToString:@"onmessage"] && [_delegate respondsToSelector:@selector(appEngineChannel:didReceiveMessage:)]) {
        NSData *data = [[query objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [_delegate appEngineChannel:self didReceiveMessage:message];
    } else if ([url.host isEqualToString:@"onerror"] && [_delegate respondsToSelector:@selector(appEngineChannel:didReceiveError:)]) {
        NSData *data = [[query objectForKey:@"error"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *error = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [_delegate appEngineChannel:self didReceiveError:error];
    } else if([url.host isEqualToString:@"onopen"] && [_delegate respondsToSelector:@selector(appEngineChannelDidConnect:)]) {
        [_delegate appEngineChannelDidConnect:self];
    } else if ([url.host isEqualToString:@"onclose"] && [_delegate respondsToSelector:@selector(appEngineChannelDidDisconnect:)]) {
        [_delegate appEngineChannelDidDisconnect:self];
    }
}
@end