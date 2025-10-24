save_format='png';
function plot_function_with_respect_to_time(T,t,f,name)
    intvl = [round(t(1)) round(t(length(t)))];
    x = linspace(0,T);
    pft = repmat(f(x),1,diff(intvl)/T);
    pt = linspace(intvl(1),intvl(2),length(pft));
    plot_trig_fourier_series(pt,pft,name);
end
function plot_trig_fourier_series(t,fs,name) 
    %%Plot Fouerier Series versus time
    figure;
    plot(t,fs,'-','LineWidth',3,'Color','black');
    xlabel('time (s)');
    ylabel('amplitude');
    ylim([min(min(fs)-0.2,0),max(fs)+0.2])
    grid(true);
    title('Signal versus Time');
    zoom xon;
    saveas(gcf,append(name,"_series"),'svg');
end
function plot_trig_fourier_magnitude_specta(ws,ms,name)
    %%Plot Magnitude spectrum Series versus angular frequency
    figure;
    %plot(ws,ms,'-o','LineWidth',3,'Color','black');
    plt = stem(ws,ms);
    plt.LineWidth = 3;
    plt.Color = 'black';
    xlabel('angular frequency (wo)');
    ylabel('Magnitude (Cn)');
    ylim([min(min(ms)-0.2,0),max(ms)+0.2])
    grid(true);
    title('Magnitude spectrum vs angular frequency');
    zoom xon;
    saveas(gcf,append(name,"_magnitude_spectra"),'svg');
end 
function plot_trig_fourier_phase_spectra(ws,ps,name)
    %%Plot Phase spectrum Series versus angular frequency
    figure;
    %plot(ws,ps,'-o','MarkerFaceColor','black', ...
    %    'LineWidth',3,'Color','black');
    plt = stem(ws,ps);
    plt.LineWidth = 3;
    plt.Color = 'black';
    xlabel('Angular frequency (wo)');
    ylabel('Phase (\theta_n)');
    ylim([min(min(ps)-0.2,0),max(max(ps)+0.2,0)])
    grid(true);
    title('Phase spectrum vs angular frequency');
    zoom xon;
    saveas(gcf,append(name,"_phase_spectra"),'svg');
end
function plot_TEK_csv(path,name)
    %s = append("./csv/TEK0000",string(k),".CSV");
    csv_data = readtable(path);
    tbl = renamevars(csv_data,["Var1", "Var2"], ...
        ["Time", "Voltage"] ...
    );
    figure;
    tbl(:,2) = tbl(:,2)+abs(min(min(tbl(:,2),0)));
    plot(tbl,'Time','Voltage',"Color",'black', ...
        'LineWidth',2 ...
    );
    saveas(gcf,name,'svg');
end

%%Calculate fourier series, magnitude spectrum 
%%and phase spectrum
function [ws, ps, ms, fs] = trig_fourier_series( ...
    T,x,n,t,zero_edge_case ...
)
    %%calculate angular frequency
    wo = ((2.*pi)/T);

    %%Get all even component coefficients
    function a = even_cof(T,wo,x,n)
        ft = @(t) x(t).*cos(n.*wo.*t);
        a = round( (2/T).*integral(@(t) ft(t), 0, T), 10);
    end

    %%Get all odd component coefficients
    function b = odd_cof(T,wo,x,n)
        ft = @(t) x(t).*sin(n.*wo.*t);
        b = round( (2/T)*integral(@(t) ft(t), 0, T),10);
    end
    
    %%Calculate all coefficients
    a0 = (1/T)*integral(@(t) x(t),0,T);
    an = zeros(1,n);
    bn = zeros(1,n);

    for i = 1:n
        an(i) = even_cof(T, wo, x, i);
        bn(i) = odd_cof(T, wo, x, i);
    end
    
    %%summ all cofficients and components
    function fs = sum_components(n,a0,an,bn,wo,t)
        fs = a0;
        for i = 1:n
            fs = fs + an(i) * cos(i * wo * t) + bn(i) ...
            * sin(i * wo * t);
        end
    end

    %%Calculate magnitude spectrum
    function [ws_r, ms_r, ps_r] = calc_spectra( ...
            n,wo,an,bn,zero_edge_case ...
    )
        ws_r = zeros(1,n);
        ms_r = zeros(1,n);
        ps_r = zeros(1,n);
        for i = 1:n
            ws_r(i) = wo*i;
            ms_r(i) = sqrt((an(i).^2) + (bn(i).^2));
            ps_r(i) = atan2(-bn(i),an(i));
            if ps_r(i) == 0 && zero_edge_case == true && an(i) == 0
                ps_r(i) = -pi/2;
            end
                    
        end
    end
    fs = sum_components(n, a0, an, bn,wo,t);
    [ws,ms,ps] = calc_spectra(n,wo,an,bn,zero_edge_case);
