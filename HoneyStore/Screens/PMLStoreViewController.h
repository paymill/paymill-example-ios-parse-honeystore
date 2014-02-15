//
//  PMLStoreViewController.h
//  Honey Store
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMLCheckoutViewController.h"


@class DetailViewController;

@interface PMLStoreViewController : PMLCheckoutViewController< UITableViewDataSource, UITableViewDelegate>

@property(weak,nonatomic) IBOutlet UITableView *productsTable;

@end
