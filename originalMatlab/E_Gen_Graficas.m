function E_Gen_Graficas(aproximacion, x_f, n_j, z_f, n_i, m, n, xq, zq, malla_tiempo, vq, frst_arrivos, arr_tipo, imprimir, unidades, clas_arch, name_arch)

if (aproximacion == 1)   
    titulo_frente = 'Esquema "simple" (tiempo[s])';
else
    titulo_frente = 'Esquema "mixto" (tiempo [s])';
end

if max(max(xq)) > max(max(zq))
    position='southoutside';
else
    position='eastoutside';
end


figure(1)
hold on
contour(xq,zq,malla_tiempo,'DisplayName','t calc')
hold on
plot3(x_f,z_f,1,'xr','DisplayName','fuente')   %Posicion de la fuente
axis equal
axis ij
title(titulo_frente)
xlabel(['Longitud [', unidades,']'])
ylabel(['Profundidad [',unidades,']'])
cb = colorbar(position);
cb.Label.String = 'Tiempo [s]';
%legend('show')

figure(2)
hold on
contourf(xq,zq,vq,'DisplayName','vel')
hold on
plot3(x_f,z_f,1,'xr','DisplayName','fuente')   %Posicion de la fuente
axis equal
axis ij
title(['Campo de velocidades [', unidades, '/s]'])
xlabel(['Longitud [', unidades,']'])
ylabel(['Profundidad [', unidades, ']'])
cb = colorbar(position);
cb.Label.String = ['Velocidad [', unidades, '/s]'];
%legend('show')

figure(3)
%subplot(2,2,3:4)
hold on
plot(xq(1,:),frst_arrivos,'DisplayName','1ros arrivos')
%plot(228,35,'or')
title('Tiempos de arribo en la superficie [s]')
xlabel(['Longitud [', unidades, ']'])
ylabel('Tiempo [s]')
%legend('show')


figure(4)
%contour(xq,zq,malla_tiempo, 10,'r','ShowText','on','DisplayName','t calc');
contour(xq,zq,malla_tiempo, 'DisplayName','t calc');
caxis([min(min(malla_tiempo)) max(max(malla_tiempo))])
hold on
contour(xq,zq,vq,'DisplayName','vel.');
plot3(x_f,z_f,1,'xr','DisplayName','fuente')   %Posicion de la fuente
axis equal
axis ij
title('Grafica Completa')
xlabel(['Longitud [', unidades, ']'])
ylabel([' Profundidad [', unidades, ']'])
cb = colorbar(position);
cb.Label.String = 'Tiempo [s]';
%legend('show')

%
[Bn, ~] = size(find(arr_tipo == 4));    %# de Vecinos de la fuente
[P_Esf, ~] = size(find(arr_tipo == 1)); %# de puntos aproximados con frente de onda esferico
[mr_E, ~] = size(find(arr_tipo == 2));  %# de minimos relativos en los extremos
[mr_I, ~] = size(find(arr_tipo == 3));  %# de minimos relativos interiores

V_Bn = ones(Bn,3);          %Vecinos de la fuente
V_P_Esf = ones(P_Esf,3);    %Puntos con frente de onda esferico
V_mr_E = ones(mr_E,3);      %Minimo relativo en los extremos
V_mr_I = ones(mr_I,3);      %Minimo relativo interior

cont_Bn = 1;
cont_P_Esf = 1;
cont_mr_E = 1;
cont_mr_I = 1;

for ii = 1: m
    for jj = 1: n
        
        if arr_tipo(ii,jj) == 4;
            
            V_Bn(cont_Bn,1:2) = [xq(1,jj) zq(ii,1)];
            cont_Bn = cont_Bn + 1;
            
        elseif arr_tipo(ii,jj) == 1;
            
            V_P_Esf(cont_P_Esf,1:2) = [xq(1,jj) zq(ii,1)];
            cont_P_Esf = cont_P_Esf + 1;
            
        elseif arr_tipo(ii,jj) == 2;
            
            V_mr_E(cont_mr_E,1:2) = [xq(1,jj) zq(ii,1)];
            cont_mr_E = cont_mr_E + 1;
            
        elseif arr_tipo(ii,jj) == 3;
            
            V_mr_I(cont_mr_I,1:2) = [xq(1,jj) zq(ii,1)];
            cont_mr_I = cont_mr_I + 1;
        
        end
        
    end
end


figure(5)
contourf(xq,zq,vq,'DisplayName','vel.')
hold on
contour(xq,zq,malla_tiempo,'DisplayName','t calc')
plot3(x_f,z_f,1,'xr','DisplayName','fuente')   %Posicion de la fuente
plot3(xq(1,n_j),zq(n_i,1),1,'sr','DisplayName','fuente real')   %Posicion real de la fuente
plot3(V_Bn(:,1),V_Bn(:,2),V_Bn(:,3),'oy','DisplayName','Vecinos de la fuente')   %Vecinos de la fuente
plot3(V_P_Esf(:,1),V_P_Esf(:,2),V_P_Esf(:,3),'xg','DisplayName','Puntos esfericos') %Puntos aproximados con frente de onda esferico
plot3(V_mr_E(:,1),V_mr_E(:,2),V_mr_E(:,3),'+r','DisplayName','Minimos relativos en los extremos') %Minmos relativos en los extremos
plot3(V_mr_I(:,1),V_mr_I(:,2),V_mr_I(:,3),'+c','DisplayName','Minimos relativos interiores') %Minimos relativos interiores
axis equal
axis ij
title('Grafica Completa')
xlabel(['Longitud [', unidades, ']'])
ylabel([' Profundidad [', unidades, ']'])
%cb = colorbar(position);
cb.Label.String = 'Tiempo [s]';
%legend('show')
%

if imprimir == 1

    figure(1);
    set(gca,'fontsize',16)
    print(clas_arch, ['IMG_',name_arch,'_matT'])

    figure(2);
    set(gca,'fontsize',16)
    print(clas_arch, ['IMG_',name_arch,'_estV'])

    figure(3);
    set(gca,'fontsize',16)
    print(clas_arch, ['IMG_',name_arch,'_arrS'])
    %print -depsc 1_1rst_arr

    figure(4);
    set(gca,'fontsize',16)
    print(clas_arch, ['IMG_',name_arch,'_matTestV'])

    figure(5);
    set(gca,'fontsize',16)
    print(clas_arch, ['IMG_',name_arch,'_infoC'])
    
end

end