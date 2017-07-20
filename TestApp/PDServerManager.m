//
//  PDServerManager.m
//  TestApp
//
//  Created by Lavrin on 7/12/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDServerManager.h"
#import "AFNetworking.h"
#import "Pic.h"

@interface PDServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation PDServerManager

+ (PDServerManager *) sharedManager {
    
    static PDServerManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PDServerManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}

- (void) getPicsCount:(NSInteger) picsCount
           withOffset:(NSInteger) offset
        forSearchText:(NSString *) searchText
            OnSuccess:(void(^)(NSArray *pics)) success
            onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"3a6d3b0787f84ac08a532f29c60023d7", @"api_key",
                            searchText, @"q",
                            @(picsCount), @"limit",
                            @(offset), @"offset",
                            nil];
    
    [self.sessionManager GET:@"https://api.giphy.com/v1/gifs/search"
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         
                         NSMutableArray *pics = [NSMutableArray array];
                         
                         NSArray *dataArray = [responseObject objectForKey:@"data"];
                         
                         for (NSDictionary *response in dataArray) {
                             
                             Pic *pic = [[Pic alloc] initWithServerResponse:response];
                             
                             [pics addObject:pic];
                         }
                         if (success) {
                             success(pics);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"%@", [error localizedDescription]);
                     }];
}


@end
