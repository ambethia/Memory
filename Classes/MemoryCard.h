//
//  MemoryCard.h
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "Card.h"

#define kMemoryCardWidth  64
#define kMemoryCardHeight 92

#define kNumMemoryCardPairs 8

@interface MemoryCard : Card {  
  
}
- (int) pairId;
@end
