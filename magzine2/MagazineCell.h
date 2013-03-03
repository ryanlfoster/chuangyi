//
//  MagazineCell.h
//  magzine2
//
//  Created by hongquan on 1/26/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXImageView.h"
#import "MagazineObject.h"
#import "RackViewController.h"

@class MagazineObject;

@interface MagazineCell : PSUICollectionViewCell
@property (strong, nonatomic) FXImageView *imageCover;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIImageView *titleView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIImageView *shelfView;
@property (strong, nonatomic) UIImageView *frameView;
@property (strong, nonatomic) UIImageView *glareView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) MagazineObject *object;
@property (strong, nonatomic) RackViewController *rackViewController;
@end
