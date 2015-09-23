# nmc-first-steps

Данное руководство описывает шаг за шагом основные принципы
создания программ на языке ассемблера, показывает, как
разработать программу, задействуя все основные узлы процессора
NMC, в том числе, векторный процессор, и затем, вызвать её из
программы на Си++.
Кроме того, приводятся основные принципы оптимизации программ
с учётом архитектуры процессора, структуры и состава окружающей
его периферии.


Проект является автономным и не требует предустановленного SDK.
Все необходимое ПО загружается в локальную папку в процессе установки.


## Установка Make for Windows
Для корректного исполнения сборочных Makefile-скриптов под Windows необходимо, чтобы был установлен
**Make for Windows**. [Скачать инсталлятор](http://gnuwin32.sourceforge.net/downlinks/make.php). Домашняя страница: http://gnuwin32.sourceforge.net/packages/make.htm

## Установка GNU Core Utilities for Windows (опционально)
В ряде случаев сборочные Makefile-скрипты используют GNU утилиты (rm,cp,rd..). Для обеспечения работоспосбности скриптов небходимо установить CoreUtils for Windows
либо самостоятельно с сайта http://gnuwin32.sourceforge.net/packages/coreutils.htm , либо из папки */deps* командой 
```bat
make gnuwin32
```


##  Установка NMSDK и ПО поддержки плат
Данный проект <nmc-first-steps> имеет несколько зависимостей от системного ПО:
- nmsdk (SDK для сборки программ под NMC)
- mc5103sdk (ПО поддержки для платы МЦ5103)
- mc7601sdk (ПО поддержки для платы МЦ7601)
- mb7707sdk (ПО поддержки для платы МВ77.07)

Скачать и установить в папку /deps/ все необходимые компоненты можно выполнив команды из корневой директории:
```bat
make download 
make install
```

Примечание 1:  
> Не смотря, что NMSDK и ПО поддержки плат может быть изначально установлено, для 
> упрощения настройки связей все зависимые компоненты подгружаются через интернет с сайта разработчика в локальную папку
> */deps* и дальше вызываются оттуда. При этом никаких изменений переменных окружения в системе не требуется и не производится.
> Локальное переопределение переменных производится в файле */environment.mk*

Примечание 2:  
> По умолчанию для скачивания и распаковки архивов под Windows используется встроенные средства PowerShell. 
> При необходимости так же могут использоваться внешние утилиты **wget** и **unzip**.
> В файле */nmc-first-steps/environment.mk* через переменные OS_WGET и OS_UNZIP можно настроить способ скачивания и распаковки 
- **Wget for Windows**. [Скачать инсталлятор](http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-setup.exe). Домашняя страница http://gnuwin32.sourceforge.net/packages/wget.htm
- **UnZip for Windows** [Скачать инсталлятор](http://gnuwin32.sourceforge.net/downlinks/unzip.php). Домашняя страница http://gnuwin32.sourceforge.net/packages/unzip.htm  
> Утилиты должны быть доступны через переменную окружения PATH.  
> Пути к **wget** и **unzip** можно не прописывать в PATH если при их установке была указана папка */nmc-first-steps/gnuwin32*
 
<!--
## Конфигурирование сборочных проектов
Для генерации сборочных проектов необходимо выполнить команду из корневой директории:
```bat
make configure
```

В результате данной команды для всех примеров будут сгенерированы соответствующие сборочные проекты под каждую плату, определенную в переменной PLATFOTRMS файла *environment.mk*.
-->

## Сборка и запуск
Сборка проекта осуществляется командой из соответствующей папки с примером:
```mak
 make 
```

Запуск приложения осуществляется командой:
```mak
 make run
```

## Документация 
Описания шагов находится в папке */doc*  

Документация по архитектуре NeuroMatrix и программированию находится в папке */deps/nmsdk/doc*