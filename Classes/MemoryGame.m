//
//  MemoryGame.m
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "MemoryGame.h"
#import "MemoryCard.h"

@implementation MemoryGame

#pragma mark Initialization

- (id) init {
  self = [super init];
  if (self != nil)
    [self setNumberOfPlayers: 1];
  return self;
}

- (void) setUpBoard {
  [_tableau release];
  _tableau = [[MemoryTableau alloc] init];
  [_tableau addAllCells];
  [_table addSublayer: _tableau];
  [_tableau release];
  
  // Initialize a stack of cards
  NSRange serials = [MemoryCard serialNumberRange];
  NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:serials.length];
  for (int i=serials.location; i < NSMaxRange(serials); i++) {
    MemoryCard* card = [[MemoryCard alloc] initWithSerialNumber:i
                                                       position:CGPointZero];
    [cards addObject: card];
    [card release];
  }
  
  // Shuffle them
  int n = 0;
  for (int i = 0; i < [cards count]; i++) {
    int r = random() % [cards count];
    [cards exchangeObjectAtIndex:n withObjectAtIndex:r];
    n++;
  }
  
  // Lay them out on the table
  for (int i = 0; i < [[_tableau cells] count]; i++) {
    [[[_tableau cells] objectAtIndex:i] setBit:[cards objectAtIndex:i]];
  }
}

#pragma mark Game Functions

- (void) pickCard:(MemoryCard*) card {
  if (![card faceUp]) {
    [card setFaceUp:YES];
  } else {
    return;
  }
  if ([[_tableau shownCards] count] == 2) {
    if (![_tableau checkMatchedPairs]) {
      [_tableau performSelector:@selector(resetCards)
                     withObject:nil
                     afterDelay:1.0];
    }
    [self endTurn];
  }
}

- (Player*) checkForWinner {
  if ([_tableau removedPairs] == kNumMemoryCardPairs) {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:@"Yay!" 
                             otherButtonTitles:nil];
    [alert show];
    [alert release];
    return [self currentPlayer];    
  }
  return nil;
}

#pragma mark Click Handling

// A callback I've added to BoardUIView
- (BOOL) clickedUndraggableBit: (Bit*)bit{
  if ([bit isKindOfClass: [MemoryCard class]]) {
    [self pickCard:(MemoryCard*)bit];
  }
  return YES;
}

#pragma mark State String

- (NSString*)stateString {
  return @"";
}

- (void)setStateString:(NSString*)s {
}

- (BOOL)applyMoveString:(NSString*)move {
  return NO;
}

@end
