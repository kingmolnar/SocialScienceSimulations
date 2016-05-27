import processing.opengl.*;

/* 
 Peter Molnar
 Social Impact Theory
 */

int[][] cell = null;
int M = 50;
int wdim = 400;
int looping = 0;

// transition function

float[][] prob = { 
  // Probability to switch to ONE if state is ZERO and N neighbors are ONE. N=0,1,2,3,4
  { 
     0.001, 0.1, 0.5, 0.9, 0.999     }
  ,
  // Probability to switch to ONE if state is ONE and N neighbors are ONE. N=0,1,2,3,4
  { 
     0.001, 0.1, 0.5, 0.9, 0.999     }
};

void setup() {
  int i, j;
  size(400, 400);
  colorMode(RGB, 255, 255, 255, 100); 
  frameRate(5);
  testProb();
  initValues();
  noLoop();
}

void initValues() {
  cell = new int[M][M];
  for (int i=0; i<M; i++) {
    for (int j=0; j<M; j++) {
      cell[i][j] = floor(random(1.0)+0.5);
    }
  }
}

int[][] offset = { { M-1, 0}, {M+1, 0}, {0, M-1}, {0, M+1} };
int countOnes(int i, int j) {
  int c = 0;
  for (int k=0; k<offset.length; k++) {
    c += cell[ (i+offset[k][0])%M ][ (j+offset[k][1])%M ];
  }
  return c;
}

int pOne(float p) {
  return random(1.0)<p ? 1 : 0;
}

void draw() {
  int a = wdim/M;
  int c;
  noStroke();
  for (int i=0; i<M; i++) {
    for (int j=0; j<M; j++) {
      c = countOnes(i, j);
      cell[i][j] = pOne(prob[ cell[i][j] ][c]);
      
      if (cell[i][j]>0) {
        fill(255, (4-c)*60, (4-c)*30);
      } 
      else {
        fill(c*30, c*60, 255);
      }
      rect(i*a, j*a, a, a);
    }
  }
  if (looping==0) noLoop();
}


void testProb() {
  int t = 0;
  if (prob.length==2 && prob[0].length==5 && prob[1].length==5) {
    t++;
  } 
  else {
    println("The dimensions of the 'prob' array are not 2x5!");
  }
}



void keyPressed() {
  initValues();
  looping = 0;
}

void mouseClicked() {
  looping = (looping+1)%2;
  if (looping>0) loop();
}