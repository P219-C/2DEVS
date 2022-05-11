function [lado,lado_tipo,acu_plano] = C_Func_Lado(lado_interior, h, s_interior, s_exterior, aproximacion) %s_vec interior y exterior
                                                           %(#vector con el lado del anillo interior a calcular, radio, numero de lado)


tam_LI=length(lado_interior); %tamano del Lado Interior. 
                              %El tamano del lado interior corresponde al tamano del lado exterior sin contar las esquinas del anillo

lado_exterior=-ones(tam_LI,1);
lado_tipo=zeros(tam_LI,1);
flag_min=zeros(tam_LI,2);
flag_max=zeros(tam_LI,2);
acu_plano = 0;

%----- PROCESO DE ASIGNACION DE MINIMOS Y MAXIMOS -----
cont_min=1;
cont_max=1;
if (lado_interior(1) < lado_interior(2));
    
    flag_min(1,1)=1;
    flag_min(1,2)=cont_min;
    cont_min=cont_min+1;
    
else
    
    flag_max(1,1)=1;
    flag_max(1,2)=cont_max;
    cont_max=cont_max+1;
    
end


for ii=2:tam_LI-1
   
    if (lado_interior(ii) < lado_interior(ii-1)) && (lado_interior(ii) < lado_interior(ii+1));
        
        flag_min(ii,1)=1;
        flag_min(ii,2)=cont_min;
        cont_min=cont_min+1;
            
    end
    
    if (lado_interior(ii) > lado_interior(ii-1)) && (lado_interior(ii) > lado_interior(ii+1));  %NOTA: Posiblemente juntar estos dos if's con un else if
        
        flag_max(ii,1)=1;
        flag_max(ii,2)=cont_max;
        cont_max=cont_max+1;
            
    end
    
end

if (lado_interior(tam_LI) < lado_interior(tam_LI-1));
    
    flag_min(tam_LI,1)=1;
    flag_min(tam_LI,2)=cont_min;
    
else
    
    flag_max(tam_LI,1)=1;
    flag_max(tam_LI,2)=cont_max;
    
end
%----------------------------------------------------
tot_min=sum(flag_min(:,1));
tot_max=sum(flag_max(:,1));

%info_max es una matriz de -1 con dimensiones tot_max x 4, lo que quiere decir que tiene tantas filas como maximos hay y 4 columnas en las que
%se compararan los maximos obtenidos al calcular los tiempos en el anillo a la derecha y a la izquierda así como la posicion que les corresponde
%en el anillo exterior. La primer columna corresponderá para la posicion en el anillo del maximo obtenido hacia la derecha y la segunda columna
% para ese maximo obtenido. La tercer columna guardara los maximos obtenidos hacia la izquierda y la cuarta columna la posicion de este maximo.
%Con esto se pretende observar que tanto la primer columna como la cuarta tengan el mismo valor ya que ambos representan a los maximos obtenidos
%en la misma posicion. Servirá para efecto de control
%La matriz se llena de 999 para efecto de llevar un control y ver que la matriz se llena correctamente. En algunas ocasiones es posible que solo
%haya un maximo por fila. Se utiliza 999 ya que es un numero muy grande para los resultados que se esperan obtener y no se consideraría un tiempo
%correcto (POSIBLEMENTE CAMBIAR)

info_max=999*ones(tot_max,4);

    
%Ciclo para calcular el valor de todos los minimos relativos    
for ii=1:tam_LI
            
    if flag_min(ii,1) == 1;
              
        if (ii == 1); %Condicion por si el minimo relativo esta en el extremo izquierdo
                  
            t_0 = lado_interior(ii);   
            t_1 = lado_interior(ii+1);
            s_0 = s_interior(ii);
            s_1 = s_interior(ii+1);
            s_2 = s_exterior(ii);
                  
            s_prom = (s_0 + s_1 + s_2) / 3;
            t_2 = t_0 + sqrt( (h * s_prom)^2 - (t_0 - t_1)^2);
            
            lado_exterior(ii) = t_2;
            lado_tipo(ii) = 2;
            
        elseif (ii == tam_LI); %Condicion por si el minimo esta en el extremo derecho
               
            t_0 = lado_interior(ii);
            t_1 = lado_interior(ii-1);
            s_0 = s_interior(ii);
            s_1 = s_interior(ii-1);
            s_2 = s_exterior(ii);
               
            s_prom = (s_0 + s_1 + s_2) / 3;
            t_2 = t_0 + sqrt( (h * s_prom)^2 - (t_0 - t_1)^2);
            
            lado_exterior(ii) = t_2;
            lado_tipo(ii) = 2;
           
        else %Condicion para los demas minimos
                             
            t_0 = lado_interior(ii);               
            t_1 = lado_interior(ii-1);
            t_2 = lado_interior(ii+1);
            s_0 = s_interior(ii);
            s_1 = s_interior(ii-1);
            s_2 = s_interior(ii+1);
            s_3 = s_exterior(ii);
               
            s_prom = (s_0 + s_1 + s_2 + s_3) / 4;   
            t_3 = t_0 + sqrt( (h * s_prom)^2 -0.25*( t_2 - t_1)^2 );
            
            lado_exterior(ii) = t_3;
            lado_tipo(ii) = 3;
               
        end
                
    end
        
end
%lado_exterior
%tot_min;

%Proceso para calcular el lado de un anillo!!!!!!!!!!!!    
%REVISAR!!!!!!****************
for i_min=1:tot_min  %i_min es el contador para saber que mínimo estamos trabajando
           
    %Haciendo los calculos de izquierda a derecha (hacia la derecha)        
    for ii=1:tam_LI
                                              
        if flag_min(ii,2) == i_min
            
            if (ii == tam_LI)               
                %NO SE REALIZA NINGUN CALCULO
            else
                
                cont_aux=1;                            
                while ne(flag_max(ii+cont_aux,1),1); %Mientras el punto que vamos a calcular no sea un maximo, este ciclo se cumplirá               
                
                    t_0 = lado_interior(ii+cont_aux-1);               
                    t_1 = lado_interior(ii+cont_aux);               
                    t_2 = lado_exterior(ii+cont_aux-1);                
                    s_0 = s_interior(ii+cont_aux-1);                
                    s_1 = s_interior(ii+cont_aux);                
                    s_2 = s_exterior(ii+cont_aux-1);                
                    s_3 = s_exterior(ii+cont_aux);
                                                
                    [t_3,flag_esferico, flag_plano] = C_Func_Esquina(t_0, t_1, t_2, h, s_0, s_1, s_2, s_3, aproximacion);               
                    lado_exterior(ii+cont_aux) = t_3;
                    lado_tipo(ii+cont_aux) = flag_esferico;
                    acu_plano = acu_plano + flag_plano;
                    
                    cont_aux=cont_aux+1;
                                            
                end
                                
                %Cuando el siguiente punto que hay que calcular es un maximo, el ciclo while termina y el punto del maximo se calcula aparte            
                %para que este sea guardado en un vector independiente y asi compararlo con el resultado obtenido de hacer el analisis hacia la izquierda            
            
                t_0 = lado_interior(ii+cont_aux-1);            
                t_1 = lado_interior(ii+cont_aux);            
                t_2 = lado_exterior(ii+cont_aux-1);            
                s_0 = s_interior(ii+cont_aux-1);            
                s_1 = s_interior(ii+cont_aux);            
                s_2 = s_exterior(ii+cont_aux-1);            
                s_3 = s_exterior(ii+cont_aux);
                          
                [t_3,flag_esferico, flag_plano] = C_Func_Esquina(t_0, t_1, t_2, h, s_0, s_1, s_2, s_3, aproximacion);
                lado_tipo(ii+cont_aux) = flag_esferico;
                acu_plano = acu_plano + flag_plano;
                
                %info_max es la matriz que guardara los maximos obtenidos tanto hacia la derecha como hacia la izquierda para compararlos
                info_max(flag_max(ii+cont_aux,2),2) = t_3;            
                info_max(flag_max(ii+cont_aux,2),1) = ii+cont_aux;
            end                           
        end               
    end
    
    %haciendo los calculos de derecha a izquierda (hacia la izquierda)        
    for jj=tam_LI:-1:1
                                 
        if flag_min(jj,2) == i_min
             
            if (jj == 1)                               
            %NO SE REALIZA NINGUN CALCULO
            
            else               
                cont_aux=1;
                           
                while ne(flag_max(jj-cont_aux,1),1); %Mientras el punto que vamos a calcular no sea un maximo, este ciclo se cumplirá
                                             
                    t_0 = lado_interior(jj-cont_aux+1);                
                    t_1 = lado_interior(jj-cont_aux);               
                    t_2 = lado_exterior(jj-cont_aux+1);                
                    s_0 = s_interior(jj-cont_aux+1);                
                    s_1 = s_interior(jj-cont_aux);                
                    s_2 = s_exterior(jj-cont_aux+1);                
                    s_3 = s_exterior(jj-cont_aux);
                                
                    [t_3,flag_esferico, flag_plano] = C_Func_Esquina(t_0, t_1, t_2, h, s_0, s_1, s_2, s_3, aproximacion);                
                    lado_exterior(jj-cont_aux) = t_3;
                    lado_tipo(jj-cont_aux) = flag_esferico;
                    acu_plano = acu_plano + flag_plano;
                    
                    cont_aux = cont_aux+1;
                  
                end
                                
                %Cuando el siguiente punto que hay que calcular es un maximo, el ciclo while termina y el punto del maximo se calcula aparte            
                %para que este sea guardado en un vector independiente y asi compararlo con el resultado obtenido de hacer el analisis hacia la izquierda                          
                t_0 = lado_interior(jj-cont_aux+1);                            
                t_1 = lado_interior(jj-cont_aux);                            
                t_2 = lado_exterior(jj-cont_aux+1);            
                s_0 = s_interior(jj-cont_aux+1);                            
                s_1 = s_interior(jj-cont_aux);                            
                s_2 = s_exterior(jj-cont_aux+1);            
                s_3 = s_exterior(jj-cont_aux);
                          
                [t_3,flag_esferico, flag_plano]=C_Func_Esquina(t_0, t_1, t_2, h, s_0, s_1, s_2, s_3, aproximacion);
                lado_tipo(jj-cont_aux) = flag_esferico;
                acu_plano = acu_plano + flag_plano;
                
                %info_max es la matriz que guardara los maximos obtenidos tanto hacia la derecha como hacia la izquierda para compararlos                            
                info_max(flag_max(jj-cont_aux,2),3) = t_3;                            
                info_max(flag_max(jj-cont_aux,2),4) = jj-cont_aux;
            end
        end         
    end
    
end
    
%info_max
%Proceso para escoger el tiempo correcto de los maximos. Este tiempo debe de ser el menor de los dos en el caso de que hayan dos maximos.
for ii=1:tot_max
    
    if (info_max(ii,2) < info_max(ii,3));
        
        lado_exterior(info_max(ii,1))=info_max(ii,2);
        
    else
        
        lado_exterior(info_max(ii,4))=info_max(ii,3);
           
    end
    
end

lado=lado_exterior;

end