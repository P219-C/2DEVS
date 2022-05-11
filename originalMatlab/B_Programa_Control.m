function [frst_arrivos_final, arr_t_final, arr_tipo_final] = B_Programa_Control(vq_aux, h, ii_aux, jj_aux, aproximacion)

%DIMENSIONES DE LA MALLA
[m_aux,n_aux]=size(vq_aux);

if (jj_aux == 1) || (ii_aux == 1) || (jj_aux == n_aux) || (ii_aux == m_aux)
    
    m = m_aux+2;
    n = n_aux+2;
    vq = -ones(m, n);
    vq(2:m-1, 2:n-1) = vq_aux;
    
    ii = ii_aux+1;  %Nueva posicion de la fuente
    jj = jj_aux+1;
    
    %Asignando valores de las nuevas fronteras
    vq(:,1) = vq(:,2);
    vq(:,n) = vq(:,n-1);
    vq(1,:) = vq(2,:);
    vq(m,:) = vq(m-1,:);
    
    flag_dim = 1;
    
else
    
    vq = vq_aux;
    ii = ii_aux;
    jj = jj_aux;
    m = m_aux;
    n = n_aux;
    
    flag_dim = 0;
    
end



%MATRIZ DE VELOCIDADES EXPRESADA COMO LENTITUDES
arr_vel=1./vq;

arr_t=-ones(m,n);
arr_tipo=zeros(m,n);

Rm_A=ii;     %Radio correspondiente a las filas Antes de la posicion de la fuente.
Rm_D=m-ii+1; %Radio correspondiente a las filas Despues de la posicion de la fuente.
Rn_A=jj;     %Radio correspondiente a las columnas Antes de la posicion de la fuente.
Rn_D=n-jj+1; %Radio correspondiente a las columnas Despues de la posicion de la fuente.

R_max=max([Rm_A Rm_D Rn_A Rn_D]);
R_min=min([Rm_A Rm_D Rn_A Rn_D]);

%pause

%------------ Proceso para calcular tiempos de la malla ----------------- 2
%ii
%jj

%m*n

arr_t(ii,jj)=0;   %Asignando el tiempo = 0 en la posicion de la fuente.
arr_tipo(ii,jj) = -1;
radio=1;

%CALCULANDO ANILLOS POSTERIORES
aux=1;
flag_lado=-ones(4,1);
flag_esquina=-ones(4,1);

