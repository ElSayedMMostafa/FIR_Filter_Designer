function [hls_true, hf_true] = weighted_least_square (k,N,fc,coeff,pass_type)
     %k --> Number of frequency-response points
     %N --> Number of time-domain response points
      %fc --> the cut-off frequency as a fraction of Fs (Sampling Frequency)
L=round((N-1)/2);
w =pi*linspace(0,1,k); %The frequencies    
L1=0:1:L; %The coffecient of OMEGAS

F = 2*cos(w'*L1); %Construct F Matrix
F(:,1) = F(:,1)/2;

if fc>1 || fc<=0 
    fc=0.5; %Validation
end

Hd = zeros(k,1);
 Hd(1:ceil(k*fc*2),1) = 1; %Determining the cutoff frequency

%Weights Matrix
W = diagonal_with_coeff(k,coeff);

Hn = (F'*W*F)\(F'*W)*Hd;  %The time-domain coefficient
hls_true=[fliplr(Hn(2:end)') Hn']; 
%% Determine its type (High or Band Pass)
if strcmp(pass_type,'High Pass')
n = 1:1:N;
to_shift = cos(2*pi*n/2);
hls_true = hls_true.*to_shift;
elseif strcmp(pass_type,'Band Pass')
n = 1:1:N;
to_shift = cos(2*pi*n/4);
hls_true = hls_true.*to_shift;
end
hf_true =fft(hls_true);
end
