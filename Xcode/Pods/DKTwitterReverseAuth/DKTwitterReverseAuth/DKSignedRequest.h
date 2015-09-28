//
//    DKSignedRequest.h
//
//    Modified by Daniel Khamsing on 9/30/15.
//
//    Based Copyright (c) 2011-2015 Sean Cook
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

@import Foundation;

typedef NS_ENUM(NSInteger, TWTSignedRequestMethod) {
    TWSignedRequestMethodGET,
    TWSignedRequestMethodPOST,
    TWSignedRequestMethodDELETE
};

/** Signed request for Twitter. */
@interface DKSignedRequest : NSObject

/**
 Auth token.
 */
@property (nonatomic, copy) NSString *authToken;

/**
 Auth token secret.
 */
@property (nonatomic, copy) NSString *authTokenSecret;

/**
 Creates a new request.
 @param url Url.
 @param parameters Query string parameters.
 @param requestMethod Request method (get, post, delete).
 */
- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(TWTSignedRequestMethod)requestMethod;

/**
 Perform the request, and notify handler of results.
 @param handler Completion handler that is called after the request is performed.
 */
- (void)performRequestWithHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler;

/**
 Consumer key.
 */
+ (NSString *)consumerKey;

/**
 Consumer secret.
 */
+ (NSString *)consumerSecret;

@end
