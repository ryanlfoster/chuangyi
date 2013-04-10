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
#import "MagazineCell.h"
#import "Publisher.h"
#import "MagazineObject.h"
#import <NewsstandKit/NewsstandKit.h>
#import <UAPush.h>

@interface RackViewController ()

@property (nonatomic, strong) NSArray *entry;
@property (nonatomic, strong) NSURL *host;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end

@implementation RackViewController


- (IBAction)refresh:(id)sender {
    [self.indicator startAnimating];
    dispatch_queue_t queue = dispatch_queue_create("com.m9m10.chuangyi", 0);
    dispatch_async(queue, ^{
        NSDictionary *feed = [Publisher sharedPublisher].feed;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (feed) {
                [[NSUserDefaults standardUserDefaults]setObject:feed forKey:@"feed"];
                self.host = [NSURL URLWithString:[feed objectForKey:@"Host"]];
                NSMutableArray *magazines = [NSMutableArray array];
                for (NSDictionary *dict in [feed objectForKey:@"Entry"]) {
                    MagazineObject *magazine = [[MagazineObject alloc]initWithDictionary:dict andURL:self.host];
                    [magazines addObject:magazine];
                    if ([magazine.name isEqualToString:[Publisher sharedPublisher].content_available] && magazine.issue.status == NKIssueContentStatusNone) {
                        NSURL *imageURL = [self getCacheData:magazine.cover];
                        if ([imageURL isFileURL]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
                            [[UIApplication sharedApplication]setNewsstandIconImage:image];
                        }
                        [magazine download];
                        magazine.cell.progressView.hidden = NO;
                    }
                };
                self.entry = [NSArray arrayWithArray:magazines];
            }
            [self arrangeCollectionView];
            [self.indicator stopAnimating];
        });
    });
}

- (void)newIssue:(NSNotification *)info
{
    [self refresh:nil];
}

- (void)viewDidLoad
{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newIssue:) name:@"content-available" object:nil];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = self.view.bounds;
    self.indicator.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    [self.view addSubview:self.indicator];
    [self.view bringSubviewToFront:self.collectionView];
    self.indicator.hidesWhenStopped = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    NSDictionary *feed = [[NSUserDefaults standardUserDefaults]objectForKey:@"feed"];
    NSLog(@"%@",feed);
    self.host = [NSURL URLWithString:[feed objectForKey:@"Host"]];
    NSMutableArray *magazines = [NSMutableArray array];
    for (NSDictionary *dict in [feed objectForKey:@"Entry"]) {
        MagazineObject *magazine = [[MagazineObject alloc]initWithDictionary:dict andURL:self.host];
        [magazines addObject:magazine];
    };
    self.entry = [NSArray arrayWithArray:magazines];
    [self arrangeCollectionView];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh:self.refreshButton];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReadSegue"]) {
        NSLog(@"ReadSegue");
        RootViewController *rvc = segue.destinationViewController;
        MagazineObject *magezine = sender;
        ModelController *model = [[ModelController alloc]initWithMagazine:magezine];
        rvc.modelController = model;
        rvc.title = magezine.title;
    }
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entry.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MagazineCell" forIndexPath:indexPath];
    cell.rackViewController = self;
    MagazineObject *magazine = [self.entry objectAtIndex:indexPath.row];
    [collectionView bringSubviewToFront:cell];
    cell.object = magazine;
    magazine.cell = cell;
    NSURL *imageURL = [self getCacheData:magazine.cover];
    if ([imageURL isFileURL]) {
        [cell.imageCover setImageWithContentsOfFile:imageURL.path];
    }else{
        [cell.imageCover setImageWithContentsOfURL:imageURL];
    }
    cell.textField.text = magazine.title;
    if (magazine.issue.status == NKIssueContentStatusNone) {
        cell.progressView.hidden = YES;
    }else if(magazine.issue.status == NKIssueContentStatusDownloading){
        cell.progressView.hidden = NO;
        cell.progressView.progress = magazine.progress;
    }else if (magazine.issue.status == NKIssueContentStatusAvailable){
        cell.progressView.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            size = CGSizeMake(260, 392);
        }
        if(result.height == 568)
        {
            size = CGSizeMake(284, 480);
        }
    }else{
        size = CGSizeMake(340, 467);
    }
    return size;
}

- (IBAction)trash:(id)sender {
    UIButton *button = sender;
    MagazineCell *cell = (MagazineCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"trash %@",indexPath);
    MagazineObject *magazine = [self.entry objectAtIndex:indexPath.row];
    [magazine trash];
}


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

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (NSURL *)getCacheData: (NSURL *)URL
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSString *filePath = URL.path.pathComponents.lastObject;
    myPath = [myPath stringByAppendingPathComponent:filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        NSLog(@"get %@",myPath);
        return [NSURL fileURLWithPath:myPath];
    }else{
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                NSLog(@"writeToFile %@",myPath);
                [data writeToFile:myPath atomically:YES];
            }else{
                NSLog(@"image error");
            }
        }];
    }
    return URL;
}
- (IBAction)copyright:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.imoshan.com"]];
}
- (IBAction)develope:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"(+86)186-2136-2156" message:@"移动杂志开发外包" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"接通贵宾专线", nil];
    [alert show];
}

- (IBAction)subscribe:(id)sender {
    [[Publisher sharedPublisher]subscribe];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://+8618621562136"]];
            break;
        default:
            break;
    }
}

@end
