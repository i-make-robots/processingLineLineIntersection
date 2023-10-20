class LineSegment {
  float x0,y0,x1,y1;
  
  public LineSegment(float x0,float y0,float x1,float y1) {
    this.x0=x0;
    this.y0=y0;
    this.x1=x1;
    this.y1=y1;
  }
  
  float [] getUnit() {
    float dx=x1-x0;
    float dy=y1-y0;
    float len = sqrt(dx*dx + dy*dy);
    dx/=len;
    dy/=len;
    return new float[]{dx,dy};
  }
  
  void draw() {
    line(x0,y0,x1,y1);
  }
}

class Line {
  ArrayList<LineSegment> segments = new ArrayList<LineSegment>();
  void draw() {
    for(LineSegment s : segments) {
      s.draw();
    }
  }
}

Line myLine = new Line();

void setup() {
  size(300,300);
  //randomTest();
}

float theta=0;

void exactTest() {
  translate(20,90);
  myLine.segments.clear();
  float s = sin(radians(theta));
  float c = cos(radians(theta));
  theta+=0.030 * 10;
  
  float x0 = 150 + c * 50;
  float y0 = 50 + s * 50;
  float x1 = 150 + c * 100;
  float y1 = 50 + s * 100;
   
  myLine.segments.add(new LineSegment(50,50,100,50));
  myLine.segments.add(new LineSegment(100,50,x0,y0));
  myLine.segments.add(new LineSegment(x0,y0,x1,y1));
}

void randomTest() {
  float x0=(width/2);
  float y0=(height/2);
  
  float x1=x0+random(-50,50);
  float y1=y0+random(-50,50);
  
  for(int i=0;i<3;++i) {
    myLine.segments.add(new LineSegment(x0,y0,x1,y1));
    x0=x1;
    y0=y1;
    
    x1=x0+random(-50,50);
    y1=y0+random(-50,50);
  }
}

void draw() {
  exactTest();
  background(255);
  
  stroke(255,0,0);
  myLine.draw();
  
  try {
    float [] p = findIntersection(
      myLine.segments.get(0),
      myLine.segments.get(2));
      
    stroke(0,0,255);
    fill(0,0,255);
    circle(p[0],p[1],5f);
  } catch(Exception ignored) {}
}

float dotProduct(float[] a,float[] b) {
  return (a[0]*b[0] + a[1]*b[1]);
}


float [] findIntersection(LineSegment a,LineSegment b) {
  return findIntersection(
    a.x0,a.y0,a.x1,a.y1,
    b.x0,b.y0,b.x1,b.y1);
}

/*
public float[] findIntersection(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
    float a1 = y1 - y0;
    float b1 = x0 - x1;
    float c1 = a1 * x0 + b1 * y0;

    float a2 = y3 - y2;
    float b2 = x2 - x3;
    float c2 = a2 * x2 + b2 * y2;

    float determinant = a1 * b2 - a2 * b1;

    if (determinant == 0) {
        throw new IllegalArgumentException("The lines are parallel and do not intersect.");
    } else {
        float x = (b2 * c1 - b1 * c2) / determinant;
        float y = (a1 * c2 - a2 * c1) / determinant;
        return new float[]{x, y};
    }
}*/


public float [] findIntersection(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4) {
    float d = ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    if(Math.abs(d)<0.01) {
        // lines are colinear (infinite solutions) or parallel (no solutions).
        float ix = (x4+x1)/2;
        float iy = (y4+y1)/2;
        return new float [] { ix, iy };
    }

    float t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / d;
    //float u = ((x1-x2)*(y1-y3) - (y1-y2)*(x1-x3)) / d;

    float ix = x1+t*(x2-x1);
    float iy = y1+t*(y2-y1);
    return new float[] { ix, iy };
}
