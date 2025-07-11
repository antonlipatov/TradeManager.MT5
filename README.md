# TradeManager MQL5 Expert Advisor

`TradeManager` - это Советник (Expert Advisor) для MetaTrader 5, предназначенный для упрощения процесса торговли путем предоставления визуальных инструментов на графике для установки ордеров, управления рисками и отслеживания позиций.

## Описание

Советник добавляет на график интерактивные элементы управления, которые позволяют трейдеру:

- Размещать отложенные ордера (Pending Orders) с визуальным указанием цены входа и стоп-лосса
- Рассчитывать объем лота на основе заданного процента риска от баланса счета
- Модифицировать стоп-лосс и тейк-профит существующих позиций
- Отображать важную информацию прямо на графике: спред, количество и объем открытых позиций, уровни стопов брокера
- Настраивать визуальное оформление графика и торговых уровней

## Основные возможности

### Визуальное размещение ордеров

- Кнопка "Pending" для активации режима установки отложенного ордера
- Клик на графике для установки уровня входа, затем второй клик для установки стоп-лосса
- Автоматический расчет типа отложенного ордера (Buy/Sell Limit/Stop) на основе положения уровней относительно текущей цены

### Управление риском

- Возможность выбора одного из пяти предустановленных уровней риска (в % от баланса)
- Автоматический расчет объема лота для отложенного ордера на основе выбранного риска и расстояния до стоп-лосса

### Управление позициями

- Кнопка "Modify Positions" для активации режима модификации TP/SL существующих позиций
- Визуальное перетаскивание уровня для установки нового TP или SL
- Диалоговое окно для выбора направления (Buy/Sell) при наличии разнонаправленных позиций

### Текст на графике

- Отображение текущего спреда
- Отображение количества и суммарного объема открытых Buy и Sell позиций
- Отображение водяного знака с названием инструмента и таймфрейма
- Отображение уровней Stop Level брокера

### Настраиваемый интерфейс

- Возможность включения/отключения пользовательских настроек визуализации графика
- Настройка цветов и толщины линий для отложенных ордеров, стоп-лоссов и уровней модификации
- Настройка цветов текстовых меток

### Дополнительные кнопки управления

- "Cancel Orders": Отмена всех отложенных ордеров по текущему символу
- "Close Positions": Закрытие всех открытых позиций по текущему символу
- Кнопка сворачивания/разворачивания панели кнопок для экономии места на графике

## Структура проекта

- `TradeManager.mq5`: Главный файл советника, инициализирует приложение и обрабатывает события терминала
- `Application.mqh`: Основной класс, управляющий логикой советника
- `ChartButtons.mqh`: Класс для создания и управления кнопками на графике
- `ChartLabels.mqh`: Класс для создания и управления текстовыми метками
- `DialogWindow.mqh`: Класс для создания и управления диалоговыми окнами
- `StopLevel.mqh`: Класс для отображения уровней Stop Level брокера
- `TradeLevel.mqh`: Класс для управления интерактивными торговыми уровнями
- `TradeHelper.mqh`: Вспомогательный класс для торговых операций
- `Helper.mqh`: Общий вспомогательный класс с утилитарными функциями

## Входные параметры

### Настройки отображения графика

- `inputEnableCustomChartSettings`: Включить пользовательские настройки
- `inputShowWatermark`: Показывать водяной знак
- `inputWatermarkLabelColor`: Цвет водяного знака

### Настройки торговых уровней

- `inputPendingOrderColor`: Цвет линии отложенного ордера
- `inputPendingOrderLineWidth`: Толщина линии отложенного ордера
- `inputPendingOrderLabelColor`: Цвет текста уровня
- `inputStoplossColor`: Цвет линии стоп-лосса
- `inputStoplossLineWidth`: Толщина линии стоп-лосса
- `inputStoplossLabelColor`: Цвет текста стоп-лосса
- `inputModifyPositionsColor`: Цвет линии модификации
- `inputModifyPositionsLineWidth`: Толщина линии модификации
- `inputModifyPositionsLabelColor`: Цвет текста модификации

### Управление риском

- `inputRisk1` - `inputRisk5`: Пять значений риска в % для быстрого выбора

### Информационные метки

- `inputShowPositionsQtLabel`: Показывать объем позиций
- `inputShowSpread`: Показывать спред
- `inputInfoLabelsColor`: Цвет информационных меток

### Уровни Stop Level

- `inputShowStopLevels`: Показывать уровни Stop Level
- `inputStopLevelUpLineColor`: Цвет верхней линии
- `inputStopLevelDownLineColor`: Цвет нижней линии
- `inputStopLevelLineWidth`: Толщина линий

## Использование

### Размещение отложенного ордера

1. Нажмите кнопку "Pending"
2. Кликните на графике в месте входа → появится линия входа
3. Кликните второй раз для установки стоп-лосса
4. Выберите процент риска
5. Нажмите "Send" для отправки ордера

### Модификация позиций

1. Нажмите "Modify Positions"
2. Кликните на графике для установки нового TP/SL
3. При разнонаправленных позициях выберите направление в диалоге
4. Нажмите "Send" для модификации

### Дополнительные функции

- **Cancel Orders**: Отмена всех отложенных ордеров по инструменту
- **Close Positions**: Закрытие всех открытых позиций по инструменту
- **:< / :>**: Сворачивание/разворачивание панели
