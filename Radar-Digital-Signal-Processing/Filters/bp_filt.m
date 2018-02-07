function y = bp_filt(x)


[b,a] = filt_coefs;

y = zeros(size(x));

for i = 1:size(x,1)
  y(i,:) = iir_filt_ord3(x(i,:),b,a);
end
