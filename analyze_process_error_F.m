function analyze_process_error_F(do_postproc)

% Test for bias and precision in estimating F when F has process error too.
% This file does post-processing and makes figures
% 'do_postproc' is a logical; is the postprocessing needed or already
% done?

% Specify details of the run
Fmu = 0.1;
Fcv = 0:0.1:0.5;
Nsims = 1:10;
Site = 'Null';
Type = 'Mock';
Date = '14Jan2020';

Species = {'HDEC','OELO','PCLA','SATR','SAUR','SCAR','SCAU',...
            'SFLA','SGUT','SMAR','SMEL','SMIN','SMYS','SNEB',...
            'SPAU','SSER','STRFRAAD'};
      

       
if do_postproc
% Loop over species
for s = 1:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    %Fcv = Fcvs{s};
    for f = 1:length(Fcv)

        % do post-processing
        for j = 1:length(Nsims)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date,'_R',num2str(Nsims(j)),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date,'_R',num2str(Nsims(j)),'.mat');
            save(meta_fname,'Meta')
            postproc_pisco_rockfish_fit(meta_fname,'')
        %    M = load(meta_fname1,'Meta');
        %    Meta = M.Meta;
        %    Post=load(Meta.post_savename,'Post');
            
        end % end loop over Nsims
        
    end % end loop over Fcv
    
end % end parfor Species loop

else % if not doing postproc, just load results
    
    Bias = nan(length(Species)*length(Fcv),1);
    StDev = Bias;
    CV = Bias;
    Specieslist = cell(length(Species)*length(Fcv),1);
    
    for s = 1:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    %Fcv = Fcvs{s};
    for f = 1:length(Fcv)
        
        Index = (s-1)*length(Fcv)+f; % the row of Dataframe to use

        % do post-processing
        for j = 1:length(Nsims)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.postproc_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date,'_R',num2str(Nsims(j)),'_postproc.mat');
            load(Meta.postproc_savename)
            
            Mean(j) = Post.F_mean;
            
        end % end loop over Nsims
        
        Bias(Index) = mean(Mean-Fmu);
        StDev(Index) = std(Mean);
        Specieslist{Index} = human_name(Species{s});
        CV(Index) = Fcv(f);
        
    end % end loop over Fcv
    
end % end parfor Species loop

Dataframe = table(Specieslist,CV,Bias,StDev);
keyboard

writetable(Dataframe,'Fprocess_bias.csv')

    
    
end % end if do_postproc