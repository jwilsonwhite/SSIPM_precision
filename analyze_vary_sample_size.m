function analyze_vary_sample_size(do_postproc)

% Test for bias and precision in estimating F when the sample size varies
% This file does post-processing and makes figures
% 'do_postproc' is a logical; is the postprocessing needed or already
% done?

% Specify details of the run
SS = [30,50,70,100,200,300]; % target number of fish counted per year
Fmu = [0.1,0.2];
Fcv = 0;
Nsims = 100;
Site = 'Null';
Type = 'Mock';
Date = '14Jan2020';

Species = {'SMYS'};
      

       
if do_postproc
% Loop over species
%for 
s = 1; %:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    %Fcv = Fcvs{s};
    for f = 1:length(Fmu)

        % do post-processing
        for j = 1:length(Nsims)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;

            for s = 1:length(SS)
            Meta.data_savename = strcat('mockdata_samplesize/',Species{s},'_mockdata_F',num2str(Fmu(f)),'_Fcv',num2str(Fcv),Date,'_R',num2str(Nsims(j)),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu(f)),'_Fcv',num2str(Fcv),'_SS',num2str(SS(ss)),'_',Date,'_R',num2str(Nsims(j)),'.mat');
            save(meta_fname,'Meta')
            postproc_pisco_rockfish_fit(meta_fname,'')
            end
        %    M = load(meta_fname1,'Meta');
        %    Meta = M.Meta;
        %    Post=load(Meta.post_savename,'Post');
            
        end % end loop over Nsims
        
    end % end loop over Fcv
    
%end % end parfor Species loop

else % if not doing postproc, just load results
    
    Bias = nan(length(Fmu)*length(SS),1);
    StDev = Bias;
    Fs = Bias;
    SSs = Bias;
    Specieslist = cell(length(Fmu)*length(SS),1);
    
    s = 1;% :length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    %Fcv = Fcvs{s};
    for f = 1:length(Fmu)

        M = load(meta_fname,'Meta');
        Meta = M.Meta;

        for s = 1:length(SS)
        
            Index = (f-1)*+f; % the row of Dataframe to use
        
        % do post-processing
        for j = 1:length(Nsims)
            
            Meta.postproc_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu(f)),'_Fcv',num2str(Fcv),'_SS',num2str(SS(ss)),'_',Date,'_R',num2str(Nsims(j)),'_postproc.mat');
            load(Meta.postproc_savename)
            
            Mean(j) = Post.F_mean;
            
        end % end loop over Nsims
        
        Bias(Index) = mean(Mean-Fmu(f));
        StDev(Index) = std(Mean);
        Specieslist{Index} = human_name(Species{s});
        Fs(Index) = Fmu(f);
        SSs(Index) = SS(ss);

        end % end loop over SS
    end % end loop over Fcv
    
%end % end parfor Species loop

Dataframe = table(Specieslist,Fs,SSs,Bias,StDev);
keyboard

writetable(Dataframe,'Vary_SS_bias.csv')

    
    
end % end if do_postproc