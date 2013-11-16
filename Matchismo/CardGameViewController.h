//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 11/2/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//
// Abstract class. Must implement methods as describeed below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController


// protected
// for subclasses
- (Deck *)createDeck;   //abstract
- (NSUInteger)numberOfMatches; //abstract
- (NSString *)gameName; //abstract

- (void)updateCardButton:(UIButton *)cardButton usingCard:(Card *)card;//abstract
- (NSAttributedString *)textForSingleCard:(Card *)card; //abstract
- (NSAttributedString *)attributedCardsDescription:(NSArray *)cards; //abstract
@end
