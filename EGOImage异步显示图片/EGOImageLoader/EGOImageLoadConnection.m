//
//  EGOImageLoadConnection.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 12/1/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOImageLoadConnection.h"
#import "ASIHTTPRequest.h"


@implementation EGOImageLoadConnection
@synthesize imageURL=_imageURL, response=_response, delegate=_delegate, timeoutInterval=_timeoutInterval;

#if __EGOIL_USE_BLOCKS
@synthesize handlers;
#endif

- (id)initWithImageURL:(NSURL*)aURL delegate:(id)delegate {
	if((self = [super init])) {
		_imageURL = [aURL retain];
		self.delegate = delegate;
		_responseData = [[NSMutableData alloc] init];
		self.timeoutInterval = 30;
		
		#if __EGOIL_USE_BLOCKS
		handlers = [[NSMutableDictionary alloc] init];
		#endif
	}
	
	return self;
}

- (void)start
{
    _connection = [[ASIHTTPRequest alloc] initWithURL:self.imageURL];
    _connection.timeOutSeconds = self.timeoutInterval;
    [_connection addRequestHeader:@"gzip" value:@"gzip"];
    _connection.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    _connection.delegate = self;
    [_connection startAsynchronous];
}

- (void)cancel
{
	[_connection clearDelegatesAndCancel];
}

- (NSData*)responseData
{
	return _responseData;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	if(request != _connection) return;
    [_responseData appendData:request.responseData];
	if([self.delegate respondsToSelector:@selector(imageLoadConnectionDidFinishLoading:)])
    {
		[self.delegate imageLoadConnectionDidFinishLoading:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if(request != _connection) return;

	if([self.delegate respondsToSelector:@selector(imageLoadConnection:didFailWithError:)])
    {
		[self.delegate imageLoadConnection:self didFailWithError:request.error];
	}
}


- (void)dealloc {
	self.response = nil;
	self.delegate = nil;
	
	#if __EGOIL_USE_BLOCKS
	[handlers release], handlers = nil;
	#endif

	[_connection release];
	[_imageURL release];
	[_responseData release];
	[super dealloc];
}

@end
