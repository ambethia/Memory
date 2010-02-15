//
//  MemoryCard.m
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "MemoryCard.h"
#import "QuartzUtils.h"

@implementation MemoryCard

+ (void) initialize {
  if (self == [MemoryCard class]) {
    [self setCardSize:CGSizeMake(kMemoryCardWidth, kMemoryCardHeight)];
  }
}

+ (NSRange) serialNumberRange {
  return NSMakeRange(1,kNumMemoryCardPairs*2);
}

- (int) pairId {
  return [self serialNumber] % kNumMemoryCardPairs;
}

- (GGBLayer*) createBack {
  CGSize size = self.bounds.size;
  GGBLayer *back = [[GGBLayer alloc] init];
  [back setBounds:CGRectMake(0,0,size.width,size.height)];
  [back setPosition:CGPointMake(kMemoryCardWidth/2, kMemoryCardHeight/2)];
  [back setContents:(id)GetCGImageNamed(@"Images/MemoryCards/Back.png")];
  [back setDoubleSided:NO];
  return [back autorelease];
}

- (GGBLayer*) createFront {
  CGSize size = self.bounds.size;
  GGBLayer *back = [[GGBLayer alloc] init];
  [back setBounds:CGRectMake(0,0,size.width,size.height)];
  [back setPosition:CGPointMake(kMemoryCardWidth/2, kMemoryCardHeight/2)];
  [back setContents:(id)GetCGImageNamed([NSString stringWithFormat:@"Images/MemoryCards/%02d.png", [self pairId]])];
  [back setDoubleSided:NO];
  return [back autorelease];
}

@end
