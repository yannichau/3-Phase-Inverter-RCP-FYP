function plotcurrentwithstyle(x, id_list, iq_list)
    colors = ["r", "b", "g", "m", "c", "k"];
    for i=1:size(id_list, 2)
        plot(x, id_list(:,i), "-" + colors(i)); hold on;
    end
    for i=1:size(iq_list, 2)
        plot(x, iq_list(:,i), ":" +colors(i)); hold on;
    end
end