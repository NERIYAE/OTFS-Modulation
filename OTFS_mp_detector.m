function x_est = OTFS_mp_detector(N,M,M_mod,taps,delay_taps,...
                                   Doppler_taps,chan_coef,sigma_2,y)
% -------------------------------------------------------------
% Message-Passing detector for OTFS
% -------------------------------------------------------------
yv = reshape(y,N*M,1);
n_ite   = 200;
delta_fra = 0.6;

% -----  שינוי: יצירת האלפבית עם התחביר החדש  -----
alphabet = qammod((0:M_mod-1).', M_mod, 'gray', ...
                  'InputType','integer', ...
                  'UnitAveragePower',false);

mean_int = zeros(N*M,taps);
var_int  = zeros(N*M,taps);
p_map    = ones(N*M,taps,M_mod)*(1/M_mod);
conv_rate_prev = -0.1;

for ite = 1:n_ite
    %% ------------- עדכון ממוצע ושונות -------------
    for ele1 = 1:M
        for ele2 = 1:N
            mean_int_hat = zeros(taps,1);
            var_int_hat  = zeros(taps,1);
            for tap_no = 1:taps
                m = ele1-1-delay_taps(tap_no)+1;
                add_term  = exp(1i*2*(pi/M)*(m-1)*(Doppler_taps(tap_no)/N));
                add_term1 = 1;
                if ele1-1 < delay_taps(tap_no)
                    n = mod(ele2-1-Doppler_taps(tap_no),N)+1;
                    add_term1 = exp(-1i*2*pi*((n-1)/N));
                end
                new_chan = add_term*add_term1*chan_coef(tap_no);

                for i2 = 1:M_mod
                    mean_int_hat(tap_no) = mean_int_hat(tap_no) + ...
                        p_map(N*(ele1-1)+ele2,tap_no,i2)*alphabet(i2);
                    var_int_hat(tap_no)  = var_int_hat(tap_no)  + ...
                        p_map(N*(ele1-1)+ele2,tap_no,i2)*abs(alphabet(i2))^2;
                end
                mean_int_hat(tap_no) = mean_int_hat(tap_no)*new_chan;
                var_int_hat(tap_no)  = var_int_hat(tap_no)*abs(new_chan)^2 ...
                                     - abs(mean_int_hat(tap_no))^2;
            end
            mean_int_sum = sum(mean_int_hat);
            var_int_sum  = sum(var_int_hat)+sigma_2;
            for tap_no = 1:taps
                idx = N*(ele1-1)+ele2;
                mean_int(idx,tap_no) = mean_int_sum - mean_int_hat(tap_no);
                var_int(idx ,tap_no) = var_int_sum  - var_int_hat(tap_no);
            end
        end
    end
    %% ------------- עדכון הסתברויות -------------
    sum_prob_comp = zeros(N*M,M_mod);
    dum_eff_ele1  = zeros(taps,1);
    dum_eff_ele2  = zeros(taps,1);
    for ele1 = 1:M
        for ele2 = 1:N
            dum_sum_prob = zeros(M_mod,1);
            log_te_var   = zeros(taps,M_mod);
            for tap_no = 1:taps
                if ele1+delay_taps(tap_no) <= M
                    eff_ele1 = ele1 + delay_taps(tap_no);
                    add_term = exp(1i*2*pi*(ele1-1)*(Doppler_taps(tap_no)/N)/M);
                    int_flag = 0;
                else
                    eff_ele1 = ele1 + delay_taps(tap_no) - M;
                    add_term = exp(1i*2*pi*(ele1-1-M)*(Doppler_taps(tap_no)/N)/M);
                    int_flag = 1;
                end
                add_term1 = 1;
                if int_flag
                    add_term1 = exp(-1i*2*pi*((ele2-1)/N));
                end
                eff_ele2 = mod(ele2-1+Doppler_taps(tap_no),N)+1;
                new_chan = add_term*add_term1*chan_coef(tap_no);

                dum_eff_ele1(tap_no) = eff_ele1;
                dum_eff_ele2(tap_no) = eff_ele2;
                for i2 = 1:M_mod
                    idx = N*(eff_ele1-1)+eff_ele2;
                    dum_sum_prob(i2) = abs( yv(idx) - ...
                        mean_int(idx,tap_no) - new_chan*alphabet(i2) )^2;
                    dum_sum_prob(i2) = -dum_sum_prob(i2) / ...
                                       var_int(idx,tap_no);
                end
                dum = dum_sum_prob - max(dum_sum_prob);
                log_te_var(tap_no,:) = dum - log(sum(exp(dum)));
            end
            ln_qi = sum(log_te_var,1);
            tmp   = exp(ln_qi - max(ln_qi));
            sum_prob_comp(N*(ele1-1)+ele2,:) = tmp/sum(tmp);

            % עדכון p_map
            for tap_no = 1:taps
                eff_ele1 = dum_eff_ele1(tap_no);
                eff_ele2 = dum_eff_ele2(tap_no);
                ln_qi_loc = ln_qi - log_te_var(tap_no,:);
                tmp = exp(ln_qi_loc - max(ln_qi_loc));
                p_map(N*(eff_ele1-1)+eff_ele2,tap_no,:) = ...
                    delta_fra*(tmp/sum(tmp)) + ...
                    (1-delta_fra)*reshape(p_map(N*(eff_ele1-1)+eff_ele2,tap_no,:),1,[]);
            end
        end
    end
    conv_rate = sum(max(sum_prob_comp,[],2)>0.99)/(N*M);
    if conv_rate==1 || ...
       (conv_rate<conv_rate_prev-0.2 && conv_rate_prev>0.95)
        sum_prob_fin = sum_prob_comp; break;
    end
    if conv_rate>conv_rate_prev
        conv_rate_prev = conv_rate;
        sum_prob_fin   = sum_prob_comp;
    end
end

% החלטת MAP
x_est = zeros(N,M);
for ele1 = 1:M
    for ele2 = 1:N
        [~,pos] = max(sum_prob_fin(N*(ele1-1)+ele2,:));
        x_est(ele2,ele1) = alphabet(pos);
    end
end
%%% PLOT – קונסטלציה מזוהה לעומת קונסטלציה אמיתית (פריים אחד)
%%% PLOT – קונסטלציה מזוהה
figure;    % 
scatter(real(alphabet), imag(alphabet), 'ko','filled'); hold on;
scatter(real(x_est(:)), imag(x_est(:)), 'r.');
legend('Ideal constellation','Detected symbols');
title('MP-detector output');
axis equal; grid on;
legend('Detected symbols');
title('MP-detector output'); axis equal; grid on; drawnow;



end
