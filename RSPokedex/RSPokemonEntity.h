//
//  RSPokemonEntity.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/26/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RSPokemonEntity : NSManagedObject
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, copy) NSNumber *weight;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *thumbnailUrl;
@end
