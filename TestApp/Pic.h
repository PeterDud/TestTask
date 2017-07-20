//
//  Pic.h
//  TestApp
//
//  Created by Lavrin on 7/19/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pic : NSObject

@property (strong, nonatomic) NSURL *picURL;
@property (strong, nonatomic) NSString *picName;

@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSURL *authorAvatarURL;
@property (strong, nonatomic) NSString *authorUsername;


- (instancetype)initWithServerResponse:(NSDictionary *)response;

@end
