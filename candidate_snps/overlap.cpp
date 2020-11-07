// May 12, 2018
// by Gamze Gursoy
// input: matrix generated from 1000g vcf file and called SNVs in a txt format

#include <sstream>
#include <string>
#include "cstdio"
#include "cstring"
#include "cmath"
#include <string> 
#include "iostream"
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "zlib.h"
#include <vector>
using namespace std;


int main(int argc, char * argv[])
{
    if(argc == 1){
        cout << "Please input 1000g genotype matrix and called genotype files" << endl;
        return 1;
    }
    
    // files to open
    // 1000g genotype matrix  in txt format, delimiter is space
    char *oneg = argv[1];
    char filename1[80];
    sprintf(filename1,oneg);
    ifstream infile1(filename1);
    
    // Called SNV matrix generated from vcf file of called set, delimiter is space
    char *called = argv[2];
    char filename2[80];
    sprintf(filename2,called);
    ifstream infile2(filename2);
        
    char *chr = argv[3];
    char chrom[80];
    sprintf(chrom,chr);
    //int chrom = stoi(what);;


    // define the variables
    vector<double> E;
    vector<int> individual;
    int ssfreq1, ssfreq2;
    int loc, loc2;
    float info;
    string GT;
    int freq;
    string ref, ref2, alt, alt2, gt;
   
    string line1;
    string line2;
    string delimiter = " ";

    vector<string> chromosome;
    vector<int> range1;
    vector<int> range2;


while (getline(infile2,line2))
{
     if ( !line2.empty() )
     {
	string buf2;
	stringstream ss2(line2);
	size_t pos2=0;
	vector<string> tokens;
	while ( ss2 >> buf2) {
		tokens.push_back(buf2);
	}
	chromosome.push_back(tokens[0]);
	range1.push_back(stoi(tokens[1]));
	range2.push_back(stoi(tokens[2]));
     }
}
                
      //cout<<tokens[2504]<<endl	ifstream infile1(filename1);
        	while (getline(infile1,line1))
        	{
	    	if ( !line1.empty() )
	    	{
	    		string buf;
	    		stringstream ss(line1);
            		size_t pos2 = 0;
            		vector<string> tokens2;
            		while ( ss >> buf) {
		//cout<<"here"<<endl;
                		tokens2.push_back(buf);
           	 	}	
	  //  cout<<"here"<<endl;
            		loc = stoi(tokens2[1]);
	    	//cout<<loc2<<endl;
            		ref = tokens2[2];
            		alt = tokens2[3];
			GT = tokens2[4];
			freq = stoi(tokens2[5]);
			for (int i=0; i< chromosome.size(); i++)
			{
				//cout<<chromosome[i]<<endl;
				//cout<<chrom<<endl;
				if (chromosome[i].compare(chrom) == 0){
				//	cout<<range2[i]<<" "<<range1[i]<<" "<<loc<<endl;
					if (range2[i]>=loc && range1[i]<=loc){
						cout<<loc<<" "<<ref<<" "<<alt<<" "<<GT<<" "<<freq<<endl;
					}
				}
			}
		}
	}

    
    
}
