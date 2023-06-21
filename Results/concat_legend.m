function legend = concat_legend(quantity, legend_list)
    legend = [];
    for i=1:size(legend_list,2)
        item_legend = quantity + " " + legend_list(i);
        legend = [legend item_legend];
    end
end