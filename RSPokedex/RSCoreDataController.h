//
//  RSCoreDataController.h
//  RSPokedex
//
//  Created by RADHIKA SHARMA on 9/8/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSPokemonEntity;

@interface RSCoreDataController : NSObject

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

+(RSCoreDataController *)sharedController;
- (void)saveContext;

-(RSPokemonEntity *)fetchEntityWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;
-(NSArray<RSPokemonEntity *> *)fetchAllEntitiesWithContext:(NSManagedObjectContext *)context;

-(BOOL)updateEntityWithName:(NSString *)name withAttributes:(NSDictionary *)atribs;

@end
