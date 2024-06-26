%Считывание исходного изображения
[filename, pathname]=uigetfile ('*.*', 'Выбор изображения') ;
filewithpath=strcat (pathname, filename) ;
L=imread (filewithpath) ;

[N M s]=size(L);% Получаем размеры изображения (высоту, ширину и количество каналов)
L=double(L)./255;% Преобразуем данные в диапазон от 0 до 1, чтобы упростить обработк
figure, imshow(L);% Отображаем исходное изображение
title('Исходное изображение');

%Выбор пикселей лица с характерным цветом
[x,y,z]=impixel;% Функция impixel позволяет выбрать пиксели на изображении
% Получаем медианные значения красного, зеленого и синего цветов
r=median(z(:,1)); std_r=std(z(:,1)); 
g=median(z(:,2)); std_g=std(z(:,2)); 
b=median(z(:,3)); std_b=std(z(:,3)); 

%Сегментация на основе анализа цвета
% Проходим по каждому пикселю изображения
for i=1:N;
 disp(i);
 for j=1:M;
  % Если цвет текущего пикселя близок к медианному значению цветов лица, помечаем его как пиксель лица
  if  (abs(L(i,j,1)-r)<std_r)&(abs(L(i,j,2)-g)<std_g)&(abs(L(i,j,3)-b)<std_b);
  L1(i,j)=1;
 else
  L1(i,j)=0;
 end;
  end;
end;

% Отображаем результат сегментации
figure, imshow(L1);
title('Исходное изображение после сегментации');
imwrite(L1,'Исходное изображение после сегментации.jpg');

%Удаление объектов, площадь которых меньше некоторой заданной величины (для удаления шума)
% Удаляем объекты с площадью меньше 1000 пикселей (шум)
[mitka num]=bwlabel(L1,8); % Применяем морфологическую операцию для разметки черно-белого изображения
feats=regionprops(mitka,'Area'); % Извлекаем свойства областей (Area) для каждого объекта
Areas=zeros(num); % Создаем массив для хранения площадей объектов
for i=1:num; % Цикл по всем объектам
    Areas(i)=feats(i).Area; % Сохраняем площадь каждого объекта в массив
end;
idx=find(Areas>1000); % Находим индексы объектов с площадью больше 1000 пикселей
L1=ismember(mitka,idx); % Оставляем только объекты с площадью больше 1000 пикселей
figure,imshow(L1);title('После удаления шума (небольших объектов)'); % Отображаем изображение после удаления шума

L1=1-L1; % Инвертируем изображение
[mitka num]=bwlabel(L1,8); % Снова применяем морфологическую операцию для разметки изображения
feats=regionprops(mitka,'Area'); % Извлекаем свойства областей (Area) для каждого объекта
Areas=zeros(num); % Создаем массив для хранения площадей объектов
for i=1:num; % Цикл по всем объектам
    Areas(i)=feats(i).Area; % Сохраняем площадь каждого объекта в массив
end;
idx=find(Areas>1000); % Находим индексы объектов с площадью больше 1000 пикселей
L1=ismember(mitka,idx); % Оставляем только объекты с площадью больше 1000 пикселей
L1=1-L1; % Инвертируем изображение
figure,imshow(L1);title('После удаления шума (небольших объектов)'); % Отображаем изображение после удаления шума 
Lmitky = bwlabel(L1,4);%Преобразование изображения L1 в метки, используя связность 4.

Lmitky = bwlabel(L1,4);
figure,imshow(Lmitky);
title('Изображение меток');
imwrite(Lmitky,'Изображение меток.jpg');
figure, imshow(L);
title('Найденное лицо');

%Создание гистограммы меток и определение номеров меток, чья площадь больше 1000 пикселей.
H=hist(Lmitky(:),max(max(Lmitky)));
Nomer=find(H>1000);
%  Выделение областей на изображении с метками, начиная со второй по площади.
for r=2:length(Nomer);
    MIN_i=N;MIN_j=M;MAX_i=0;MAX_j=0;    
    for i=1:N;
        for j=1:M;
            if Lmitky(i,j)==Nomer(r);
               if i<MIN_i;
                MIN_i=i;
               end;
              if j<MIN_j;
                MIN_j=j;                
              end;
              if i>MAX_i;
                MAX_i=i;
              end;
              if j>MAX_j;
                MAX_j=j;                
              end; 
            end;
        end;
    end;
   %  Отрисовка прямоугольника, охватывающего область метки на изображении.
   line([MIN_j MAX_j],[MIN_i MIN_i]);hold on;
   line([MAX_j MAX_j],[MIN_i MAX_i]);
   line([MAX_j MIN_j],[MAX_i MAX_i]);
   line([MIN_j MIN_j],[MIN_i MAX_i]);hold off; 
end;