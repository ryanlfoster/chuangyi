//
//  Publisher.h
//  magzine2
//
//  Created by hongquan on 1/29/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NewsstandKit/NewsstandKit.h>
#import <StoreKit/StoreKit.h>

@interface Publisher : NSObject<SKRequestDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>
+ (Publisher *)sharedPublisher;
@property (nonatomic, strong) NSDictionary *feed;

@end
