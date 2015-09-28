//
//    DKSignedRequest.m
//
//    Modified by Daniel Khamsing on 9/30/15.
//
//    Copyright (c) 2011-2015 Sean Cook
//
//    Permission is hereby granted, free of charge, to any person obtaining a
//    copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to permit
//    persons to whom the Software is furnished to do so, subject to the
//    following conditions:
//
//    The above copyright notice and this permission notice shall be included
//    in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
//    NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
//    USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <OAuthCore/OAuthCore.h>
#import "DKSignedRequest.h"
#import "DKTwitterReverseAuth.h"

static NSString * const tw_http_method_post = @"POST";
static NSString * const tw_http_method_delete = @"DELETE";
static NSString * const tw_http_method_get = @"GET";
static NSString * const tw_http_header_authorization = @"Authorization";
static NSInteger request_timeout_interval = 8;

static NSString *gTWConsumerKey;
static NSString *gTWConsumerSecret;

@interface DKSignedRequest()
{
    NSURL *_url;
    NSDictionary *_parameters;
    TWTSignedRequestMethod _signedRequestMethod;
    NSOperationQueue *_signedRequestQueue;
}

@end

@implementation DKSignedRequest

- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(TWTSignedRequestMethod)requestMethod
{
    self = [super init];
    if (self) {
        _url = url;
        _parameters = parameters;
        _signedRequestMethod = requestMethod;
        _signedRequestQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSURLRequest *)_buildRequest
{
    NSString *method;
    
    switch (_signedRequestMethod) {
        case TWSignedRequestMethodPOST:
            method = tw_http_method_post;
            break;
        case TWSignedRequestMethodDELETE:
            method = tw_http_method_delete;
            break;
        case TWSignedRequestMethodGET:
        default:
            method = tw_http_method_get;
    }
    
    //  Build our parameter string
    NSMutableString *paramsAsString = [[NSMutableString alloc] init];
    [_parameters enumerateKeysAndObjectsUsingBlock:
     ^(id key, id obj, BOOL *stop) {
         [paramsAsString appendFormat:@"%@=%@&", key, obj];
     }];
    
    //  Create the authorization header and attach to our request
    NSData *bodyData = [paramsAsString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorizationHeader = OAuthorizationHeader(_url, method, bodyData, [DKSignedRequest consumerKey], [DKSignedRequest consumerSecret], _authToken, _authTokenSecret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    [request setTimeoutInterval:request_timeout_interval];
    [request setHTTPMethod:method];
    [request setValue:authorizationHeader forHTTPHeaderField:tw_http_header_authorization];
    [request setHTTPBody:bodyData];
    
    return request;
}

- (void)performRequestWithHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler
{
    NSURLRequest *request = [self _buildRequest];
    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:_signedRequestQueue] dataTaskWithRequest:request completionHandler:handler] resume];
}

+ (NSString *)consumerKey
{
    return [DKTwitterReverseAuth sharedInstance].consumerKey;
}

+ (NSString *)consumerSecret
{
    return [DKTwitterReverseAuth sharedInstance].consumerSecret;
}

@end
