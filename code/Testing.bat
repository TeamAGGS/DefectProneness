set R_Script="C:\Program Files\R\R-3.1.2\bin\RScript.exe"
%R_Script% Model-Testing.R ..\models\camel-training.csv.rda ..\data\camel-1.6.csv ..\PredictedData\camel-1.6.csv > testing.batch 2>&1