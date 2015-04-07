
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <stdbool.h>

#define BYTES_PER_LINE	15

int main(int argc, char *argv[])
{
	if (argc != 3)
	{	
		printf("\nUsage: %s <Input> <VariableName>\n", argv[0]);
		exit(0);
	}
	
	FILE *Input = fopen(argv[1], "rb");
	if (Input == NULL)
	{
		printf("Error Opening File: \"%s\" !", argv[1]);
		exit(0);
	}
	
	char OutputFileName[128];
	sprintf(OutputFileName, "%s.inc", argv[2]);
	FILE *Output = fopen(OutputFileName, "wb");
	if (Output == NULL)
	{
		printf("Error Creating Output File: \"%s\" !", OutputFileName);
		exit(0);
	}
	unsigned char Buffer[BYTES_PER_LINE];
	char Converted[128];
	char *NewLine = ",\n\t";
	bool FirstTime = true;
	fseek(Input, 0, SEEK_END);
	int Len = ftell(Input);
	fseek(Input, 0, SEEK_SET);
	
	
	while (!feof(Input))
	{
		if (FirstTime)
		{
			char Variable[512];
			sprintf(Variable, "unsigned char %s[%d] = {\n\t", argv[2], Len);
			fwrite(Variable, sizeof(char), strlen(Variable), Output);
			FirstTime = false;
			continue;
		}
		
		int Read = fread(Buffer, sizeof(unsigned char), BYTES_PER_LINE, Input);
		if (Read <= 0) break;
		int i, j;
		
		for (i = 0, j = 0; i < Read; i++, j += 5)
		{
			sprintf(&Converted[j], "0x%.2X, ", (unsigned char) Buffer[i]);
		}
		fwrite(Converted, sizeof(char), j - 1, Output);
		fwrite(NewLine, sizeof(char), strlen(NewLine), Output);
	}
	
	fseek(Output, ftell(Output) - strlen(NewLine), SEEK_SET);
	
	char *EndOfFile = "\n};";
	fwrite(EndOfFile, sizeof(char), strlen(EndOfFile), Output);
	
	fclose(Input);
	fclose(Output);
	return 0;
}
