function plotwithstyle(x, y)
    colors = ["r", "b", "g", "m", "c", "k"];
    for i=1:size(y, 2)
        plot(x, y(:,i), "-" + colors(i)); hold on;
    end
end