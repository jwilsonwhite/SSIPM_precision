function analyze_test_R_auto(do_postproc)

% Test for bias and precision in estimating F when Rt is autocorrelated.
% This file does post-processing and makes figures
% 'do_postproc' is a logical; is the postprocessing needed or already
% done?

% Specify details of the run
Fmu = 0.1;
Fcv = 0;
Rcorr = [0 0.1 0.5];
Rsd = [0.1 1.0];
Nsims = 1:10;
Site = 'Null';
Type = 'Mock';
Date = '26Nov2024';

Species = {'SMYS'};
      
       
if do_postproc
% Loop over species
s = 1;%:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
  
    for f = 1:length(Rsd)
        for r = 1:length(Rcorr)

        % do post-processing
        for j = 1:length(Nsims)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date,'_R',num2str(Nsims(j)),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date,'_R',num2str(Nsims(j)),'.mat');
            save(meta_fname,'Meta')
            postproc_pisco_rockfish_fit(meta_fname,'')
        %    M = load(meta_fname1,'Meta');
        %    Meta = M.Meta;
        %    Post=load(Meta.post_savename,'Post');
            
        end % end loop over Nsims
        
    end % end loop over Rcorr
    end % end loop over Rsd
    

else % if not doing postproc, just load results
    
    Bias = nan(length(Rsd)*length(Rcorr),1);
    StDev = Bias;
    Rsds = Bias;
    Rcorrs = Bias;
    Means = Bias;
    Max = Bias;
    Min = Bias;
    Specieslist = cell(length(Rsd)*length(Rcorr),1);
    
    s = 1;
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    %Fcv = Fcvs{s};
     
    for f = 1:length(Rsd)
        for r = 1:length(Rcorr)
        
        Index = (f-1)*length(Rcorr)+r; % the row of Dataframe to use

        % do post-processing
        for j = 1:length(Nsims)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.postproc_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date,'_R',num2str(Nsims(j)),'_postproc.mat');
            load(Meta.postproc_savename)
            
            Mean(j) = Post.F_mean;
            
        end % end loop over Nsims
        
        Means(Index) = mean(Mean);
        Max(Index) = max(Mean);
        Min(Index) = min(Mean);
        Bias(Index) = mean(Mean-Fmu);
        StDev(Index) = std(Mean);
        Specieslist{Index} = human_name(Species{s});
        Rsds(Index) = Rsd(f);
        Rcorrs(Index) = Rcorr(r);
        
    end % end loop over Rcorr
    end % end loop over Rsd

Dataframe = table(Specieslist,Rsds,Rcorrs,Means,Max,Min,Bias,StDev);


writetable(Dataframe,'R_auto_bias.csv')

    
    
end % end if do_postproc