radio=2;
acu_plano = 0;
while acu_plano == 0
    
    if radio == R_max
        acu_plano = 1;
    end
    
    %Proceso para saber que lados ya alcanzaron los límites de la matriz
    
    LDer=jj+radio-1;
    LSup=ii-radio+1;
    LIzq=jj-radio+1;
    LInf=ii+radio-1;
    
    if LDer > n;
        flag_lado(1,1)=0;
    else
        flag_lado(1,1)=1;
    end
    
    if LSup < 1;
        flag_lado(2,1)=0;
    else
        flag_lado(2,1)=1;
    end
    
    if LIzq < 1;
        flag_lado(3,1)=0;
    else
        flag_lado(3,1)=1;
    end
    
    if LInf > m;
        flag_lado(4,1)=0;
    else
        flag_lado(4,1)=1;
    end
    
    %--- Procesos para saber que esquinas se pueden calcular
    
    
    %Esquina superior derecha
    if (flag_lado(1,1) == 1) && (flag_lado(2,1) == 1);
        flag_esquina(1,1)=1;
    else
        flag_esquina(1,1)=0;
    end
    
    %Esquina superior izquierda
    if (flag_lado(2,1) == 1) && (flag_lado(3,1) == 1);
        flag_esquina(2,1)=1;
    else
        flag_esquina(2,1)=0;
    end
    
    %Esquina inferior izquierda
    if (flag_lado(3,1) == 1) && (flag_lado(4,1) == 1);
        flag_esquina(3,1)=1;
    else
        flag_esquina(3,1)=0;
    end
    
    %Esquina inferior derecha
    if (flag_lado(4,1) == 1) && (flag_lado(1,1) == 1);
        flag_esquina(4,1)=1;
    else
        flag_esquina(4,1)=0;
    end
    
    
    %--------------------- PROCESO PARA CALCULAR LADOS ------------------
    
    if flag_lado(1,1) == 1; %Lado Derecho
       
       %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
       if radio == 2
           arr_t(ii,jj+1)=(h/2)*(arr_vel(ii,jj+1)+arr_vel(ii,jj)); %VECINO DE LA FUENTE
           arr_tipo(ii,jj+1)=4;
       else
                      
           if flag_lado(4,1) == 1;           
               aa=ii+aux;       
           else               
               aa=m;       
           end
                     
           if flag_lado(2,1) == 1;           
               bb=ii-aux;       
           else               
               bb=1;       
           end
                 
           [arr_t(bb:aa,jj+radio-1),arr_tipo(bb:aa,jj+radio-1), acu_plano_l]=C_Func_Lado(arr_t(bb:aa,jj+radio-2), h, arr_vel(bb:aa,jj+radio-2), arr_vel(bb:aa,jj+radio-1), aproximacion) ;
            acu_plano = acu_plano + acu_plano_l;
       end
       
    end
    
    if flag_lado(2,1) == 1; %Lado Superior
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii-1,jj)=(h/2)*(arr_vel(ii-1,jj)+arr_vel(ii,jj));
            arr_tipo(ii-1,jj)=4;
        else
                       
            if flag_lado(1,1) == 1;           
                aa=jj+aux;        
            else                
                aa=n;        
            end
                        
            if flag_lado(3,1) == 1;            
                bb=jj-aux;        
            else               
                bb=1;       
            end
               
            [arr_t(ii-radio+1,bb:aa),arr_tipo(ii-radio+1,bb:aa), acu_plano_l]=C_Func_Lado(arr_t(ii-radio+2,bb:aa), h, arr_vel(ii-radio+2,bb:aa), arr_vel(ii-radio+1,bb:aa), aproximacion) ;
              acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if flag_lado(3,1) == 1; %Lado Izquierdo
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii,jj-1)=(h/2)*(arr_vel(ii,jj-1)+arr_vel(ii,jj));
            arr_tipo(ii,jj-1)=4;
        else
            
            if flag_lado(2,1) == 1;
                aa=ii-aux;
            else
                aa=1;
            end
        
            if flag_lado(4,1) == 1;
                bb=ii+aux;
            else
                bb=m;
            end
        
            [arr_t(aa:bb,jj-radio+1),arr_tipo(aa:bb,jj-radio+1), acu_plano_l]=C_Func_Lado(arr_t(aa:bb,jj-radio+2), h, arr_vel(aa:bb,jj-radio+2), arr_vel(aa:bb,jj-radio+1), aproximacion) ;
            acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if flag_lado(4,1) == 1; %Lado Inferior
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii+1,jj)=(h/2)*(arr_vel(ii+1,jj)+arr_vel(ii,jj));
            arr_tipo(ii+1,jj)=4;
        else
            
            if flag_lado(3,1) == 1;
                aa=jj-aux;
            else
                aa=1;
            end
        
            if flag_lado(1,1) == 1;
                bb=jj+aux;
            else
                bb=n;
            end
        
            [arr_t(ii+radio-1,aa:bb),arr_tipo(ii+radio-1,aa:bb), acu_plano_l]=C_Func_Lado(arr_t(ii+radio-2,aa:bb), h, arr_vel(ii+radio-2,aa:bb), arr_vel(ii+radio-1,aa:bb), aproximacion) ;
             acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    %----- PROCESO PARA CALCULAR ESQUINAS -----
    
    if flag_esquina(1,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii-1,jj+1),arr_tipo(ii-1,jj+1), acu_plano_l]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii,jj+1), arr_t(ii-1,jj), h, arr_vel(ii,jj), arr_vel(ii,jj+1), arr_vel(ii-1,jj), arr_vel(ii-1,jj+1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        else
            [arr_t(ii-radio+1,jj+radio-1),arr_tipo(ii-radio+1,jj+radio-1), acu_plano_l]=C_Func_Esquina(arr_t(ii-radio+2,jj+radio-2), arr_t(ii-radio+2,jj+radio-1), arr_t(ii-radio+1,jj+radio-2), h, arr_vel(ii-radio+2,jj+radio-2), arr_vel(ii-radio+2,jj+radio-1), arr_vel(ii-radio+1,jj+radio-2), arr_vel(ii-radio+1,jj+radio-1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if flag_esquina(2,1) == 1;
        
        %CONDICIONAL POR SI ELANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii-1,jj-1),arr_tipo(ii-1,jj-1), acu_plano_l]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii-1,jj), arr_t(ii,jj-1), h, arr_vel(ii,jj), arr_vel(ii-1,jj), arr_vel(ii,jj-1), arr_vel(ii-1,jj-1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        else
            [arr_t(ii-radio+1,jj-radio+1),arr_tipo(ii-radio+1,jj-radio+1), acu_plano_l]=C_Func_Esquina(arr_t(ii-radio+2,jj-radio+2), arr_t(ii-radio+1,jj-radio+2), arr_t(ii-radio+2,jj-radio+1), h, arr_vel(ii-radio+2,jj-radio+2), arr_vel(ii-radio+1,jj-radio+2), arr_vel(ii-radio+2,jj-radio+1), arr_vel(ii-radio+1,jj-radio+1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if flag_esquina(3,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii+1,jj-1),arr_tipo(ii+1,jj-1), acu_plano_l]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii,jj-1), arr_t(ii+1,jj), h, arr_vel(ii,jj), arr_vel(ii,jj-1), arr_vel(ii+1,jj), arr_vel(ii+1,jj-1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        else
            [arr_t(ii+radio-1,jj-radio+1),arr_tipo(ii+radio-1,jj-radio+1), acu_plano_l]=C_Func_Esquina(arr_t(ii+radio-2,jj-radio+2), arr_t(ii+radio-2,jj-radio+1), arr_t(ii+radio-1,jj-radio+2), h, arr_vel(ii+radio-2,jj-radio+2), arr_vel(ii+radio-2,jj-radio+1), arr_vel(ii+radio-1,jj-radio+2), arr_vel(ii+radio-1,jj-radio+1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if flag_esquina(4,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii+1,jj+1),arr_tipo(ii+1,jj+1), acu_plano_l]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii+1,jj), arr_t(ii,jj+1), h, arr_vel(ii,jj), arr_vel(ii+1,jj), arr_vel(ii,jj+1), arr_vel(ii+1,jj+1), aproximacion);   %Revisar indices de estas expresiones
            acu_plano = acu_plano + acu_plano_l;
        else
            [arr_t(ii+radio-1,jj+radio-1),arr_tipo(ii+radio-1,jj+radio-1), acu_plano_l]=C_Func_Esquina(arr_t(ii+radio-2,jj+radio-2), arr_t(ii+radio-1,jj+radio-2), arr_t(ii+radio-2,jj+radio-1), h, arr_vel(ii+radio-2,jj+radio-2), arr_vel(ii+radio-1,jj+radio-2), arr_vel(ii+radio-2,jj+radio-1), arr_vel(ii+radio-1,jj+radio-1), aproximacion);
            acu_plano = acu_plano + acu_plano_l;
        end
        
    end
    
    if ne(radio,2)
        aux=aux+1;
    end
    
    %radio
    
    radio=radio+1;
    
end

radio_aux = radio;

aproximacion = 1;
for radio=radio_aux : R_max
    
    %Proceso para saber que lados ya alcanzaron los límites de la matriz
    
    LDer=jj+radio-1;
    LSup=ii-radio+1;
    LIzq=jj-radio+1;
    LInf=ii+radio-1;
    
    if LDer > n;
        flag_lado(1,1)=0;
    else
        flag_lado(1,1)=1;
    end
    
    if LSup < 1;
        flag_lado(2,1)=0;
    else
        flag_lado(2,1)=1;
    end
    
    if LIzq < 1;
        flag_lado(3,1)=0;
    else
        flag_lado(3,1)=1;
    end
    
    if LInf > m;
        flag_lado(4,1)=0;
    else
        flag_lado(4,1)=1;
    end
    
    %--- Procesos para saber que esquinas se pueden calcular
    
    
    %Esquina superior derecha
    if (flag_lado(1,1) == 1) && (flag_lado(2,1) == 1);
        flag_esquina(1,1)=1;
    else
        flag_esquina(1,1)=0;
    end
    
    %Esquina superior izquierda
    if (flag_lado(2,1) == 1) && (flag_lado(3,1) == 1);
        flag_esquina(2,1)=1;
    else
        flag_esquina(2,1)=0;
    end
    
    %Esquina inferior izquierda
    if (flag_lado(3,1) == 1) && (flag_lado(4,1) == 1);
        flag_esquina(3,1)=1;
    else
        flag_esquina(3,1)=0;
    end
    
    %Esquina inferior derecha
    if (flag_lado(4,1) == 1) && (flag_lado(1,1) == 1);
        flag_esquina(4,1)=1;
    else
        flag_esquina(4,1)=0;
    end
    
    
    %--------------------- PROCESO PARA CALCULAR LADOS ------------------
    
    if flag_lado(1,1) == 1; %Lado Derecho
       
       %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
       if radio == 2
           arr_t(ii,jj+1)=(h/2)*(arr_vel(ii,jj+1)+arr_vel(ii,jj)); %VECINO DE LA FUENTE
           arr_tipo(ii,jj+1)=4;
       else
                      
           if flag_lado(4,1) == 1;           
               aa=ii+aux;       
           else               
               aa=m;       
           end
                     
           if flag_lado(2,1) == 1;           
               bb=ii-aux;       
           else               
               bb=1;       
           end
                 
           [arr_t(bb:aa,jj+radio-1),arr_tipo(bb:aa,jj+radio-1), ~]=C_Func_Lado(arr_t(bb:aa,jj+radio-2), h, arr_vel(bb:aa,jj+radio-2), arr_vel(bb:aa,jj+radio-1), aproximacion) ;
       
       end
       
    end
    
    if flag_lado(2,1) == 1; %Lado Superior
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii-1,jj)=(h/2)*(arr_vel(ii-1,jj)+arr_vel(ii,jj));
            arr_tipo(ii-1,jj)=4;
        else
                       
            if flag_lado(1,1) == 1;           
                aa=jj+aux;        
            else                
                aa=n;        
            end
                        
            if flag_lado(3,1) == 1;            
                bb=jj-aux;        
            else               
                bb=1;       
            end
               
            [arr_t(ii-radio+1,bb:aa),arr_tipo(ii-radio+1,bb:aa), ~]=C_Func_Lado(arr_t(ii-radio+2,bb:aa), h, arr_vel(ii-radio+2,bb:aa), arr_vel(ii-radio+1,bb:aa), aproximacion) ;
        
        end
        
    end
    
    if flag_lado(3,1) == 1; %Lado Izquierdo
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii,jj-1)=(h/2)*(arr_vel(ii,jj-1)+arr_vel(ii,jj));
            arr_tipo(ii,jj-1)=4;
        else
            
            if flag_lado(2,1) == 1;
                aa=ii-aux;
            else
                aa=1;
            end
        
            if flag_lado(4,1) == 1;
                bb=ii+aux;
            else
                bb=m;
            end
        
            [arr_t(aa:bb,jj-radio+1),arr_tipo(aa:bb,jj-radio+1), ~]=C_Func_Lado(arr_t(aa:bb,jj-radio+2), h, arr_vel(aa:bb,jj-radio+2), arr_vel(aa:bb,jj-radio+1), aproximacion) ;
        
        end
        
    end
    
    if flag_lado(4,1) == 1; %Lado Inferior
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            arr_t(ii+1,jj)=(h/2)*(arr_vel(ii+1,jj)+arr_vel(ii,jj));
            arr_tipo(ii+1,jj)=4;
        else
            
            if flag_lado(3,1) == 1;
                aa=jj-aux;
            else
                aa=1;
            end
        
            if flag_lado(1,1) == 1;
                bb=jj+aux;
            else
                bb=n;
            end
        
            [arr_t(ii+radio-1,aa:bb),arr_tipo(ii+radio-1,aa:bb), ~]=C_Func_Lado(arr_t(ii+radio-2,aa:bb), h, arr_vel(ii+radio-2,aa:bb), arr_vel(ii+radio-1,aa:bb), aproximacion) ;
        
        end
        
    end
    
    %----- PROCESO PARA CALCULAR ESQUINAS -----
    
    if flag_esquina(1,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii-1,jj+1),arr_tipo(ii-1,jj+1), ~]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii,jj+1), arr_t(ii-1,jj), h, arr_vel(ii,jj), arr_vel(ii,jj+1), arr_vel(ii-1,jj), arr_vel(ii-1,jj+1), aproximacion);
        else
            [arr_t(ii-radio+1,jj+radio-1),arr_tipo(ii-radio+1,jj+radio-1), ~]=C_Func_Esquina(arr_t(ii-radio+2,jj+radio-2), arr_t(ii-radio+2,jj+radio-1), arr_t(ii-radio+1,jj+radio-2), h, arr_vel(ii-radio+2,jj+radio-2), arr_vel(ii-radio+2,jj+radio-1), arr_vel(ii-radio+1,jj+radio-2), arr_vel(ii-radio+1,jj+radio-1), aproximacion);
        end
        
    end
    
    if flag_esquina(2,1) == 1;
        
        %CONDICIONAL POR SI ELANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii-1,jj-1),arr_tipo(ii-1,jj-1), ~]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii-1,jj), arr_t(ii,jj-1), h, arr_vel(ii,jj), arr_vel(ii-1,jj), arr_vel(ii,jj-1), arr_vel(ii-1,jj-1), aproximacion);
        else
            [arr_t(ii-radio+1,jj-radio+1),arr_tipo(ii-radio+1,jj-radio+1), ~]=C_Func_Esquina(arr_t(ii-radio+2,jj-radio+2), arr_t(ii-radio+1,jj-radio+2), arr_t(ii-radio+2,jj-radio+1), h, arr_vel(ii-radio+2,jj-radio+2), arr_vel(ii-radio+1,jj-radio+2), arr_vel(ii-radio+2,jj-radio+1), arr_vel(ii-radio+1,jj-radio+1), aproximacion);
        end
        
    end
    
    if flag_esquina(3,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii+1,jj-1),arr_tipo(ii+1,jj-1), ~]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii,jj-1), arr_t(ii+1,jj), h, arr_vel(ii,jj), arr_vel(ii,jj-1), arr_vel(ii+1,jj), arr_vel(ii+1,jj-1), aproximacion);
        else
            [arr_t(ii+radio-1,jj-radio+1),arr_tipo(ii+radio-1,jj-radio+1), ~]=C_Func_Esquina(arr_t(ii+radio-2,jj-radio+2), arr_t(ii+radio-2,jj-radio+1), arr_t(ii+radio-1,jj-radio+2), h, arr_vel(ii+radio-2,jj-radio+2), arr_vel(ii+radio-2,jj-radio+1), arr_vel(ii+radio-1,jj-radio+2), arr_vel(ii+radio-1,jj-radio+1), aproximacion);
        end
        
    end
    
    if flag_esquina(4,1) == 1;
        
        %CONDICIONAL POR SI EL ANILLO A CALCULAR ES EL DE RADIO 2
        if radio == 2
            [arr_t(ii+1,jj+1),arr_tipo(ii+1,jj+1), ~]=C_Func_Esquina(arr_t(ii,jj), arr_t(ii+1,jj), arr_t(ii,jj+1), h, arr_vel(ii,jj), arr_vel(ii+1,jj), arr_vel(ii,jj+1), arr_vel(ii+1,jj+1), aproximacion);   %Revisar indices de estas expresiones
        else
            [arr_t(ii+radio-1,jj+radio-1),arr_tipo(ii+radio-1,jj+radio-1), ~]=C_Func_Esquina(arr_t(ii+radio-2,jj+radio-2), arr_t(ii+radio-1,jj+radio-2), arr_t(ii+radio-2,jj+radio-1), h, arr_vel(ii+radio-2,jj+radio-2), arr_vel(ii+radio-1,jj+radio-2), arr_vel(ii+radio-2,jj+radio-1), arr_vel(ii+radio-1,jj+radio-1), aproximacion);
        end
        
    end
    
    if ne(radio,2)
        aux=aux+1;
    end
    
    %radio
    
end

    if flag_dim == 1
        
        arr_t_final = arr_t(2:m-1, 2:n-1);
        arr_tipo_final = arr_tipo(2:m-1,2:n-1);
        frst_arrivos_final = arr_t_final(1,:);
        
    else
        
        arr_t_final = arr_t;
        arr_tipo_final = arr_tipo;
        frst_arrivos_final = arr_t_final(1,:);
        
    end

end