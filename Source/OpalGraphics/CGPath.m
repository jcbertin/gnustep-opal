/** <title>CGPath</title>
 
 <abstract>C Interface to graphics drawing library</abstract>
 
 Copyright <copy>(C) 2010 Free Software Foundation, Inc.</copy>

 Author: Eric Wasylishen
 Date: June 2010
  
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import <Foundation/NSObject.h>
#include "CoreGraphics/CGPath.h"

#import "OPPath.h"


CGPathRef CGPathCreateCopy(CGPathRef path)
{
  return [path copy];
}

CGMutablePathRef CGPathCreateMutable()
{
  return [[CGMutablePath alloc] init];
}

CGMutablePathRef CGPathCreateMutableCopy(CGPathRef path)
{
  return [[CGMutablePath alloc] initWithCGPath: path];
}

CGPathRef CGPathRetain(CGPathRef path)
{
  return [path retain];
}

void CGPathRelease(CGPathRef path)
{
  [path release];
}

bool CGPathIsEmpty(CGPathRef path)
{
  return [path count] == 0;
}

bool CGPathEqualToPath(CGPathRef path1, CGPathRef path2)
{
  return [path1 isEqual: path2];
}

bool CGPathIsRect(CGPathRef path, CGRect *rect)
{
  return [path isRect: rect];
}

CGRect CGPathGetBoundingBox(CGPathRef path)
{
  NSUInteger count = [path count];
  CGFloat minX = 0.0;
  CGFloat minY = 0.0;
  CGFloat maxX = 0.0;
  CGFloat maxY = 0.0;
  
  for (NSUInteger i=0; i<count; i++)
  {
    CGPoint points[3];
    CGPathElementType type =[path elementTypeAtIndex: i points: points];

    NSUInteger numPoints;
    switch (type)
    {
      case kCGPathElementMoveToPoint:
        numPoints = 1;
        break;
      case kCGPathElementAddLineToPoint:
        numPoints = 1;
        break;
      case kCGPathElementAddQuadCurveToPoint:
        numPoints = 2;
        break;
      case kCGPathElementAddCurveToPoint:
        numPoints = 3;
        break;
      case kCGPathElementCloseSubpath:
      default:
        numPoints = 0;
        break;
    }
    
    for (NSUInteger p=0; p<numPoints; p++)
    {
      if (points[p].x < minX)
      {
        minX = points[p].x;
      }
      else if (points[p].x > maxX)
      {
        maxX = points[p].x;
      }
      else if (points[p].y < minY)
      {
        minY = points[p].y;
      }
      else if (points[p].y > maxY)
      {
        maxY = points[p].y;
      }
    }
  }
  
  return CGRectMake(minX, minY, (maxX-minX), (maxY-minY));
}

CGPoint CGPathGetCurrentPoint(CGPathRef path)
{
  if (CGPathIsEmpty(path))
  {
    return CGPointZero;
  }
  
  NSUInteger count = [path count];
  // FIXME: ugly loop
  for (NSUInteger i=(count-1); i>=0 && i<count; i--)
  {
    CGPoint points[3];
    CGPathElementType type =[path elementTypeAtIndex: i points: points];
    
    switch (type)
    {
      case kCGPathElementMoveToPoint:
      case kCGPathElementAddLineToPoint:
        return points[0];
      case kCGPathElementAddQuadCurveToPoint:
        return points[1];
      case kCGPathElementAddCurveToPoint:
        return points[2];
      case kCGPathElementCloseSubpath:
      default:
        break;
    }    
  }
  return CGPointZero;
}

bool CGPathContainsPoint(
  CGPathRef path, 
  const CGAffineTransform *m, 
  CGPoint point, 
  int eoFill)
{
  // FIXME: use cairo function 
  return false;
}

void CGPathAddArc(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat x,
  CGFloat y,
  CGFloat r,
  CGFloat startAngle,
  CGFloat endAngle,
  int clockwise)
{
  // FIXME:
}

void CGPathAddArcToPoint(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat x1,
  CGFloat y1,
  CGFloat x2,
  CGFloat y2,
  CGFloat r)
{
  // FIXME:
}

void CGPathAddCurveToPoint(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat cx1,
  CGFloat cy1,
  CGFloat cx2,
  CGFloat cy2,
  CGFloat x,
  CGFloat y)
{
  // FIXME:
}

void CGPathAddLines(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  const CGPoint points[],
  size_t count)
{
  CGPathMoveToPoint(path, m, points[0].x, points[0].y);
  for (NSUInteger i=1; i<count; i++)
  {
    CGPathAddLineToPoint(path, m, points[i].x, points[i].y);
  }
}

void CGPathAddLineToPoint (
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat x,
  CGFloat y)
{
  CGPoint point = CGPointMake(x, y);
  if (m)
  {
    point = CGPointApplyAffineTransform(point, *m);
  }
  [(CGMutablePath*)path addElementWithType: kCGPathElementAddLineToPoint
                                    points: &point];
}

void CGPathAddPath(
  CGMutablePathRef path1,
  const CGAffineTransform *m,
  CGPathRef path2)
{
  NSUInteger count = [path2 count];
  for (NSUInteger i=0; i<count; i++)
  {
    CGPoint points[3];
    CGPathElementType type = [path2 elementTypeAtIndex: i points: points];
    if (m)
    {
      for (NSUInteger j=0; j<3; j++)
      {
        // FIXME: transforms unused points
        points[j] = CGPointApplyAffineTransform(points[j], *m);
      }
    }
    [(CGMutablePath*)path1 addElementWithType: type points: points];
  }
}

void CGPathAddQuadCurveToPoint(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat cx,
  CGFloat cy,
  CGFloat x,
  CGFloat y)
{
  CGPoint points[2] = {
    CGPointMake(cx, cy),
    CGPointMake(x, y)

  };
  if (m)
  {
    points[0] = CGPointApplyAffineTransform(points[0], *m);
    points[1] = CGPointApplyAffineTransform(points[1], *m);
  }
  [(CGMutablePath*)path addElementWithType: kCGPathElementAddQuadCurveToPoint
                                    points: points];
}

void CGPathAddRect(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGRect rect)
{
  CGPathMoveToPoint(path, m, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, m, CGRectGetMaxX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, m, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  CGPathAddLineToPoint(path, m, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGPathCloseSubpath(path);
}

void CGPathAddRects(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  const CGRect rects[],
  size_t count)
{
  for (NSUInteger i=0; i<count; i++)
  {
    CGPathAddRect(path, m, rects[i]);
  }
}

void CGPathApply(
  CGPathRef path,
  void *info,
  CGPathApplierFunction function)
{
  NSUInteger count = [path count];
  for (NSUInteger i=0; i<count; i++)
  {
    CGPoint points[3];
    CGPathElement e;
    e.type = [path elementTypeAtIndex: i points: points];
    e.points = points;
    function(info, &e); 
  }
}

void CGPathMoveToPoint(
  CGMutablePathRef path,
  const CGAffineTransform *m,
  CGFloat x,
  CGFloat y)
{
  CGPoint point = CGPointMake(x, y);
  if (m)
  {
    point = CGPointApplyAffineTransform(point, *m);
  }
  [(CGMutablePath*)path addElementWithType: kCGPathElementMoveToPoint
                                    points: &point];
}

void CGPathCloseSubpath(CGMutablePathRef path)
{
  [(CGMutablePath*)path addElementWithType: kCGPathElementCloseSubpath
                                    points: NULL];
}

void CGPathAddEllipseInRect(
  CGMutablePathRef path, 
  const CGAffineTransform *m, 
  CGRect rect)
{
  // FIXME:
}