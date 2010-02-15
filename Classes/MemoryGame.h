//
//  MemoryGame.h
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "Game+Protected.h"
#import "MemoryTableau.h"
#import "MemoryCard.h"

@interface MemoryGame : Game {
  MemoryTableau *_tableau;
}
- (BOOL) clickedUndraggableBit:(Bit*) bit;
- (void) pickCard:(MemoryCard*) card;
@end
