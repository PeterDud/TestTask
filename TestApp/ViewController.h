//
//  ViewController.h
//  TestApp
//
//  Created by Lavrin on 7/12/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@end

