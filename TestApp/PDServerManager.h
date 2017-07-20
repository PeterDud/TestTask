//
//  PDServerManager.h
//  TestApp
//
//  Created by Lavrin on 7/12/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDServerManager : NSObject

+ (PDServerManager *) sharedManager;

- (void) getPicsCount:(NSInteger) picsCount
           withOffset:(NSInteger) offset
        forSearchText:(NSString *) searchText
            OnSuccess:(void(^)(NSArray *pics)) success
            onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
