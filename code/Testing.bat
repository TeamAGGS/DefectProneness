set R_Script="C:\Program Files\R\R-3.1.2\bin\RScript.exe"
:: Write commands for all your datasets here
%R_Script% Model-Testing.R ..\models\ivy-training.csv.rda ..\testing_data\ivy-2.0.csv ..\PredictedData\ivy-2.0.csv
%R_Script% Model-Testing.R ..\models\jedit-training.csv.rda ..\testing_data\jedit-4.3.csv ..\PredictedData\ant-1.7.csv
%R_Script% Model-Testing.R ..\models\kalkulator-training.csv.rda ..\testing_data\kalkulator-testing.csv ..\PredictedData\kalkulator.csv
%R_Script% Model-Testing.R ..\models\log4j-training.csv.rda ..\testing_data\log4j-1.2.csv ..\PredictedData\log4j-1.2.csv
%R_Script% Model-Testing.R ..\models\lucene-training.csv.rda ..\testing_data\lucene-2.4.csv ..\PredictedData\lucene-2.4.csv
%R_Script% Model-Testing.R ..\models\nieruchomosci-training.csv.rda ..\testing_data\nieruchomosci-testing.csv ..\PredictedData\nieruchomosci.csv
%R_Script% Model-Testing.R ..\models\pbeans-training.csv.rda ..\testing_data\pbeans2.csv ..\PredictedData\pbeans2.csv
%R_Script% Model-Testing.R ..\models\pdftranslator-training.csv.rda ..\testing_data\pdftranslator-testing.csv ..\PredictedData\pdftranslator.csv
pause