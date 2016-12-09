//
//  DKOfferCollectionViewCell.h
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKOfferCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@end
