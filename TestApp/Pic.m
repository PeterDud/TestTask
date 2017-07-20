//
//  Pic.m
//  TestApp
//
//  Created by Lavrin on 7/19/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "Pic.h"

@implementation Pic

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        
        NSDictionary *dicOfDics = [response objectForKey:@"images"];
        NSDictionary *dicOfImageInfo = [dicOfDics objectForKey:@"fixed_height_still"];
        NSURL *picURL = [NSURL URLWithString: [dicOfImageInfo objectForKey:@"url"]];
        
        NSString *source = [NSString stringWithFormat:@"Source: %@",[response objectForKey:@"source"]];
        NSString *picName = [NSString stringWithFormat:@"Picture Name: %@",
                                                    [response objectForKey:@"username"]];
        
        NSDictionary *userInfo = [response objectForKey:@"user"];
        NSURL *authorAvatarURL = [NSURL URLWithString: [userInfo objectForKey:@"avatar_url"]];
        NSString *authorUsername = [NSString stringWithFormat:@"Username: %@",
                                                    [userInfo objectForKey:@"username"]];
        
        self.picURL = picURL;
        
        if ([picName isEqualToString: @"Picture Name: "]) {
            self.picName = @"No info about picture name";
        } else {
            self.picName = picName;
        }
        
        if ([source isEqualToString:@"Source: "]) {
            self.source = @"No info about source";
        } else {
            self.source = source;
        }
        
        if (authorAvatarURL == nil) {
            self.authorAvatarURL = [NSURL URLWithString:@"https://beautycode.kz/sites/all/themes/savita/images/unknown-avatar.png"];
        } else {
            self.authorAvatarURL = authorAvatarURL;
        }
        
        if ([authorUsername isEqualToString:@"Username: (null)"]) {
            self.authorUsername = @"No info about author's username";
        } else {
            self.authorUsername = authorUsername;
        }
    }
    
    return self;
}












@end
