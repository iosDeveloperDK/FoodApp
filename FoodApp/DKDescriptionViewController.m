//
//  DKDescriptionViewController.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "DKDescriptionViewController.h"
#import "DKParser.h"
#import "UIImageView+AFNetworking.h"

@interface DKDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITextView *labelDesc;

@end

@implementation DKDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = self.offer.offerName;
    
    self.labelPrice.text = [NSString stringWithFormat:@"Цена: %@", self.offer.offerPrice];
    
    self.labelWeight.text = [NSString stringWithFormat:@"Вес: %@", self.offer.offerWeight];
    
    self.labelDesc.text = [NSString stringWithFormat:@"Описание: %@", self.offer.offerDescription];

    [self.imageView setImageWithURL:self.offer.offerPicture placeholderImage:[UIImage imageNamed:@"default-placeholder"]];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
