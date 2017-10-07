//
//  RSPokeTableViewCell.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSPokeTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameVal;
@property (nonatomic, weak) IBOutlet UILabel *idVal;
@property (nonatomic, weak) IBOutlet UILabel *heightVal;
@property (nonatomic, weak) IBOutlet UILabel *weightVal;
@property (nonatomic, weak) IBOutlet UILabel *typeVal;
@property (nonatomic, weak) IBOutlet UILabel *habitatVal;
@property (nonatomic, weak) IBOutlet UIImageView *spriteImg;

@end
