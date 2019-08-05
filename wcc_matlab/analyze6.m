s = {'QuPath','ASAP','Sedeen','NDP'}

% figure('Units','normalized',...
%     'Position',[0 0 1 1],...
%     'PaperPositionMode','auto');
% 
% k = 0;
% for i = 1:4
%     for j = i+1:4
%         k = k + 1;
%         
%         s1=cell2mat(s(i));
%         s2=cell2mat(s(j));
%         fn = sprintf('dE_%s-%s.mat',s1,s2);
%         load(fn,'dE')
%         
%         dE1 = reshape(dE,size(dE,1)*size(dE,2),1);
%         v_mean = mean(dE1);
%         v_std = std(dE1);
%         
%         subplot(2,3,k)
%         histogram(dE1)
%         title(sprintf('%s-%s, \\mu=%.2f, \\sigma=%.2f',s1,s2,v_mean,v_std))
%         axis([0 50 0 10000])
%     end
% end
% 
% saveas(gcf, '6histograms.tif')
% 
% 
% %%
% figure('Units','normalized',...
%     'Position',[0 0 1 1],...
%     'PaperPositionMode','auto');
% 
% k = 0;
% for i = 1:4
%     for j = i+1:4
%         k = k + 1;
%         
%         s1=cell2mat(s(i));
%         s2=cell2mat(s(j));
%         fn = sprintf('dE_%s-%s.mat',s1,s2);
%         load(fn,'dE')
%         
%         dE1 = reshape(dE,size(dE,1)*size(dE,2),1);
%         v_mean = mean(dE1);
%         v_std = std(dE1);
%         
%         subplot(2,3,k)
%         imagesc(dE)
%         colorbar
%         caxis([0 30])
%         axis off
%         title(sprintf('%s-%s, \\mu=%.2f, \\sigma=%.2f',s1,s2,v_mean,v_std))
%     end
% end
% 
% saveas(gcf, '6dEs.tif')


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

boxplot(data,'Labels',{'Q-A','Q-S','Q-N','A-S','A-N','S-N'})
ylabel('{\Delta}E')
saveas(gcf, 'boxplot.tif')
