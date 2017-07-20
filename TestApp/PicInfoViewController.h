//
//  PicInfoViewController.h
//  TestApp
//
//  Created by Lavrin on 7/20/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pic.h"

@interface PicInfoViewController : UIViewController

@property (strong, nonatomic) Pic *pic;

@property (weak, nonatomic) IBOutlet UILabel *picNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImage;


@end
