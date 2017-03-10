/*A GLOBAL STATEMENT, NOT A PART OF DATA OR PROC STEPS*/
title "Understanding basic data manipulation techniques in SAS";

/*Writing output into a pdf*/
ods pdf file = "/folders/myfolders/mystudy1/Problem_1.pdf";

/*Creating a SAS data set*/
DATA TRANSACTIONS1;

/*Reading data into the SAS data set*/
INFILE "/folders/myfolders/mystudy1/Point_of_Sale.txt" dlm = '|';
INPUT TRANSACTION_ID NUM_OF_ITEMS @;

DO ITEM_ID = 1 to NUM_OF_ITEMS;
	input PROD_CODE $ UNITS PRICE @@; *this  is a comment statement;;;;
	COST = UNITS utput;
	end;

/*Subset of the original data set*/
DATA TRANSACTIONS2;
set transactions1;
by TRANSACTION_ID;

RETAIN cum_cost count;

	IF first.TRANSACTION_ID THEN
		DO;
		cum_cost = 0;
		count = 0;
		end;
	
cum_cost = cum_cost + COST;
count = count + 1;

do count = 1 to  NUM_OF_ITEMS;
	PROD1 = substr(PROD_CODE,1,1) ;
	PROD2 = substr(PROD_CODE,2,1) ;
	PROD3 = substr(PROD_CODE,3,1) ;
	END;
	
		
RUN;

/*Printing Transactions*/
PROC PRINT DATA=transactions2;
title "TRANSACTIONS2 TABLE";
RUN;

proc print data=transactions1;
title "TRANSACTIONS1 TABLE";
RUN;

/*Analyzing frequencies of the data set*/ - /*This is a block comment*/
PROC FREQ DATA=transactions2;
TITLE "PROD1, PROD2 & PROD3"; *current title statement overrides the previous title statement; 
TABLES PROD1 PROD2 PROD3;

proc freq data=transactions2;
title "Cross-Tabulation of PROD2 & PROD3";
tables PROD2*PROD3;
run;

proc means data=transactions2;
title "Means of All Numeric Variables in the Dataset";
var _NUMERIC_;
run;

proc means data=transactions2 MAX MIN MEAN;
title "MIN, MAX & MEAN of Each variable for each Transaction ID";
CLASS TRANSACTION_ID;
RUN;


PROC UNIVARIATE DATA=transactions2;
TITLE "Histogram of Costs & normal, lognormal distribution";
HISTOGRAM COST/ vscale=  count normal lognormal(noprint) ;
/*inset lognormal;*/
run;
Quit;

ods pdf close;
