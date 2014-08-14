Скрипты на Python и R для анализа отчетов из Raiffeisen Connect и ведения домашнего бюджета по-взрослому
-------------------

Для запуска нужно проделать следующее:

* Установить Python (если его нет в системе): https://www.python.org/downloads/

* Установить R: http://cran.gis-lab.info/ При установке в Windows лучше изменить путь по умолчанию, так при дефолтном значении (C:\Program Files\R...) потребуются права администратора для установки пакетов. После установки в Windows нужно добавить путь к Rscript.exe в PATH

* Cохранить отчеты по картам/счетам из Raiffeisen Connect в формате csv и положить их в папку со скриптом.
Практика показала, что в отчете по счету данные более точные, чем в отчетах по карте, а точнее - даты транзакций соответствуют действительности. Это критично, так как среднее значение расходов расчитывается исходя из затрат в день. Если помимо обычных карт есть кредитка, отчет по ней можно сложить рядом с основным, скрипт все просуммирует

* Прописать интересующие статьи расходов в файле categories.txt. Например вот так: fastfood = KFC + MCDONALDS. Если поле Description в описании транзакции cодержит слово KFC или MCDONALDS, она будет отнесена к категории fastfood

* Запустить run.py. R доустановит необходимые пакеты и сохранит графики в папку output

Вангуя вопросы про безопасность - ничего никуда не отсылается. В этом можно самостоятельно убедиться воочию, скрипты недлинные :)
