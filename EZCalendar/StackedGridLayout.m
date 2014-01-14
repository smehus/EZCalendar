//
//  StackedGridLayout.m
//  FlickrSearch
//
//  Created by Fahim Farook on 5/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "StackedGridLayout.h"
#import "StackedGridLayoutSection.h"

@interface StackedGridLayout () {
    __weak id<StackedGridLayoutDelegate> _myDelegate;
    NSMutableArray *_sectionData;
    CGFloat _height;
}

@end

@implementation StackedGridLayout

- (void)prepareLayout {
    // 1
    [super prepareLayout];
    
    self.headerHeight = 25.0f;
    

    // 2
    _myDelegate = (id <StackedGridLayoutDelegate>)self.collectionView.delegate;
    _sectionData = [NSMutableArray new];
    
    // HEIGHT EQUALS THE WIDTH INSTEAD
    // MOVES THE SCROLL VIEW HORIZONTAL
    
    _height = 0.0f;
    
    // 3
    CGPoint currentOrigin = CGPointZero;
    NSInteger numberOfSections =
	self.collectionView.numberOfSections;
    
    // 4
    for (NSInteger i = 0; i < numberOfSections; i++) {
        // 5
        //_height += self.headerHeight;
        currentOrigin.x = _height;
        
        // 6
        
        // SETTING THE NUMBER OF COLUMNS IN SECTION
        
        NSInteger numberOfColumns =
		[_myDelegate collectionView:self.collectionView
							 layout:self
		   numberOfColumnsInSection:i];
        
        // NUMBER OF ITEMS OBVI
        
        NSInteger numberOfItems =
		[self.collectionView numberOfItemsInSection:i];
        
        
        // CONFIGURING THE INSETS OF ITEMS
        
        UIEdgeInsets itemInsets =
		[_myDelegate collectionView:self.collectionView
							 layout:self
		itemInsetsForSectionAtIndex:i];
        
        // 7
        
        // MAKING THE SECTION
        
        StackedGridLayoutSection *section =
		[[StackedGridLayoutSection alloc]
		 initWithOrigin:currentOrigin
		 width:self.collectionView.bounds.size.width
		 columns:numberOfColumns
		 itemInsets:itemInsets];
        
        // 8
       
        for (NSInteger j = 0; j < numberOfItems; j++) {
            // 9
            CGFloat itemWidth = (section.columnWidth -
                                 section.itemInsets.left -
                                 section.itemInsets.right);
            NSIndexPath *itemIndexPath =
			[NSIndexPath indexPathForItem:j inSection:i];
            
            // SIZE OF THE CELL
            CGSize itemSize = CGSizeMake(105, 150);
            /*
			[_myDelegate collectionView:self.collectionView
								 layout:self
				   sizeForItemWithWidth:itemWidth
							atIndexPath:itemIndexPath];
             */
            
            // 10
            [section addItemOfSize:itemSize forIndex:j];
        }
         
         
        
        // 11
        [_sectionData addObject:section];
        
        // 12
        
        // ADDING ANOTHER SECTION
        
        _height += section.frame.size.width;
        currentOrigin.x = _height;
    }
}

//FIX SO THAT WHEN THERES MORE THAN 6 EVENTS IN A MONTH YOU CAN SCROLL VERTICALLY AS WELL.
//SET THE CONTENT SIZE BASED ON HOW MAN EVENTS IN A MONTH
//
//
//
//
//
//
//
//
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(_height,
                      self.collectionView.bounds.size.height - 75);
}

//
//
//
//
//
//
//

- (UICollectionViewLayoutAttributes*)
layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedGridLayoutSection *section =
	_sectionData[indexPath.section];
    
    UICollectionViewLayoutAttributes *attributes =
	[UICollectionViewLayoutAttributes
	 layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame =
	[section frameForItemAtIndex:indexPath.item];
    
    return attributes;
}


- (UICollectionViewLayoutAttributes *) layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
   StackedGridLayoutSection *section = _sectionData[indexPath.section];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                    layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGRect sectionFrame = section.frame;
    CGRect headerFrame = CGRectMake(sectionFrame.origin.x,
               sectionFrame.origin.y,
               sectionFrame.size.width,
            75);
    attributes.frame = headerFrame;
     
    return attributes;

}


- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1
    NSMutableArray *attributes = [NSMutableArray new];
    
    // 2
    [_sectionData enumerateObjectsUsingBlock:
	 ^(StackedGridLayoutSection *section,
	   NSUInteger sectionIndex,
	   BOOL *stop)
	 {
		 // 3
		 CGRect sectionFrame = section.frame;
		 CGRect headerFrame =
		 CGRectMake(sectionFrame.origin.x,
					sectionFrame.origin.y,
					sectionFrame.size.width,
					self.headerHeight);
		 
		 // 4
         
         
		 if (CGRectIntersectsRect(headerFrame, rect)) {
			 NSIndexPath *indexPath =
			 [NSIndexPath indexPathForItem:0
								 inSection:sectionIndex];
             
             
              
              //THIS CRASHES BECAUSE USING ECHEADERVIEW

             
			 UICollectionViewLayoutAttributes *la =
			 [self layoutAttributesForSupplementaryViewOfKind:
			  UICollectionElementKindSectionHeader atIndexPath:indexPath];
			 [attributes addObject:la];
             
   
		 }
		 
		 
		 if (CGRectIntersectsRect(sectionFrame, rect)) {
			 // 6
			 for (NSInteger index = 0;
				  index < section.numberOfItems;
				  index++)
			 {
				 // 7
				 CGRect frame =
				 [section frameForItemAtIndex:index];
				 
				 // 8
				 if (CGRectIntersectsRect(frame, rect)) {
					 NSIndexPath *indexPath =
					 [NSIndexPath indexPathForItem:index
										 inSection:sectionIndex];
					 UICollectionViewLayoutAttributes *la =
					 [self layoutAttributesForItemAtIndexPath:indexPath];
					 [attributes addObject:la];
				 }
			 }
		 }
	 }];
    
    // 9
    return attributes;
}

@end
