//
//  RackViewController.m
//  magzine2
//
//  Created by hongquan on 1/25/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "RackViewController.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "ZipArchive.h"
#import "MagazineCell.h"

@interface RackViewController ()

@end

@implementation RackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    [self arrangeCollectionView];
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dcoumentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* l_zipfile = [[NSBundle mainBundle]pathForResource:@"golf" ofType:@"zip"];

    NSString* unzipto = [dcoumentpath stringByAppendingString:@"/golf"] ;
    if( [zip UnzipOpenFile:l_zipfile] ) {
        BOOL ret = [zip UnzipFileTo:unzipto overWrite:YES];
        if( NO==ret ) { }
        [zip UnzipCloseFile];
    }  
	// Do any additional setup after loading the view.
}

- (void)arrangeCollectionView {
    PSUICollectionViewFlowLayout *flowLayout = (PSUICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    } else {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    }
    
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView reloadData];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self arrangeCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    [self performSegueWithIdentifier:@"ReadSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReadSegue"]) {
        NSLog(@"ReadSegue");
        RootViewController *rvc = segue.destinationViewController;
        NSDictionary *info = @{@"path":@"golf"};
        ModelController *model = [[ModelController alloc]initWithInfo:info];
        rvc.modelController = model;
    }
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MagazineCell" forIndexPath:indexPath];
    cell.imageCover.image = [UIImage imageNamed:@"FM.jpg"];
    // make the cell's title the actual NSIndexPath value
    //    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    //
    //    // load the image for this cell
    //    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    //    cell.image.image = [UIImage imageNamed:imageToLoad];
    //
    return cell;
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ReadSegue" sender:indexPath];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//{
//    return CGSizeMake(340, 600);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

@end
