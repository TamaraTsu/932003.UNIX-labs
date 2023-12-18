Инструкция:
(все в cmd) 

1. docker volume create megavolume

2. docker build -t unix-2 .

3.  for /L %i in (1,1,10) do (docker run -d -v megavolume:/data unix-2) 
    (10 контейнеров)

4.  docker run -it --rm -v megavolume:/data alpine ls /data

5.  docker ps