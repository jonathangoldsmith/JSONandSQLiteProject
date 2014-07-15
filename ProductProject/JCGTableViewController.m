//
//  JCGTableViewController.m
//  ProductProject
//
//  Created by Jonathan on 7/14/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import "JCGTableViewController.h"
#import "Product.h"
#import "JCGTableViewCell.h"
#import "JCGDetailViewController.h"

@interface JCGTableViewController ()

@property (nonatomic) NSMutableArray *productArray;
@property (nonatomic) int productRowClicked;

@end

@implementation JCGTableViewController

- (void)getProducts
{

        const char *dbpath = [_dBPath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT * FROM PRODUCTS"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(_contactDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                _productArray = [[NSMutableArray alloc] init];
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    Product *product = [[Product alloc]init];
                    NSString *productName = [[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                    product.productName = productName;
                    NSString *productPhoto = [[NSString alloc]
                                              initWithUTF8String:(const char *)
                                              sqlite3_column_text(statement, 5)];
                    product.productPhoto = [UIImage imageNamed:productPhoto];
                    NSLog(@"Match found");
                    [_productArray addObject:product];
                }
                sqlite3_finalize(statement);
                
            }
            sqlite3_close(_contactDB);
        }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProducts];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    Product *product = [[Product alloc] init];
    product = [self.productArray objectAtIndex:[indexPath row]];
    cell.productName.text = product.productName;
    cell.productImage.image = product.productPhoto;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.productRowClicked = [indexPath row];
    [self performSegueWithIdentifier:@"showProduct" sender:self];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showProduct"]){
        JCGDetailViewController *controller = (JCGDetailViewController *)segue.destinationViewController;
        controller.dBPath = _dBPath;
        controller.contactDB = _contactDB;
        Product *product = [[Product alloc] init];
        product = [self.productArray objectAtIndex:self.productRowClicked];
        controller.productName = product.productName;
    }
}


@end
