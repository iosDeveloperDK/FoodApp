//
//  ViewController.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "ViewController.h"
#import "DKDataManager.h"
#import "DKParser.h"
#import "DKCategoryTableViewCell.h"
#import "DKOffersViewController.h"
#import "SWRevealViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

{
    NSArray* arrayCategory;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *activityView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    self.title = @"Категории";
    
    NSURL *url = [NSURL URLWithString:@"http://ufa.farfor.ru/getyml/?key=ukAXxeJYZN"];
    
    [self startParseURL:url];
    

}

-(void)startParseURL:(NSURL*)url {

    DKDataManager* manager = [DKDataManager sharedManager];
    
    if (!manager.isParse) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [manager createXMLParserWhithURL:url];
            
            arrayCategory = [manager arrayData];
                        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.activityView.hidden = YES;
                
                [self.tableView reloadData];
                
            });
            
            
        });
        
    }else {
        
        self.activityView.hidden = YES;

        arrayCategory = manager.arrayData;
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayCategory.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* indetifier = @"DKCategoryTableViewCell";
    
    tableView.rowHeight = 100.f;
    
    DKCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    
    DKCategory* category = [arrayCategory objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = category.categoryTitle;
    
    //Проверка из-за странного бага, когда используешь имя картинки "Патимейкер" она не в какую не открывается(в независимости от расширения файла)
    
    if ([category.categoryTitle isEqualToString:@"Патимейкер"]) {
        
        cell.mainImageView.image = [UIImage imageNamed:@"Сеты"];
        
    }else {
    
        cell.mainImageView.image = [UIImage imageNamed:category.categoryTitle];
    
    }
    
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"fromVCtoOffer"]) {
        
        DKOffersViewController* vc = segue.destinationViewController;
        
        vc.arrayOffers = [[arrayCategory objectAtIndex:[[self.tableView indexPathForSelectedRow] row]] arrayOffers];
        
        vc.title = [[arrayCategory objectAtIndex:[[self.tableView indexPathForSelectedRow] row]] categoryTitle];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
