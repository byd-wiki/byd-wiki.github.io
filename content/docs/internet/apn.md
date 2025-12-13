---
title: APN
type: docs
weight: 4
prev: docs/internet/rsim
---

## Настройка APN

После пайки SIM-слота и настройки R-SIM необходимо настроить APN в головном устройстве автомобиля. Автомобиль пытается поднять несколько APN одновременно и сотовый оператор (тариф вашей сим-карты) должен это поддерживать.

1. APN1 - работает только в Китае, используется для передачи данных по внутренним каналам связи. Вне Китая можно отключить.
2. APN2 - предоставляет интернет для головного устройства (приложения, браузер, youtube и др.).
3. APN3 - служит для соединения с облаком BYD (связь с приложением, получение обновлений).

Таким образом, нужно зайти в [BydWirelessTools](/docs/head-unit/devtools) и добиться, чтобы `APN2` и `APN3` были активными. Ниже примерный порядок действий (названия пунктов могут меняться в зависимости от модели авто и прошивки):
- выключить APN1, включить APN3 и режим Double APN
- перезагружаем головное устройство удержанием кнопки громкости на центральной консоли
- заходим в [BydWirelessTools](/docs/head-unit/devtools) и проверяем настройки APN

Если одновременно `APN2` и `APN3` не заработали, можно попробовать:

- сменить оператора/тариф - как правило, несколько APN не работают на тарифах с безлимитным интернетом
- выключить VoLTE


## Снятие ограничения в 5 Gb

В головном устройстве имеется учет потребленного трафика по `APN2` с лимитом в 5 Gb/месяц. Это связано с тем, что в автомобиле предустановлен китайский eSIM чип с включенным бесплатным трафиком (5 Gb).

Для снятия ограничения необходимо выполнить следующие команды через [ADB](/docs/head-unit/adb):

```shell
adb shell pm disable-user --user 0 "com.byd.trafficmonitor"
adb settings put global private_dns_mode off
```


## SIM без MA

После пайки симки если не подключить `MA`, то постоянно будет выскакивать предложение о регистрации.

Чтобы его отключить, нужно через [AppManager](/apk/AppManager_443.apk) или [ADB](/docs/head-unit/adb) заморозить приложение `com.byd.bydbootguide`:

```shell
adb shell pm disable-user --user 0 "com.byd.bydbootguide"
```


## Другие команды

Другие полезные команды:

```shell
# Отключаем APN1 и APN2
adb shell settings put global mobile_data1 0
adb shell settings put global mobile_data2 0

# Включаем APN3
adb shell settings put global mobile_data3 1

# На всякий случай выключаем роуминг для APN1 и APN2
adb shell settings put global data_roaming1 0
adb shell settings put global data_roaming2 0

# Разрешаем роуминг (если нужен) для APN3
adb shell settings put global data_roaming3 1

# Перезапускаем мобильные данные (без перезагрузки системы)
adb shell svc data disable
adb shell svc data enable

# Проверяем, что активен только APN3
adb shell settings get global mobile_data1
adb shell settings get global mobile_data2
adb shell settings get global mobile_data3
```
