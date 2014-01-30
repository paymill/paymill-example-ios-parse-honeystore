//
//  Controller.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 13.01.14.
//  Copyright (c) 2014 г. Vladimir Marinov. All rights reserved.
//

#import "StoreController.h"
#import <Parse/Parse.h>
#import "Product.h"
#import <PayMillSDK/PMClient.h>
#import <PayMillSDK/PMSDK.h>

@interface StoreController()

@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSMutableArray *payments;

@end

@implementation StoreController


- (StoreController*)init{
	if(self = [super init]){
        // Init Parse Library
       
        _itemsInCard = [[NSMutableArray alloc] init];
        return self;
	}
	return nil;
}

StoreController *instance;

+ (StoreController*)getInstance{
	if(instance == nil){
		instance = [[StoreController alloc] init];
	}
	return instance;
}
- (NSArray*)getPayments{
    return self.payments;
}
- (NSArray*)getProducts{
    return self.products;
}
- (PMPayment*)parsePayment:(PFObject*)parseObject{
	
	PMPayment *result = [[PMPayment alloc] init];
	result.type = [parseObject objectForKey:@"type"];
    result.card_type = [parseObject objectForKey:@"card_type"];
    result.id = [parseObject objectForKey:@"id"];
    result.expire_month = [parseObject objectForKey:@"expire_month"];
    result.expire_year = [parseObject objectForKey:@"expire_year"];
    result.last4 = [parseObject objectForKey:@"last4"];
	return result;
	
}
/*get total in cents*/
- (int)getTotal{
    int result = 0;
    for (Product *product in self.itemsInCard) {
        result += product.amount;
    }
    return result;
}
#pragma mark- Get Items from Parse
- (void)getPaymentsWithComplte:(ControllerCompleteBlock)complete{
	
    if(self.payments == Nil){
        self.payments = [[NSMutableArray alloc] init];
    }
    [self.payments removeAllObjects];
    NSDictionary *parameters = @{@"paymillClientId": self.payMillClientId};
                                 
    [PFCloud callFunctionInBackground:@"getPayments" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    
                                    if(error == nil){
                                        NSArray *payments = (NSArray*)object;
                                        for (PFObject *obj in payments) {
                                            PMPayment* pmPayment = [self parsePayment:obj];
                                            [self.payments addObject:pmPayment];
                                        }

                                    }
                                    else {
                                        NSLog(@"Error %@", error.localizedDescription);
                                    }
                                  complete(error);
     } ];
 }
- (void)getItemsWithComplte:(ControllerCompleteBlock)complete{

	PFQuery *query = [PFQuery queryWithClassName:@"ItemForSale"];
    if(self.products == Nil){
        self.products = [[NSMutableArray alloc] init];
    }
    [self.products removeAllObjects];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		for (PFObject *obj in objects) {
            Product* product = [Product parse:obj];
            [self.products addObject:product];
        }
        complete(error);
	}];
}
#pragma mark-
- (void)clearCart{
    [self.itemsInCard removeAllObjects];
}
- (void)addProductToCartd:(Product*)product{
    [self.itemsInCard addObject:product];
}
#pragma mark-Payments
- (void)payWithClient:(NSString*)clientId
           cardNumber:(NSString*)cardNumber
           cardExpire: (NSString*)cardExpire
              cardCcv:(NSString*)cardVerification
              complte:(ControllerCompleteBlock)complete{
    
    NSDictionary *parameters = @{@"clientId": clientId,
                                 @"cardNumber": cardNumber,
                                 @"cardExpire": cardExpire,
                                 @"cardCcv": cardVerification,
                                 @"token":self.payMillPublicKey};
    [PFCloud callFunctionInBackground:@"createPaymentByExistingClient" withParameters:parameters
                                block:^(id object, NSError *error) {
        complete(error);
    } ];
    
}
- (void)payWithAccHolder:(NSString*)accHolder
                   email:(NSString*)email
              cardNumber:(NSString*)cardNumber
              cardExpire: (NSString*)cardExpire
                 cardCcv:(NSString*)cardVerification
                 complte:(ControllerCompleteBlock)complete{
    
    NSDictionary *parameters = @{@"accHolder": accHolder,
                                 @"email": email,
                                 @"cardNumber": cardNumber,
                                 @"cardExpire": cardExpire,
                                 @"cardCcv": cardVerification,
                                 @"token":self.payMillPublicKey};
    
    [PFCloud callFunctionInBackground:@"createPaymentByNewClient" withParameters:parameters
                                block:^(id object, NSError *error) {
                                    complete(error);
                                } ];
    
}
@end
