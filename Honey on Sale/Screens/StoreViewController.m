//
//  MasterViewController.m
//  Honey on Sale
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. Vladimir Marinov. All rights reserved.
//

#import "StoreViewController.h"
#import "ProductDetailsViewController.h"
#import "StoreController.h"
#import "MBProgressHUD.h"
#import "ProductTableViewCell.h"
#import <PayMillSDK/PMSDK.h>
#import <Parse/PFUser.h>
#import <Parse/Parse.h>

@interface StoreViewController () {
   
}
@end

@implementation StoreViewController


- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	   // self.clearsSelectionOnViewWillAppear = NO;
	}
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
 	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self action:@selector(refreshObjects:)];
	self.navigationItem.leftBarButtonItem = refreshButton;

    self.productsTable.backgroundColor = [UIColor whiteColor];

    NSString *paymillClientId = [[PFUser currentUser] valueForKey:@"paymillClientId"];
    NSLog(@"%@", paymillClientId );
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([StoreController getInstance].Products == Nil){
        [self refreshObjects:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (void)refreshObjects:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[StoreController getInstance] getItemsWithComplte:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.productsTable reloadData];
    }];
}
- (void)orderProduct:(UIButton*)button{
	[self performSegueWithIdentifier:@"OrderProductSeque" sender:button];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProductTableViewCell rowHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [StoreController getInstance].Products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"productTableCell";
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
	Product *product = [StoreController getInstance].Products[indexPath.row];
    [cell configureProduct:product];
    
    [cell.orderButton addTarget:self action:@selector(orderProduct:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OrderProductSeque"]) {
		UIControl *senderControl = (UIControl*)sender;
		Product *product = [StoreController getInstance].Products[senderControl.tag];
 		ProductDetailsViewController *cvc = (ProductDetailsViewController *)[segue destinationViewController];
		[cvc setSelectedProduct: product];
    }
}

@end
