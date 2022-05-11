clear
clc
close all

info = importdata('info_control.txt');

unidades = cell2mat(info.textdata(1,1));
clas_arch = cell2mat(info.textdata(2,1));
name_arch = cell2mat(info.textdata(3,1));
imprimir = info.data(1,1);


x_ini = info.data(2,1);
x_fin = info.data(3,1);
x_f = info.data(4,1);
z_f = info.data(5,1);
h = info.data(6,1);
aproximacion = info.data(7,1);
n_capas = info.data(8,1);

vel_capas = -ones(n_capas,1);   %Columna donde se guardaran las velocidades de las capas.
esp_capas = vel_capas;          %Columna donde se guardaran los espesores de las capas.

for ii=1:n_capas
   
    vel_capas(ii,1) = info.data(8+ii,1);
    esp_capas(ii,1) = info.data(8+n_capas+ii,1);
    
end

esp_total = sum(esp_capas);

z_ini = 0;
z_fin = esp_total;

[xq,zq] = meshgrid(x_ini:h:x_fin, z_ini:h:z_fin);
[m,n]=size(xq);
vq = -ones(m,n);

profundidad = zeros(n_capas+1,1);
for kk=1:n_capas
    
    profundidad(kk+1,1)=profundidad(kk,1)+esp_capas(kk,1);

end
    
for kk = 1: n_capas
             
    for ll = 1 : m
                    
        if (zq(ll,1) >= profundidad(kk,1)) && (zq(ll,1) <= profundidad(kk+1,1))
                              
            vq(ll,:) = vel_capas(kk,1);
                         
        end
        
    end
       
end

max_xq=max(max(xq));
max_zq=max(max(zq));
min_xq=min(min(xq));
min_zq=min(min(zq));

%--- Calculando la posición de la fuente en terminos de filas y columnas --

vdif_xq = abs(xq(1,:)-x_f);
vdif_zq = abs(zq(:,1)-z_f);
xq_jj = min(vdif_xq);
zq_ii = min(vdif_zq);

jj = find(vdif_xq == xq_jj,1);
ii = find(vdif_zq == zq_ii,1);

%--------------------------------------------------------------------------
fprintf(1, '\n*Tamaño de la malla= %i x %i\n', m, n);
fprintf(1, '\n*Nodo de la fuente (nodo i,j) en la malla = %i x %i\n\n', ii, jj);
fprintf(1, '*Coordenadas de la fuente: \n X: %f (%f) \n Z: %f (%f)', xq(1,jj), x_f, zq(ii,1), z_f);
fprintf(1, '\n\n*Características del área de estudio: \n Distancia:   %f - %f   (%f) \n Profundidad: %f - %f   (%f)\n\n', min_xq,  max_xq, max_xq - min_xq, min_zq, max_zq, max_zq - min_zq);

tic
[frst_arrivos, malla_tiempo, arr_tipo] = B_Programa_Control(vq, h, ii, jj, aproximacion);
tiempo_ejecucion = toc



E_Gen_Graficas(aproximacion, x_f, jj, z_f, ii, m, n, xq, zq, malla_tiempo, vq, frst_arrivos, arr_tipo, imprimir, unidades, clas_arch, name_arch)