//
//  Drink+CoreDataProperties.m
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Drink+CoreDataProperties.h"

@implementation Drink (CoreDataProperties)

+ (NSString *) entityName
{
    return @"Drink";
}

+ (NSArray *)allDrinks:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:[Drink entityName]
                                   inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    return [moc executeFetchRequest:fetchRequest error:nil];
}

@end
