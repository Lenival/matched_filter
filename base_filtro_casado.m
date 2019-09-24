
bits = [1 1 0 0 1 0 1];         % Stream de bits

T = 20;                             %Largura do pulso em amostras

N0 = 0.5;

up_bits = upsample(bits,T);

l_t = length(up_bits);

t = 0:(l_t-1);

% Definição do formatos de pulsos
sw = ones(1,T);

% Criação do sinal transmitido
sinal = conv(up_bits,sw);
sinal = sinal(1:l_t);
%stem(t,sinal)


% Criação do ruído de canal
n = N0*randn(1,l_t);

% Sinal recebido
r = sinal+n;

% Sinal filtrado
mf = flip(sw);

Y = (1/T)*conv(r,mf);
Y = Y(1:l_t);

hold on
stem(t,sinal)
stem(t,r,'g')
stem(t,Y,'r')
hold off