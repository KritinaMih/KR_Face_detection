[filename, pathname]=uigetfile ('*.*', 'Выбор изображения') ;
filewithpath=strcat (pathname, filename) ;
Img=imread (filewithpath) ;

faceDetector = vision.CascadeObjectDetector; %Создается объект faceDetector с помощью vision.CascadeObjectDetector для обнаружения лиц на изображении.
faceDetector.MergeThreshold = 20; %Устанавливается порог объединения (MergeThreshold) для улучшения обнаружения лиц на изображении.
bboxes = faceDetector (Img); %Поиск и получение координат ограничивающего прямоугольника (Bounding Box) вокруг обнаруженного лица.

%Далее идет проверка условия: если лица были или не были обнаружены:
if ~isempty (bboxes)
Imgf = insertObjectAnnotation (Img, 'rectangle', bboxes, 'Лицо', 'Linewidth', 3) ; %Вставляется аннотация Face с ограничивающим прямоугольником вокруг обнаруженного лица.
figure; imshow (Imgf)
title ('Найденные лица') ; %Показывается изображение с выделенными лицами.

else
position=[0 0]; 
label='Лица не найдены';
Imgn = insertText (Img, position, label, 'FontSize', 25, 'BoxOpacity', 1);

figure;imshow (Imgn)
end