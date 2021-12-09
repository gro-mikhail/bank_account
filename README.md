# README

"Регистр счетов в банке"

Деплой проекта на Heroku
  https://bank-account-test-app.herokuapp.com/

Фунционал:

- Создание пользователя с указанием тегов.
   POST '/clients'
   Возможные к передаче параметры:
     name                  - имя пользователя, обязательный
     surname               - фамилия пользователя, обязательный
     patronymic            - отчество пользователя, обязательный
     identification_number - идентификационный номер(идентификационный номер паспорта), обязательный, уникальный 
     tags - массив тегов пользователя, опционально
     
   Возвращаемые данные: json
   Пример:
   {"id":1,"name":"IVAN","surname":"IVANOV","patronymic":"IVANOVICH","identification_number":"2231087B052PT6","created_at":"2021-12-08T21:58:04.004Z","updated_at":"2021-12-08T21:58:04.004Z"}
    где:
      id                    - id созданного клиента
      name                  - имя созданного клиента
      surname               - фамилия созданного клиента
      patronymic            - отчество созданного клиента
      identification_number - идентификационный номер созданного клиента 
      created_at            - время создания клиента
   
- Открытие счета для пользователя по идентификационному номеру пользователя.
    POST '/accounts'
    Возможные к передаче параметры:
      identification_number - идентификационный номер(идентификационный номер паспорта) существуещего клиента , обязательный
      currency              - тип валюты по стандарту ISO-4127, обязательный, уникален для пользователя
    Возвращаемые данные: json
    Пример: 
    {"account_number":"d98a3184-ebeb-4656-9838-a75709f73b3d"}
      где:
       account_number - уникальный номер банковского счета
      

- ТРАНЗАКЦИИ
    POST '/transactions'
    Возможные к передаче параметры:
      amount        - число больше нуля, обязательный
      currency      - тип валюты по стандарту ISO-4127, обязательный
      sender_uid    - идентификационный номер(идентификационный номер паспорта) отправителя, опционально. необходимо указывать в случае перевода.
      recipient_uid - идентификационный номер(идентификационный номер паспорта) получателя
    Возвращаемые данные: json
    Пример: 
    {"amount":5000.0,"currency":"USD","sender_uid":"1151011B052PB3","recipient_uid":"2231087B052PT6","transfer":true,"errors":[]}
      где:
       amount        - сумма перевода
       currency      - тип валюты первода
       sender_uid    - идентификационный номер отправителя. В случае пополнения будет равен nil
       recipient_uid - идентификационный номер получателя
       transfer      - является ли транзакция переводом. В случае пополнения будет равен false
       
- ОТЧЕТЫ
   - Отчет "О сумме пополнений за период времени по-валютно" с возможностью фильтрации по пользователям.
       POST '/reports/replenishment_amount_by_currency'
         Возможные к передаче параметры:
           start_date - начальная дата для отчета, обязательный
           final_date - конечная дата для отчета, обязательный
           clients    - массив идентификационных номеров клиентов, опционально. При передаче будет производиться дополнительная фильтрация по идентификационным номерам
           csv        - true/fals, опционально. При указании true, будет создан файл csv с отчетом для загрузки. Иначе, отчет будет выведен на экран
         Возвращаемые данные: массив json или csv file
         Пример:  [{"id":null,"currency":"EUR","sum":2500.0,"identification_number":"4131087B052PB1"}]
           где:
             currency              - тип валюты в которой был пополнен счет
             sum                   - сумма пополнений
             identification_number - идентификационный номер клиента
   - Отчет "Средняя, максимальная и минимальная сумма переводов по тегам пользователей за период времени"
       POST '/reports/avg_min_max_amount_transaction_by_tags'
         Возможные к передаче параметры:
           start_date - начальная дата для отчета, обязательный
           final_date - конечная дата для отчета, обязательный
           tags       - массив тегов клиентов, опционально. При передаче будет производиться дополнительная фильтрация по тегам
           csv        - true/fals, опционально. При указании true, будет создан файл csv с отчетом для загрузки. Иначе, отчет будет выведен на экран
         Возвращаемые данные: массив json или csv file
           Пример:  [{"id":null,"currency":"EUR","min_amount":50.0,"max_amount":50.0,"average_amount":50.0,"tag_name":"NEW"}]
           где:
             currency       - тип валюты в которой был пополнен счет
             min_amount     - минимальная сумма переводов
             max_amount     - максимальная сумма переводов
             average_amount - средняя сумма переводов
             tag_name       - имя тега клиента
   - Отчет "Сумма всех счетов на текущий момент времени повалютно" с фильтрацией по тегам пользователей.
       POST '/reports/sum_accounts_by_currency'
         Возможные к передаче параметры:
           tags       - массив тегов клиентов, опционально. При передаче будет производиться дополнительная фильтрация по тегам
           csv        - true/fals, опционально. При указании true, будет создан файл csv с отчетом для загрузки. Иначе, отчет будет выведен на экран       
         Возвращаемые данные: массив json или csv file 
           [{"id":null,"currency":"BYN","sum":10.0,"tag_name":"BAN"},{"id":null,"currency":"BYN","sum":10.0,"tag_name":"NEW"}]
             где:
               currency - тип валюты в которой был пополнен счет
               sum      - сумма счетов в данной валюте
               tag_name - имя тега клиента
                  
     
       
      
