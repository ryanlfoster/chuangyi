//
//  MagazineCell.h
//  magzine2
//
//  Created by hongquan on 1/26/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagazineCell : PSUICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelIssue;

@end
