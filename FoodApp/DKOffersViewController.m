//
//  DKOffersViewController.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "DKOffersViewController.h"
#import "DKOfferCollectionViewCell.h"
#import "DKParser.h"
#import "UIImageView+AFNetworking.h"
#import "DKDescriptionViewController.h"

@interface DKOffersViewController () < UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DKOffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        // Do any additional setup after loading the view.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrayOffers.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DKOfferCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DKOfferCollectionViewCell" forIndexPath:indexPath];

    DKOffer* offer = [self.arrayOffers objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = offer.offerName;
    
    cell.labelPrice.text = [NSString stringWithFormat:@"Цена: %@", offer.offerPrice];
    
    cell.labelWeight.text = [NSString stringWithFormat:@"Вес: %@", offer.offerWeight];

    __weak DKOfferCollectionViewCell *weakCell = cell;
    
    [weakCell.mainImageView setImageWithURLRequest:[NSURLRequest requestWithURL:offer.offerPicture]  placeholderImage:[UIImage imageNamed:@"default-placeholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
         
         weakCell.mainImageView.image = image;
        
         [weakCell layoutSubviews];
     }
     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
         
     }];

    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    cell.layer.borderWidth = 1.f;
    
    
    return cell;
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return CGSizeMake(160, 160);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    DKDescriptionViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DKDescriptionViewController"];
    
    DKOffer* offer = [self.arrayOffers objectAtIndex:indexPath.row];
    
    vc.offer = offer;
    
    vc.title = offer.offerName;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
