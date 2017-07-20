//
//  ViewController.m
//  TestApp
//
//  Created by Lavrin on 7/12/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import "Pic.h"
#import "PDServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "PicInfoViewController.h"
#import "MoreCollectionViewCell.h"

@interface ViewController () 

@property (strong, nonatomic) NSMutableArray *pics;
@property (strong, nonatomic) NSMutableArray *indexPaths;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController

static NSInteger picsInRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.searchTextField becomeFirstResponder];
    
    self.title = @"Pictures from giphy.com";
    
    self.pics = [NSMutableArray array];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refresh];
    self.collectionView.alwaysBounceVertical = YES;

    self.refreshControl = refresh;

}

- (void) refreshWall {
    
    [[PDServerManager sharedManager]
     getPicsCount: MAX(picsInRequest, [self.pics count])
     withOffset: 0
     forSearchText: self.searchTextField.text
     OnSuccess:^(NSArray *pics) {
         
         [self.pics removeAllObjects];
         [self.pics addObjectsFromArray: pics];
         [self.collectionView reloadData];
         [self.refreshControl endRefreshing];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         [self.refreshControl endRefreshing];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void) getPicsFromServer {
    
    [[PDServerManager sharedManager]
     getPicsCount: picsInRequest
     withOffset: [self.pics count]
     forSearchText: self.searchTextField.text
     OnSuccess:^(NSArray *pics) {
         
         [self.pics addObjectsFromArray: pics];
         
         self.indexPaths = [NSMutableArray array];
         
         for (int i = (int)[self.pics count] - (int)[pics count]; i < [self.pics count]; i++) {

             [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.collectionView insertItemsAtIndexPaths:self.indexPaths];

         if ([self.pics count] == picsInRequest) {
             
             NSIndexPath *path = [NSIndexPath indexPathForRow:[self.pics count] inSection:0];
             NSArray *indexPaths = @[path];
             [self.collectionView reloadItemsAtIndexPaths:indexPaths];
         }
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.pics count] + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.pics count]) {
        
        NSString *identifier = @"LoadMoreCell";
    
        MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                               forIndexPath:indexPath];
        if ([self.pics count] > 0) {
            cell.moreLabel.text = @"Load More";
            cell.backgroundColor = [UIColor yellowColor];
        } else {
            cell.moreLabel.text = @"";
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    } else {
    
    NSString *identifier = @"Cell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                              forIndexPath:indexPath];
    Pic *pic = [self.pics objectAtIndex: indexPath.row];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:pic.picURL];
    
    cell.picView.image = nil;
    
    __weak ImageCollectionViewCell *weakCell = cell;
    
    [cell.picView
     setImageWithURLRequest:imageRequest
     placeholderImage:nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
         
         weakCell.picView.image = image;
         [weakCell layoutSubviews];
         
     }
     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.pics count]) {
        
        [self performSelectorInBackground:@selector(getPicsFromServer) withObject:nil];

    } else {
    
    Pic *pic = [self.pics objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PicInfoViewController *picInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"PicInfoViewController"];
    [picInfoVC loadView];
    picInfoVC.picNameLabel.text = pic.picName;
    picInfoVC.authorNameLabel.text = pic.authorUsername;
    picInfoVC.sourceLabel.text = pic.source;
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:pic.authorAvatarURL];
    
    picInfoVC.authorAvatarImage.image = nil;
    
    __weak PicInfoViewController *weakVC = picInfoVC;
    
    [picInfoVC.authorAvatarImage
     setImageWithURLRequest:imageRequest
     placeholderImage:nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
         
         weakVC.authorAvatarImage.image = image;
         
     }
     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];

    [self.navigationController pushViewController:picInfoVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self.pics count] > 0) {
        
        [self.pics removeAllObjects];
        [self.collectionView reloadData];
    }
    
    [self performSelectorInBackground:@selector(getPicsFromServer) withObject:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
