// May 12, 2017
// by Gamze Gursoy
// input: matrix generated from 1000g vcf file, called SNVs and corresponding genotypes in txt formats

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
    
   
   //file with genotypes
   char *gnt =argv[2];
   char filename2[80];
   sprintf(filename2,gnt);

   char *num =argv[3];
   char number[80];
   sprintf(number,num);
   int N=stoi(number);
   int NN=2503;

 
    // define the variables
    vector<double> E;
    vector<int> individual;
    int ssfreq1, ssfreq2;
    int loc, loc2;
    float info=1;
    string ref, ref2, alt, alt2, gt;
    for (int k=0; k<NN; k++)
    {
        E.push_back(0);
        individual.push_back(0);
    }
    
    string line1;
    string line2;
    string delimiter = " ";
    vector<string> tokens1;

ifstream infile2(filename2);
while (getline(infile2,line2))
{
	if (!line2.empty())
	{
		 string buf;
                 stringstream ss(line2);
                 size_t pos2 = 0;
                 while ( ss >> buf) {
			tokens1.push_back(buf);
		}
	}
}

int ll=-1;	       
while (getline(infile1,line1)){
	if ( !line1.empty() )
	{
		for (int kk=0; kk<NN; kk++)
		{
			individual[kk]=0;
		}
		ll=ll+1;
		ssfreq1=0;
		ssfreq2=0;
   		string buf;
  		stringstream ss(line1);
            	size_t pos2 = 0;
            	vector<string> tokens2;
            	while ( ss >> buf) {
                	tokens2.push_back(buf);
           	 }	
            	loc = stoi(tokens2[0]);
            	ref = tokens2[1];
            	alt = tokens2[2];
       		string GT;
        	for (int i=0; i<N; i++)
        	{
            		GT=tokens2[i+3];
			if (tokens1[ll]=="0/1" && (GT=="0|1" || GT=="1|0"))
			{
				individual[i]=1;
				ssfreq1=ssfreq1+1;
			}
			if (tokens1[ll]=="1/1" && GT=="1|1")
			{
				individual[i]=2;
				ssfreq2=ssfreq2+1;
			}
			if (GT=="0|0")
			{
				individual[i]=0;
			}
        	}
                for (int ind=0; ind<N; ind++)
                {
              		if (individual[ind]==1)
                    	{
                        	E[ind]=E[ind]-info*log2(double(ssfreq1)/N);
                    	}
			if (individual[ind]==2)
			{
                        	E[ind]=E[ind]-info*log2(double(ssfreq2)/N);
                    	}
                    	if (individual[ind]==0)
                	{    	
                        	E[ind]=E[ind]+0;
                    	}
                }
	}
}

for (int i=0; i<N; i++)
{
	cout<<E[i]<<endl;
}
infile1.close();
infile2.close();

}    
