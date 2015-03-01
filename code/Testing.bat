set R_Script="C:\Program Files\R\R-3.1.2\bin\RScript.exe"
:: Write commands for all your datasets here
%R_Script% Model-Testing.R ..\models\szybkafucha-training.csv.rda ..\testing_data\szybkafucha-testing.csv ..\PredictedData\szybkafucha.csv

%R_Script% Model-Testing.R ..\models\termoproject-training.csv.rda ..\testing_data\termoproject-testing.csv ..\PredictedData\termoproject.csv

%R_Script% Model-Testing.R ..\models\tomcat-training.csv.rda ..\testing_data\tomcat-testing.csv ..\PredictedData\tomcat.csv

%R_Script% Model-Testing.R ..\models\velocity-training.csv.rda ..\testing_data\velocity-1.6.csv ..\PredictedData\velocity-1.6.csv

%R_Script% Model-Testing.R ..\models\workflow-training.csv.rda ..\testing_data\workflow-testing.csv ..\PredictedData\workflow.csv

%R_Script% Model-Testing.R ..\models\wspomaganiepi-training.csv.rda ..\testing_data\wspomaganiepi-testing.csv ..\PredictedData\wspomaganiepi.csv

%R_Script% Model-Testing.R ..\models\xalan-training.csv.rda ..\testing_data\xalan-2.7.csv ..\PredictedData\xalan-2.7.csv

%R_Script% Model-Testing.R ..\models\xerces-training.csv.rda ..\testing_data\xerces-1.4.csv ..\PredictedData\xerces-1.4.csv

%R_Script% Model-Testing.R ..\models\zuzel-training.csv.rda ..\testing_data\zuzel-testing.csv ..\PredictedData\zuzel.csv
pause