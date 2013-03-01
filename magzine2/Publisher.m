//
//  Publisher.m
//  magzine2
//
//  Created by hongquan on 1/29/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "Publisher.h"
#import "MagazineObject.h"
#import "ReceiptCheck.h"

@implementation Publisher

+ (Publisher *)sharedPublisher {
    static Publisher *sharedPublisher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPublisher = [[self alloc] init];
    });
    return sharedPublisher;
}

- (NSDictionary *)feed
{
    //[self subscripe];
    NSString *url = @"http://m9m10.com.cn:8080/magazines/gd/list.php";
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return @{};
    }
    NSDictionary *feed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return [NSDictionary dictionaryWithDictionary:feed];
}

- (void)subscripe
{
    NSString *productId = @"cn.m9m10.chuangyi.free";
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
    productsRequest.delegate=self;
    [productsRequest start];
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}

-(void)requestDidFinish:(SKRequest *)request
{
//    purchasing_=NO;
    NSLog(@"Request: %@",request);
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
//    purchasing_=NO;
    NSLog(@"Request %@ failed with error %@",request,error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
//    [alert release];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Request: %@ -- Response: %@",request,response);
    NSLog(@"Products: %@",response.products);
    for(SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        NSLog(@"Updated transaction %@",transaction);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [self errorWithTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing...");
                break;
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored:
                [self finishedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"Restored all completed transactions");
}

-(void)finishedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"Finished transaction");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscription done"
     message:[NSString stringWithFormat:@"Receipt to be sent: %@\nTransaction ID: %@",transaction.transactionReceipt,transaction.transactionIdentifier]
     delegate:nil
     cancelButtonTitle:@"Close"
     otherButtonTitles:nil];
     [alert show];
     //[alert release];
     
    // save receipt
    //[[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"receipt"];
    // check receipt
    [self checkReceipt:transaction.transactionReceipt];
}

-(void)errorWithTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscription failure"
                                                    message:[transaction.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
   // [alert release];
}

-(void)checkReceipt:(NSData *)receipt {
    // save receipt
    
//    NSString *receiptStorageFile = [DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"];
//    NSMutableArray *receiptStorage = [[NSMutableArray alloc] initWithContentsOfFile:receiptStorageFile];
//    if(!receiptStorage) {
//        receiptStorage = [[NSMutableArray alloc] init];
//    }
//    [receiptStorage addObject:receipt];
//    [receiptStorage writeToFile:receiptStorageFile atomically:YES];
//    [receiptStorage release];
    [ReceiptCheck validateReceiptWithData:receipt completionHandler:^(BOOL success,NSString *answer){
        if(success==YES) {
            NSLog(@"Receipt has been validated: %@",answer);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase OK" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
            //[alert release];
        } else {
            NSLog(@"Receipt not validated! Error: %@",answer);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error" message:@"Cannot validate receipt" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
            //[alert release];
        };
    }]; 
}

#pragma mark - Check all saved receipts

-(void)checkReceipts:(id)sender {
    // open receipts
    /*
    NSArray *receipts = [[[NSArray alloc] initWithContentsOfFile:[DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"]] autorelease];
    if(!receipts || [receipts count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No receipts" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    for(NSData *aReceipt in receipts) {
        [ReceiptCheck validateReceiptWithData:aReceipt completionHandler:^(BOOL success, NSString *message) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receipt validation"
                                                            message:[NSString stringWithFormat:@"Success:%d - Message:%@",success,message]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
         ];
    }*/
}



@end
