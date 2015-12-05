//
//  NGWCategoriesTableViewController.m
//  ios-workshops
//
//  Created by Adam Kędzia on 05.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWCategoriesTableViewController.h"
#import "NGWCategoryTableViewCell.h"

@interface NGWCategoriesTableViewController ()
@property (strong, nonatomic) id<NGWCategoriesDataProviderProtovol> categoriesProvider;
@property (strong, nonatomic) NSArray<NGWCategory *> *categoriesArray;
@end

@implementation NGWCategoriesTableViewController

- (instancetype)initWithCategriesProvider:(id<NGWCategoriesDataProviderProtovol>)categoriesProvider{
    self = [super init];
    if (self) {
        self.categoriesProvider = categoriesProvider;
        self.categoriesArray = @[];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NGWCategoryTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.categoriesProvider provideCategories:^(NSArray<NGWCategory *> *categories, NSError *error) {
        @synchronized(self) {
            self.categoriesArray = error ? @[] : categories;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    @synchronized(self) {
        return self.categoriesArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NGWCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.name.text = NSLocalizedString(@"All Categories", nil);
        return cell;
    }
    NGWCategory *category = [self.categoriesArray objectAtIndex:indexPath.row];
    cell.name.text = category.name;
    [self setImageForCell:cell withUrl:category.iconURL];
    return cell;
}

- (void)setImageForCell:(NGWCategoryTableViewCell *)cell withUrl:(NSURL *)photoURL {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:photoURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.categoryImageView setImage:[UIImage imageWithData:data]];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGWCategory *category = indexPath.section == 0 ? nil : [self.categoriesArray objectAtIndex:indexPath.row];
    [self.categoriesProvider setSelectedCategory:category];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
