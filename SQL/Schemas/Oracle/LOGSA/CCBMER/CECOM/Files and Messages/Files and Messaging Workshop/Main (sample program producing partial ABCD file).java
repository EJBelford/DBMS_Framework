package partialwriteabcdsample1;


import gsfc.nssdc.cdf.Attribute;
import gsfc.nssdc.cdf.CDF;
import gsfc.nssdc.cdf.CDFException;
import gsfc.nssdc.cdf.Entry;
import gsfc.nssdc.cdf.Variable;

/**
 * Main Class contains a program that creates and writes an ABCD file in a step by step manner.
 * Sample data and metadata are hardcoded into global variables defined within this program.
 * See accompanying document for specification of metadata values.
 * 
 * This is a partial version of WriteABCDSample1.  The program to create the complete ABCD File
 * is provided in the WriteABCDSample1 project.
 *
 * May 30, 2012
 * Beth Allen, Data and Information Standards Center of Excellence (DISCoE)
 *
 */
public class Main {
    //----------------------------------------------------------------------------------
    // LVL00 GLOBAL METADATA VALUES
    //----------------------------------------------------------------------------------
    
    public Main() {
        super();
    }
  
    public static double[] generateDataArray(int length, double startrange, double endrange) {
        double[] dataArray = new double[length];
        
        double range = endrange - startrange;
        double value;
        for (int i = 0; i < length; i++) {
            value = Math.random() * range + startrange;
            dataArray[i] = value;
        }
        return dataArray;
    }
    
    
    public static void main(String[] args) {
        Main main = new Main();
        
        String abcdFileName = "C:\\TEMP\\partialsampleabcd1.cdf";
        if (args.length > 0) {
            abcdFileName = args[0];   // if a filename is given on command line, use it.
        }
        
        
        CDF cdfFile = null;            // use CDF object type as handle for abcd file
                                       // this object will be passed in/out of each step that manipuates
                                       // the abcd file
        
        // each of the steps within this try block are covered in the presentation
        try {
// Step 1: create abcd file, specify compression for file level at this time
            cdfFile = CDF.create(abcdFileName);
            // set compression on the file, if desired
            long    compressionType = CDF.GZIP_COMPRESSION;
            long[]  compressionParams = new long[1];  // one parameter can be used to configure compression
            compressionParams[0] = 9;                 // specify level 9 for GZIP compression
            cdfFile.setCompression(compressionType, compressionParams);         
            
// Step 2: Create and Write global attributes
            Attribute attr;  // CDF attribute object used to hold created attribute
            
            // Create a global attribute that holds a char string value as its entry
            attr = Attribute.create(cdfFile, "LVL00.FILE.Model.model_db_site", CDF.GLOBAL_SCOPE);
            Entry.create(attr, 0, CDF.CDF_CHAR, "000003F900000000");
            
            // Create a global attribute that holds a UINT4 value as its entry
            attr = Attribute.create(cdfFile, "LVL00.FILE.Model.model_db_id", CDF.GLOBAL_SCOPE);
            Entry.create(attr, 0, CDF.CDF_UINT4, new Integer(1));
            
// Step 3: Create a couple of variable level attributes (data values will be written as zvariables are created
            attr = Attribute.create(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_site", CDF.VARIABLE_SCOPE);
            attr = Attribute.create(cdfFile, "LVL00.SENS.Meas_Location.meas_loc_id", CDF.VARIABLE_SCOPE);           
            attr = Attribute.create(cdfFile, "LVL02.SENS.TS.embedded_time_data", CDF.VARIABLE_SCOPE);
            
// Step 4: Create and populate zvariable 1 (Internal Engine Temperature)
            // SINGLE DIMENSION EXAMPLE, BUFFERED (multi record)
            Variable zVariable; // cdf variable object
            
            long   numElements = 1;       // will be 1, uness specifying the number of characters in a string type
            long   numOfDimensions = 1;   // 1 dimensional array
            long[] dimensionSizes = new long[] { 1024 };  // the array length is 1024
            long[] dimensionVariances = new long[] { CDF.VARY };  // generally, values are set to vary at each dimension
            long   recordVariance = CDF.VARY;  // each record will vary
            
            // Create the zVariable in the CDF file
            zVariable = Variable.create(cdfFile, "Internal Engine Temperature", CDF.CDF_DOUBLE, 
                                                  numElements, numOfDimensions, dimensionSizes,
                                                  recordVariance, dimensionVariances);
                        
            // Add each buffered record of data
            double[] dataArray;
            // write 1st record
            dataArray = generateDataArray(1024, 400.00, 420.00);  // generate 1024 values in this temperature range
            zVariable.putRecord(0, dataArray);
            // write 2nd record
            dataArray = generateDataArray(1024, 500.00, 520.00); // generate new range of values for 2nd record buffer
            zVariable.putRecord(1, dataArray);
            
            // Step 4a: add metadata entries for this zvariable
            // meas location id
            attr = cdfFile.getAttribute("LVL00.SENS.Meas_Location.meas_loc_site");
            Entry.create(attr, zVariable.getID(), CDF.CDF_CHAR, "0000041D00001C99");
            attr = cdfFile.getAttribute("LVL00.SENS.Meas_Location.meas_loc_id");
            Entry.create(attr, zVariable.getID(), CDF.CDF_UINT4, new Integer(101));   
                        
// Step 5: Create and populate zvariable 2 (Vibration)
            // 2 DIMENSION EXAMPLE, Single Record (not buffered)
            // create 2d array where first column has time stamps, 2nd column has data value
            
            numElements = 1;       // will be 1, uness specifying the number of characters in a string type
            numOfDimensions = 2;   // 2 dimensional array
            dimensionSizes = new long[] { 5, 2 };  // the record holds 5 entries with 2 values each.
            dimensionVariances = new long[] { CDF.VARY, CDF.VARY };  // generally, values are set to vary at each dimension
            recordVariance = CDF.VARY;  // each record will vary
            
            // Create the zVariable in the CDF file   
            zVariable = Variable.create(cdfFile, "Vibration", CDF.CDF_DOUBLE, 
                                                  numElements, numOfDimensions, dimensionSizes,
                                                  recordVariance, dimensionVariances);
  
            // create a dummy set of data and write a record to the zvariable
            
            double time_offset = 0.10;  // hardcode a sample time offset
            double[][] dataMatrix = new double[5][2];  // 5 rows of data, 2 elements each
            for (int i = 0; i < 5; i++) {
                dataMatrix[i][0] = time_offset;  // time offsets = 0.1, 0.2, 0.3, ...
                dataMatrix[i][1] = Math.random() * 50.0 + 100.0;  // generate random values between 100 and 150.
                time_offset = time_offset + 0.10;
            }
            zVariable.putRecord(0, dataMatrix);
            
            // Step 5a: add metadata entries for this zvariable
            attr = cdfFile.getAttribute("LVL00.SENS.Meas_Location.meas_loc_site");
            Entry.create(attr, zVariable.getID(), CDF.CDF_CHAR, "0000041D00001C99");
            attr = cdfFile.getAttribute("LVL00.SENS.Meas_Location.meas_loc_id");
            Entry.create(attr, zVariable.getID(), CDF.CDF_UINT4, new Integer(102));   
            // add lvl02 flag indicating time stamps are stored as offsets embedded into first column of matrix      
            attr = cdfFile.getAttribute("LVL02.SENS.TS.embedded_time_data");
            Entry.create(attr, zVariable.getID(), CDF.CDF_INT1, new Integer(1));
            
// Step 6: MISCELLANEOUS ITEMS

// Create a user-defined attribute for a zVariable whose entry contains an array of values, for zvariable2
            attr = Attribute.create(cdfFile, "LVL99.User_Defined_Attribute1", CDF.VARIABLE_SCOPE);
            int[] numberList = { 2001, 2002, 2003, 2004 };
            Entry.create(attr, zVariable.getID(), CDF.CDF_INT4, numberList);
            
            
            
// Final step: close ABCD file
            cdfFile.close();
        } catch (CDFException ce) {
            System.out.println("An Error occurred writing the cdf File: " + abcdFileName);
            System.out.println("CDF ERROR: " + ce.getMessage());
            System.exit(1);
        }
        
        System.out.println("\nProgram Compete.   ABCD File written to: " + abcdFileName);
        
    }
}


