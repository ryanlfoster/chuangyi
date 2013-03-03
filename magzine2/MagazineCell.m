//
//  MagazineCell.m
//  magzine2
//
//  Created by hongquan on 1/26/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "MagazineCell.h"
#import <NewsstandKit/NewsstandKit.h>

@implementation MagazineCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.leftButton = [[UIButton alloc]init];
    self.rightButton = [[UIButton alloc]init];
    self.titleView = [[UIImageView alloc]init];
    self.textField = [[UITextField alloc]init];
    self.shelfView = [[UIImageView alloc]init];
    self.frameView = [[UIImageView alloc]init];
    self.glareView = [[UIImageView alloc]init];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.imageCover = [[FXImageView alloc]init];
    CGRect button_left_rect;
    CGRect button_right_rect;
    CGRect title_rect;
    CGRect text_rect;
    CGRect shelf_rect;
    CGRect frame_rect;
    CGRect glare_rect;
    CGRect progress_rect;
    
    UIImage *leftButtonImage = nil;
    UIImage *rightButtonImage = nil;
    UIImage *frameImage = nil;
    UIImage *glareImage = nil;
    UIImage *shelfImage = nil;
    UIImage *titleImage = nil;
    
    [self.imageCover setAsynchronous:YES];
    self.progressView = [[UIProgressView alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            button_left_rect = CGRectMake(23, 339, 80, 36);
            button_right_rect = CGRectMake(146, 339, 80, 36);
            title_rect = CGRectMake(24, 20, 161, 18);
            text_rect = CGRectMake(24, 40, 212, 18);
            frame_rect = CGRectMake(24, 59, 211, 270);
            glare_rect = CGRectMake(25, 72, 195, 255);
            progress_rect = CGRectMake(32, 191, 185, 13);
            
            leftButtonImage = [UIImage imageNamed:@"button-left-480.png"];
            rightButtonImage = [UIImage imageNamed:@"button-right-480.png"];
            frameImage = [UIImage imageNamed:@"frame-480.png"];
            glareImage = [UIImage imageNamed:@"glare-480.png"];
            shelfImage = [UIImage imageNamed:@"shelf-480.png"];
            titleImage = [UIImage imageNamed:@"title-480.png"];
        }
        if(result.height == 568)
        {
            button_left_rect = CGRectMake(31, 396, 93, 43);
            button_right_rect = CGRectMake(152, 396, 93, 43);
            title_rect = CGRectMake(32, 44, 161, 18);
            text_rect = CGRectMake(32, 65, 212, 18);
            frame_rect = CGRectMake(28, 87, 226, 288);
            glare_rect = CGRectMake(28, 101, 209, 273);
            progress_rect = CGRectMake(33, 230, 200, 13);
            
            leftButtonImage = [UIImage imageNamed:@"button-left-568.png"];
            rightButtonImage = [UIImage imageNamed:@"button-right-568.png"];
            frameImage = [UIImage imageNamed:@"frame-568.png"];
            glareImage = [UIImage imageNamed:@"glare-568.png"];
            shelfImage = [UIImage imageNamed:@"shelf-568.png"];
            titleImage = [UIImage imageNamed:@"title-568.png"];
        }
    }else{
        button_left_rect = CGRectMake(34, 410, 95, 43);
        button_right_rect = CGRectMake(209, 410, 95, 43);
        title_rect = CGRectMake(61, 34, 161, 18);
        text_rect = CGRectMake(61, 53, 212, 18);
        shelf_rect = CGRectMake(34, 353, 267, 55);
        frame_rect = CGRectMake(53, 68, 231, 295);
        glare_rect = CGRectMake(55, 81, 214, 279);
        progress_rect = CGRectMake(63, 206, 200, 13);
        
        leftButtonImage = [UIImage imageNamed:@"button-left-1024.png"];
        rightButtonImage = [UIImage imageNamed:@"button-right-1024.png"];
        frameImage = [UIImage imageNamed:@"frame-1024.png"];
        glareImage = [UIImage imageNamed:@"glare-1024.png"];
        shelfImage = [UIImage imageNamed:@"shelf-1024.png"];
        titleImage = [UIImage imageNamed:@"title-1024.png"];
        self.shelfView.frame = shelf_rect;
        self.shelfView.image = shelfImage;
        [self addSubview:self.shelfView];
    }
    self.leftButton.frame = button_left_rect;
    [self.leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [self.leftButton setTitle:@"下 载" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0];
    self.leftButton.titleLabel.textColor = [UIColor darkGrayColor];
    [self.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self addSubview:self.leftButton];
    
    self.rightButton.frame = button_right_rect;
    [self.rightButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0];
    [self.rightButton setTitle:@"删 除" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self addSubview:self.rightButton];
    
    self.titleView.frame = title_rect;
    self.titleView.image = titleImage;
    [self addSubview:self.titleView];
    
    self.textField.frame = text_rect;
    self.textField.textColor = [UIColor whiteColor];
    [self addSubview:self.textField];
    
    self.frameView.frame = frame_rect;
    self.frameView.image = frameImage;
    [self addSubview:self.frameView];
    
    self.imageCover.frame = glare_rect;
    [self addSubview:self.imageCover];
    
    self.glareView.frame = glare_rect;
    self.glareView.image = glareImage;
    self.glareView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.glareView addGestureRecognizer:tap];
    [self addSubview:self.glareView];
    
    self.progressView.frame = progress_rect;
    [self addSubview: self.progressView];
    
    self.indicator.frame = glare_rect;
    self.indicator.hidesWhenStopped = YES;
    [self addSubview:self.indicator];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)leftButtonClick:(id)sender
{
    NSLog(@"left %@",self.object);
    MagazineObject *magazine = self.object;
    NKIssue *issue = magazine.issue;
    if(issue.status == NKIssueContentStatusNone) {
        [magazine download];
        self.progressView.alpha = 1;
    }
}

- (void)rightButtonClick:(id)sender
{
    NSLog(@"right %@",self.object);
    MagazineObject *magazine = self.object;
    NKIssue *issue = magazine.issue;
    if (issue.status == NKIssueContentStatusAvailable) {
        [[NKLibrary sharedLibrary]removeIssue:issue];
    }
}

- (void)tap:(id)sender
{
    NSLog(@"tap %@",self.object);
    MagazineObject *magazine = self.object;
    NKIssue *issue = magazine.issue;
    if (issue.status == NKIssueContentStatusAvailable && !magazine.busy) {
        [self.rackViewController performSegueWithIdentifier:@"ReadSegue" sender:magazine];
    }
}


@end
