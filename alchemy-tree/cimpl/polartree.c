//Simple String Echo example
//mike chambers
//mchamber@adobe.com

#include <stdlib.h>
#include <stdio.h>

//Header file for AS3 interop APIs
//this is linked in by the compiler (when using flaccon)
#include "AS3.h"

//Method exposed to ActionScript
//Takes a String and echos it
static AS3_Val echo(void* self, AS3_Val args)
{
	//initialize string to null
	char* val = NULL;
	
	//parse the arguments. Expect 1.
	//pass in val to hold the first argument, which
	//should be a string
	AS3_ArrayValue( args, "StrType", &val );
	
	//if no argument is specified
	if(val == NULL)
	{
		char* nullString = "null";
		//return the string "null"
		return AS3_String(nullString);
	}
	
	//otherwise, return the string that was passed in
	return AS3_String(val);
}

//entry point for code
int main()
{
	//define the methods exposed to ActionScript
	//typed as an ActionScript Function instance
	AS3_Val echoMethod = AS3_Function( NULL, echo );

	// construct an object that holds references to the functions
	AS3_Val result = AS3_Object( "echo: AS3ValType", echoMethod );

	// Release
	AS3_Release( echoMethod );

	// notify that we initialized -- THIS DOES NOT RETURN!
	AS3_LibInit( result );

	// should never get here!
	return 0;
}