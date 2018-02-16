#include <iostream>
#include <time.h>
#include "cdf.h"
using namespace std ;

void handleException(CDFstatus status)
{
	char message[CDF_STATUSTEXT_LEN + 1];
	if (status != CDF_OK) {
        cout << "Error occured processing cdf file." << endl;
		CDFerror(status, message);
		cout << message << endl;
		cout << "\nExiting program." << endl;
		exit(1);
	}
}

double* generateDataArray( int length, double startrange, double endrange) 
{
	    double* dataArray;
        dataArray = new double[length];
		srand( time(NULL));

        
        double range = endrange - startrange;
        double value;
        for (int i = 0; i < length; i++) {
            value = rand()*1.0 / RAND_MAX * range + startrange;
            dataArray[i] = value;
        }
        return dataArray;
}
    

int main(void) 
{
	cout << "Start Program" << endl;
	CDFid cdfFile;
	CDFstatus status;
	char *filename = "c:\\temp\\c_partialsampleabcd1.cdf";

// Step 1: create abcd file, specify compression for file level at this time
	status = CDFcreateCDF(filename, &cdfFile);
	handleException(status);

	// if desired, set compression. This example sets to GZIP.9
    long compressionType = GZIP_COMPRESSION;
	long compressionParms[CDF_MAX_PARMS];
	compressionParms[0] = 9;
    status = CDFsetCompression(cdfFile, compressionType, compressionParms);
	handleException(status);


// Step 2: Create and Write global attributes
	long attributeId;

	// Create a global attribute that holds a char string value as its entry
	status = CDFcreateAttr(cdfFile, "LVL00.FILE.Model.model_db_site", GLOBAL_SCOPE, &attributeId);
	handleException(status);

	char *model_db_site = "000003F900000000";
	status = CDFputAttrgEntry (cdfFile, attributeId, 0, CDF_CHAR, strlen(model_db_site), model_db_site);
	handleException(status);

	// Create a global attribute that holds a UINT4 value as its entry
	status = CDFcreateAttr(cdfFile, "LVL00.FILE.Model.model_db_id", GLOBAL_SCOPE, &attributeId);
	handleException(status);

	unsigned int model_db_id = 1;  // attribute value
	status = CDFputAttrgEntry (cdfFile, attributeId, 0, CDF_UINT4, 1, &model_db_id);
	handleException(status);

// Step 3: Create a couple of variable level attributes (data values will be written as zvariables are created
	status = CDFcreateAttr(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_site", VARIABLE_SCOPE, &attributeId);
	handleException(status);
	status = CDFcreateAttr(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_id", VARIABLE_SCOPE, &attributeId);
	handleException(status);
	status = CDFcreateAttr(cdfFile, "LVL02.SENS.TS.embedded_time_data", VARIABLE_SCOPE, &attributeId);
	handleException(status);


// Step 4: Create and populate zvariable 1 (Internal Engine Temperature)
	// SINGLE DIMENSION EXAMPLE, BUFFERED (multi record)

    long   zVariableId; // cdf variable id
            
    long   numElements = 1;       // will be 1, uness specifying the number of characters in a string type
    long   numOfDimensions = 1;   // 1 dimensional array
    long   dimensionSizes[1] = { 1024 };  // the array length is 1024
    long   dimensionVariances[1] = { VARY };  // generally, values are set to vary at each dimension
    long   recordVariance = VARY;  // each record will vary
            
    // Create the zVariable in the CDF file
    status = CDFcreatezVar(cdfFile, "Internal Engine Temperature", CDF_DOUBLE, 
                                                  numElements, numOfDimensions, dimensionSizes,
                                                  recordVariance, dimensionVariances, &zVariableId);
	handleException(status);
	
	// put 1st record of data into the zvariable
	double *data = generateDataArray(1024, 400.0, 420.0);
    status = CDFputzVarRecordData(cdfFile, zVariableId, 0, data);
	handleException(status);

	// put 2nd record of data into the zvariable
    data = generateDataArray(1024, 500.0, 520.0);
    status = CDFputzVarRecordData(cdfFile, zVariableId, 1, data);
	handleException(status);

    // Step 4a: add metadata entries for this zvariable
    // meas location id
    attributeId = CDFgetAttrNum(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_site");
	char *meas_loc_site = "0000041D00001C99";
	status = CDFputAttrzEntry (cdfFile, attributeId, zVariableId, CDF_CHAR, strlen(meas_loc_site), meas_loc_site);
	handleException(status);

    attributeId = CDFgetAttrNum(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_id");
	unsigned int meas_loc_id = 101;  // attribute value
	status = CDFputAttrzEntry (cdfFile, attributeId, zVariableId, CDF_UINT4, 1, &meas_loc_id);
	handleException(status);
    

// Step 5: Create and populate zvariable 2 (Vibration)
	// 2 DIMENSION EXAMPLE, Single Record (not buffered)
    // create 2d array where first column has time stamps, 2nd column has data value
	
	numElements = 1;       // will be 1, uness specifying the number of characters in a string type
    numOfDimensions = 2;   // 2 dimensional array
    long   dimensionSizes2[2] = { 5, 2 };  // the matrix is 5 rows, 2 cols
    long   dimensionVariances2[2] = { VARY, VARY };  // generally, values are set to vary at each dimension
    recordVariance = VARY;  // each record will vary
            
    // Create the zVariable in the CDF file
    status = CDFcreatezVar(cdfFile, "Vibration", CDF_DOUBLE, 
                                                 numElements, numOfDimensions, dimensionSizes2,
                                                 recordVariance, dimensionVariances2, &zVariableId);
	handleException(status);

	// create a dummy set of data and write a record to the zvariable
	double time_offset = 0.10;
	double dataMatrix[5][2];
	for (int i = 0; i < 5; i++) {
		dataMatrix[i][0] = time_offset;  // time offsets = 0.1, 0.2, 0.3, ...
		dataMatrix[i][1] = rand()*1.0 / RAND_MAX * 50.0 + 100.0; // generate random values between 100 and 150.
		time_offset = time_offset + 0.10;
	}
    status = CDFputzVarRecordData(cdfFile, zVariableId, 0, dataMatrix);
	handleException(status);

	// Step 5a: add metadata entries for this zvariable
    // meas location id
    attributeId = CDFgetAttrNum(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_site");
	meas_loc_site = "0000041D00001C99";
	status = CDFputAttrzEntry (cdfFile, attributeId, zVariableId, CDF_CHAR, strlen(meas_loc_site), meas_loc_site);
	handleException(status);

    attributeId = CDFgetAttrNum(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_id");
	meas_loc_id = 102;  // attribute value
	status = CDFputAttrzEntry (cdfFile, attributeId, zVariableId, CDF_UINT4, 1, &meas_loc_id);
	handleException(status);
    
	// add lvl02 flag indicating time stamps are stored as offsets embedded into first column of matrix      
	attributeId = CDFgetAttrNum(cdfFile, "LVL02.SENS.TS.embedded_time_data");
	char embeddedtd=1;
	status = CDFputAttrzEntry (cdfFile, attributeId, zVariableId, CDF_INT1, 1, &embeddedtd);
	handleException(status);


// Final step: close ABCD file
	status = CDFcloseCDF(cdfFile);
	handleException(status);

	cout << "\n\nEnd PRogram.  File created successfully.\n\n";
	return 0;
}