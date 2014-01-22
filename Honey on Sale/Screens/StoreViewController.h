//
//  MasterViewController.h
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutViewController.h"


@class DetailViewController;

@interface StoreViewController : CheckoutViewController< UITableViewDataSource, UITableViewDelegate>

@property(weak,nonatomic) IBOutlet UITableView *productsTable;

@end
