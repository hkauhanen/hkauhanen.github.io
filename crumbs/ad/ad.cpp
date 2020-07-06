/* ad.cpp / Henri Kauhanen 2018
 *
 * Adaptive dispersion via stochastic hill climbing.
 *
 * To compile:
 * g++ -std=c++11 ad.cpp -o ad
 *
 * Usage:
 * ./ad -n <vowels> -i <iterations> -o <outfile> [-l <logfile>] [-m <movement>]
 *
 * Original idea:
 * Liljencrants, J. & Lindblom, B. (1972) Numerical simulation of vowel
 * quality systems: the role of perceptual contrast. Language, 48(4):839-862.
 *
 */


#include <iostream>
#include <fstream>
#include <unistd.h>
#include <cmath>
#include <random>
#include <string>


// contour formula
double contour(double M1value, double M1lim[2], double M20) {
  return(1150 + (M20 - 1150)*sqrt((M1lim[1] - M1value)/(M1lim[1] - M1lim[0])));
}

// is point x inside the vowel contours?
bool inside(double m1, double m2, double M1lim[2], double M2lim[2]) {
  bool ins = true;
  if (m1 < M1lim[0] || m1 > M1lim[1]) {
    ins = false;
  } else if (m2 > contour(m1, M1lim, M2lim[1])) {
    ins = false;
  } else if (m2 < contour(m1, M1lim, M2lim[0])) {
    ins = false;
  }
  return(ins);
}

// calculate total system energy
double energy(double M1[], double M2[], int n) {
  double E = 0;
  for (int i=0; i<n-1; i++) {
    for (int j=i+1; j<n; j++) {
      E = E + 1/(pow(M1[i] - M1[j], 2) + pow(M2[i] - M2[j], 2));
    }
  }
  return(E);
}

// print usage instructions
void usage(char *argv[]) {
  fprintf(stderr, "Usage: %s -n <vowels> -i <iterations> -o <outfile> [-l <logfile>] [-m <movement>]\n", argv[0]);
}

// main
int main(int argc, char *argv[]) {
  // global variables
  int iterations = -1;        // number of iterations
  int n = -1;                 // number of vowels
  double curr_energy;         // current system energy
  double log_energy;          // current system energy; for logging
  int rv;                     // random vowel
  int opt;                    // getopt
  double movement = 10;       // movement multiplier
  double movehere;            // local movement

  // vowel trapezium limits, from Liljencrants & Lindblom
  double M1lim[2] = {350, 850};
  double M2lim[2] = {800, 1700};

  // file names and file streams
  std::string outfilename = "";
  std::string logfilename = "";
  std::ofstream outfile;
  std::ofstream logfile;

  // read command-line arguments
  while ((opt = getopt(argc, argv, "i:n:o:l:m:")) != -1) {
    switch (opt) {
      case 'i':
        iterations = atoi(optarg);
        break;
      case 'n':
        n = atoi(optarg);
        break;
      case 'o':
        outfilename = optarg;
        break;
      case 'l':
        logfilename = optarg;
        break;
      case 'm':
        movement = atof(optarg);
        break;
      default:
        usage(argv);
        exit(EXIT_FAILURE);
    }
  }

  // check mandatory command-line arguments
  if (iterations == -1) {
    usage(argv);
    exit(EXIT_FAILURE);
  }
  if (n == -1) {
    usage(argv);
    exit(EXIT_FAILURE);
  }
  if (outfilename == "") {
    usage(argv);
    exit(EXIT_FAILURE);
  }

  // RNG stuff
  std::random_device rd;  // seed
  std::mt19937 gen(rd()); // Mersenne Twister generator
  std::uniform_real_distribution<double> disM1(M1lim[0], M1lim[1]);
  std::uniform_real_distribution<double> disM2(M2lim[0], M2lim[1]);
  std::uniform_int_distribution<int> disDisc(0,n-1);
  std::normal_distribution<double> disNorm(0,1);

  // declare dynamic M1 and M2 arrays
  double* M1 = new double[n];
  double* M2 = new double[n];

  // place n vowels randomly inside the contours
  for (int i=0; i<n; i++) {
    M1[i] = M1lim[0] - 1;
    M2[i] = M2lim[0] - 1;
    while (!inside(M1[i], M2[i], M1lim, M2lim)) {
      M1[i] = disM1(gen);
      M2[i] = disM2(gen);
    }
  }

  // main loop
  double newM1;
  double newM2;
  double oldM1;
  double oldM2;
  double oldmovehere;
  if (logfilename != "") {
    logfile.open(logfilename);
    logfile << "iteration,M1,M2prime,energy\n";
    log_energy = energy(M1, M2, n);
    for (int i=0; i<n; i++) {
      logfile << 0 << "," << M1[i] << "," << M2[i] << "," << log_energy << "\n";
    }
  }
  for (int t=0; t<iterations; t++) {
    // find current system energy
    curr_energy = energy(M1, M2, n);

    // pick random vowel
    rv = disDisc(gen);

    // move vowel
    movehere = movement;
    newM1 = M1[rv] + disNorm(gen)*movehere;
    newM2 = M2[rv] + disNorm(gen)*movehere;

    // still inside contours?
    oldmovehere = movehere;
    while (!inside(newM1, newM2, M1lim, M2lim)) {
      movehere = 0.5*movehere;
      newM1 = M1[rv] + disNorm(gen)*movehere;
      newM2 = M2[rv] + disNorm(gen)*movehere;
    }
    movehere = oldmovehere;

    // if energy decreased, update
    oldM1 = M1[rv];
    oldM2 = M2[rv];
    M1[rv] = newM1;
    M2[rv] = newM2;
    if (energy(M1, M2, n) >= curr_energy) {
      M1[rv] = oldM1;
      M2[rv] = oldM2;
    }

    // log
    if (logfilename != "") {
      log_energy = energy(M1, M2, n);
      for (int i=0; i<n; i++) {
        logfile << t+1 << "," << M1[i] << "," << M2[i] << "," << log_energy << "\n";
      }
    }
  }

  // writeout
  outfile.open(outfilename);
  outfile << "M1,M2prime\n";
  for (int i=0; i<n; i++) {
    outfile << M1[i] << "," << M2[i] << "\n";
  }

  // exit
  delete[] M1;
  delete[] M2;
  outfile.close();
  if (logfilename != "") {
    logfile.close();
  }
  return 0;
}
