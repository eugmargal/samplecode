function capNPV = cap_shifted(forward_rate, strike, volatility, time, DCF, DFOIS)

theta = 0.03;
d1 = log((forward_rate(2:end)+theta)/(strike+theta)) + time(2:end)/2.*(volatility).^2./(volatility.*sqrt(time(2:end)));
d2 = log((forward_rate(2:end)+theta)/(strike+theta)) - time(2:end)/2.*(volatility).^2./(volatility.*sqrt(time(2:end)));
caplet76 = DCF(2:end).*DFOIS(2:end).*((forward_rate(2:end)+theta).*normcdf(d1) - (strike+theta).*normcdf(d2));
capNPV = sum(caplet76) + DCF(1)*DFOIS(1)*max(forward_rate(1)-strike,0);

end