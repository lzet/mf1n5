## My Finance System

Free, open-source, easy-to-use personal finance web application.  
It's remake [MyFin v1](https://bitbucket.org/Pozadi/myfin/wiki/Home) application on ROR with PostgreSQL support.

#### To-do

- [ ] Regular payments

#### Installation

##### Usual way

- [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)

##### Use docker

- install [Docker](https://www.docker.com/)
- clone repository
- edit Docker.sqlite or Docker.postgres file (depends on the database used)
- cd path/to/repository
- build docker image
  - for SQLite
    ```
    docker build -t mf1n5demo:v1.0 -f ./Dockerfile.sqlite ./
    ```
  - for PostgreSQL
    ```
    docker build -t mf1n5demo:v1.0 -f ./Dockerfile.postgres ./
    ```

- create docker container
  ```
  docker create --name mf1n5containerdemo -p 3501:3501 mf1n5demo:v1.0
  ```
- start docker container (stop/restart)
  ```
  docker start mf1n5containerdemo
  ```
- login with admin@admin and adminpassword
- change password and settings

#### License

MF1n5 is released under the MIT license (LICENSE file).


---------


## Моя бухгалтерия

Свободное программное обеспечение, простое в использовании и установке веб-приложение.  
Это приложение создано по мотивам [MyFin v1](https://bitbucket.org/Pozadi/myfin/wiki/Home), с использованием ROR и с поддержкой SQLite и PostgreSQL.

#### В планах добавить

- [ ] Регулярные платежи

#### Установка

##### Обычная для рельс

- [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)

##### Простая, используя докер

- установите [Docker](https://www.docker.com/)
- клонируйте этот репозиторий
- поправьте Docker.sqlite или Docker.postgres файл (зависит от используемой базы данных).
- cd path/to/repository
- создайте докер-образ
  - для SQLite
    ```
    docker build -t mf1n5demo:v1.0 -f ./Dockerfile.sqlite ./
    ```
  - для PostgreSQL
    ```
    docker build -t mf1n5demo:v1.0 -f ./Dockerfile.postgres ./
    ```

- создайте докер-контейнер
  ```
  docker create --name mf1n5containerdemo -p 3501:3501 mf1n5demo:v1.0
  ```
- запустите докер-контейнер (остановить и перезапустить можно командами stop и restart)
  ```
  docker start mf1n5containerdemo
  ```
- зайти в систему логином admin@admin и паролем adminpassword
- сменить пароль и настроить по желанию

#### Лицензия

МИТ лицензия (файл LICENSE).

