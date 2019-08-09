s = {'QuPath','ASAP','Sedeen','NDPview2'};

figure('Units','normalized',...
    'Position',[0 0 0.4 1],...
    'PaperPositionMode','auto');

k = 0;
for i = 1:4
    for j = i+1:4
        k = k + 1;
        
        s1=cell2mat(s(i));
        s2=cell2mat(s(j));
        fn = sprintf('dE_%s-%s.mat',s1,s2);
        load(fn,'dE')
        
        dE1 = reshape(dE,size(dE,1)*size(dE,2),1);
        v_mean = mean(dE1);
        v_std = std(dE1);
        
        plot = subaxis(3,2,k, 'SpacingHoriz', 0, 'SpacingVert', 0.05,...
            'Padding', 0.02, 'MarginTop', 0.05);
        histogram(dE1)
        title(sprintf('%s-%s',s1,s2))
        axis off
        axis([0 30 0 10000])
        if k > 4
            xlabel('\DeltaE')
        end
        set(plot,'FontSize',12)
        plot.TitleFontSizeMultiplier = 1.2;
    end
end
saveas(gcf, '6histograms.tif')


%%
figure('Units','normalized',...
    'Position',[0 0 0.83 1],...
    'PaperPositionMode','auto');

k = 0;
for i = 1:4
    for j = i+1:4
        k = k + 1;
        
        s1=cell2mat(s(i));
        s2=cell2mat(s(j));
        fn = sprintf('dE_%s-%s.mat',s1,s2);
        load(fn,'dE')
        
        dE1 = reshape(dE,size(dE,1)*size(dE,2),1);
        v_mean = mean(dE1);
        v_std = std(dE1);
        
        plot = subaxis(2,3,k, 'SpacingHoriz', 0, 'SpacingVert', 0.06,...
            'Padding', 0.01, 'MarginTop', 0.05);
        imagesc(dE)
        %if mod(k,3) == 0
        %    colorbar
        %end
        caxis([0 30])
        axis off
        title(sprintf('%s-%s, \\mu=%.2f, \\sigma=%.2f',s1,s2,v_mean,v_std))
        plot.TitleFontSizeMultiplier = 1.7;
    end
end

saveas(gcf, '6dEs.tif')

%%
figure('Units','normalized',...
    'Position',[0 0 0.3 1],...
    'PaperPositionMode','auto');
caxis([0 30])
axis off
c = colorbar
%c.Location = 'west'
c.AxisLocation = 'out'
c.FontSize = 36
%%
figure('Units','normalized',...
    'Position',[0.2 0.2 0.4 0.4],...
    'PaperPositionMode','auto');

data = zeros(401*401,6);

k = 0;
for i = 1:4
    for j = i+1:4
        k = k + 1;
        
        s1=cell2mat(s(i));
        s2=cell2mat(s(j));
        fn = sprintf('dE_%s-%s.mat',s1,s2);
        load(fn,'dE')
        
        
        dE1 = reshape(dE,size(dE,1)*size(dE,2),1);
        data(:,k) = dE1;
    end
end

boxplot(data,'Labels',{'Q-A','Q-S','Q-N','A-S','A-N','S-N'}, 'Symbol', '.', 'Colors', [0 124/256 168/256])
set(gca,'FontSize',12)
ylabel('Color Difference ({\Delta}E)')
saveas(gcf, 'boxplot.tif')