end

function calc_plot_and_save_functions(T,t,n,fQ1,fQ2,fQ3,fQ4)
    for i = 1:4
        [ws, ps, ms, fs] = trig_fourier_series( ...
            T, fQ1, n(i), t, true ...
        );
        plot_trig_fourier_series(t,fs, ...
            append("./Report/figures/SinWave_c", ...
            string(n(i))) ...
        );
        if i == length(n)
        plot_trig_fourier_magnitude_specta(ws,ms, ...
            append("./Report/figures/SinWave_c", ...
            string(n(i))) ...
        );
        plot_trig_fourier_phase_spectra(ws,ps, ...
            append("./Report/figures/SinWave_c", ...
            string(n(i))) ...
        );
        end
    end
    for i = 1:4
        [ws, ps, ms, fs] = trig_fourier_series( ...
            T, fQ2, n(i), t, true ...
        );
        plot_trig_fourier_series(t,fs, ...
            append("./Report/figures/SquareWave_50%_c", ...
            string(n(i))) ...
        );
        if i == length(n)
        plot_trig_fourier_magnitude_specta(ws,ms, ...
            append("./Report/figures/SquareWave_50%_c", ...
            string(n(i))) ...
        );
        plot_trig_fourier_phase_spectra(ws,ps, ...
            append("./Report/figures/SquareWave_50%_c", ...
            string(n(i))) ...
        );
        end
    end
    for i = 1:4
        [ws, ps, ms, fs] = trig_fourier_series( ...
            T, fQ3, n(i), t, false ...
        );
        plot_trig_fourier_series(t,fs, ...
            append("./Report/figures/SquareWave_10%_c", ...
            string(n(i))) ...
        );
        if i == length(n)
        plot_trig_fourier_magnitude_specta(ws,ms, ...
            append("./Report/figures/SquareWave_10%_c", ...
            string(n(i))) ...
        );
        plot_trig_fourier_phase_spectra(ws,ps, ...
            append("./Report/figures/SquareWave_10%_c", ...
            string(n(i))) ...
        );
        end
    end
    for i = 1:4
        [ws, ps, ms, fs] = trig_fourier_series( ...
            T, fQ4, n(i), t, false ...
        );
        plot_trig_fourier_series(t,fs, ...
            append("./Report/figures/SawtoothWave_c", ...
            string(n(i))) ...
        );
        if i == length(n)
        plot_trig_fourier_magnitude_specta(ws,ms, ...
            append("./Report/figures/SawtoothWave_c", ...
            string(n(i))) ...
        );
        plot_trig_fourier_phase_spectra(ws,ps, ...
            append("./Report/figures/SawtoothWave_c", ...
            string(n(i))) ...
        );
        end
    end
end

%%Time spec
sps = 8000;
dt = 1/sps;
StopTime = 2;
t = (-2:dt:StopTime-dt);
    
%%Function Properties
T = 1;
n = [1,2,5,10];
fQ1 = @(t) sin(2*pi*t);
fQ2 = @(t) (t < 0.5) .* (1) + (t >= 0.5) .* (-1);
fQ3 = @(t) (t < 0.1) .* (1) + (t >= 0.1) .* (-1);
fQ4 = @(t) (t <= 1) .* (t);

plot_function_with_respect_to_time(T,t,fQ1, ...
    "./Report/figures/SinWave_perfect");
plot_function_with_respect_to_time(T,t,fQ2, ...
    "./Report/figures/SquareWave_50%_perfect");
plot_function_with_respect_to_time(T,t,fQ3, ...
    "./Report/figures/SquareWave_10%_perfect");
plot_function_with_respect_to_time(T,t,fQ4, ...
    "./Report/figures/SawtoothWave_perfect");
calc_plot_and_save_functions(T,t,n,fQ1,fQ2,fQ3,fQ4);
plot_TEK_csv("./csv/TEK00000.CSV", ...
    "./Report/figures/Sin_TEK_plot");
plot_TEK_csv("./csv/TEK00001.CSV", ...
    "./Report/figures/Square_50%_TEK_plot");
plot_TEK_csv("./csv/TEK00002.CSV", ...
    "./Report/figures/Square_10%_ESP_plot");
plot_TEK_csv("./csv/TEK00003.CSV", ...
    "./Report/figures/SawTooth_ESP_plot");