clear; clc;
% diary(fullfile('.', 'AnalysisResults', 'DoseResponseFit_log.txt')); diary on;
%% load data, averaged acorss trials of the raw data
% load(fullfile('.', 'data', 'AveRawDataMatrix.mat'));

load(fullfile('.', 'data', 'AveRawDataMatrixFASTVERSION.mat'));
[rowTotal, colTotal, ~] = size(dataMean);

%% Label the curves
% 1: saturated curves
% 2: highest DF/F value >> 1, and the 2nd highest concentration reach the half maximum
% 3: weak responses, not 1 nor 2, and non-zero.

maskPlot = zeros(rowTotal, colTotal);

maskPlot(1, 1) = 3;     %1-pentanol 33b; 
% maskPlot(1, 2) = 3;     %1-pentanol 45a; 
maskPlot(1, 4) = 1;     %1-pentanol 35a; S
maskPlot(1, 11) = 3;    %1-pentanol 67b; 
maskPlot(1, 13) = 3;    %1-pentanol 13a; 

maskPlot(2, 1) = 3;     %3-pentanol 33b;
maskPlot(2, 2) = 3;     %3-pentanol 45a;
maskPlot(2, 5) = 2;     %3-pentanol 42a;
maskPlot(2, 6) = 3;     %3-pentanol 59a;
maskPlot(2, 8) = 3;     %3-pentanol 45b;
maskPlot(2, 10) = 3;     %3-pentanol 24a;
maskPlot(2, 11) = 3;    %3-pentanol 67b;
maskPlot(2, 12) = 3;    %3-pentanol 85c;
maskPlot(2, 13) = 3;    %3-pentanol 13a;
maskPlot(2, 16) = 3;    %3-pentanol 22c;
maskPlot(2, 17) = 3;    %3-pentanol 42b;
maskPlot(2, 21) = 3;    %3-pentanol 94a;

maskPlot(3, 2) = 3;     %6-methyl-5-hepten-2-ol 45a;
maskPlot(3, 4) = 3;     %6-methyl-5-hepten-2-ol 35a;
maskPlot(3, 7) = 3;     %6-methyl-5-hepten-2-ol 1a;
maskPlot(3, 12) = 1;    %6-methyl-5-hepten-2-ol 85c; S
maskPlot(3, 13) = 1;    %6-methyl-5-hepten-2-ol 13a; S

maskPlot(4, 1)  = 2;    %3-octanol 33b; 
maskPlot(4, 2)  = 3;    %3-octanol 45a; 
maskPlot(4, 4)  = 3;    %3-octanol 35a; 
maskPlot(4, 7)  = 3;    %3-octanol 1a; 
maskPlot(4, 10)  = 3;    %3-octanol 24a; 
maskPlot(4, 11)  = 3;   %3-octanol 67b; 
maskPlot(4, 12) = 1;    %3-octanol 85c; S
maskPlot(4, 13) = 1;    %3-octanol 13a; S

maskPlot(5, 1) = 3;     %trans-3-hexen-1-ol 33b; 
maskPlot(5, 2) = 3;     %trans-3-hexen-1-ol 45a; 
maskPlot(5, 4) = 1;     %trans-3-hexen-1-ol 35a; S
maskPlot(5, 5) = 3;     %trans-3-hexen-1-ol 42a; 
maskPlot(5, 11) = 3;    %trans-3-hexen-1-ol 67b; 
maskPlot(5, 12) = 3;    %trans-3-hexen-1-ol 85c;  <0.5
maskPlot(5, 13) = 3;    %trans-3-hexen-1-ol 13a;

maskPlot(6, 1) = 3;     %methyl phenyl sulfide 33b;  
maskPlot(6, 6) = 3;     %methyl phenyl sulfide 59a;
maskPlot(6, 7) = 3;     %methyl phenyl sulfide 1a;
maskPlot(6, 8) = 1;     %methyl phenyl sulfide 45b; S
maskPlot(6, 10) = 1;     %methyl phenyl sulfide 24a; S
maskPlot(6, 11) = 3;    %methyl phenyl sulfide 67b;
maskPlot(6, 14) = 2;    %methyl phenyl sulfide 30a;
maskPlot(6, 16) = 1;    %methyl phenyl sulfide 22c; S
% maskPlot(6, 21) = 3;    %methyl phenyl sulfide 94a; 

maskPlot(7, 1)  = 3;    %anisole 33b; 
maskPlot(7, 2)  = 3;    %anisole 45a; 
maskPlot(7, 4)  = 3;    %anisole 35a; 
maskPlot(7, 6)  = 3;    %anisole 59a; 
maskPlot(7, 7)  = 3;    %anisole 1a; 
maskPlot(7, 8)  = 3;    %anisole 45b; 
maskPlot(7, 10)  = 1;    %anisole 24a; S
maskPlot(7, 11) = 3;    %anisole 67b; 
maskPlot(7, 14) = 2;    %anisole 30a; 
maskPlot(7, 16) = 3;    %anisole 22c; 
maskPlot(7, 21) = 3;    %anisole 94a; 

maskPlot(8, 1) = 3;     %2-acetylpyridine 33b;
maskPlot(8, 4) = 3;     %2-acetylpyridine 35a;
maskPlot(8, 6) = 3;     %2-acetylpyridine 59a;
maskPlot(8, 8) = 3;     %2-acetylpyridine 45b;
maskPlot(8, 10) = 1;     %2-acetylpyridine 24a; S
maskPlot(8, 16) = 3;    %2-acetylpyridine 22c;

maskPlot(9, 1) = 3;     %2,5-dimethylpyrazine 33b;
maskPlot(9, 2) = 3;     %2,5-dimethylpyrazine 45a;
maskPlot(9, 6) = 3;     %2,5-dimethylpyrazine 59a;
maskPlot(9, 8) = 3;     %2,5-dimethylpyrazine 45b;
% maskPlot(9, 10)= 3;     %2,5-dimethylpyrazine 67b; <0.5
maskPlot(9, 14) = 3;    %2,5-dimethylpyrazine 30a;
maskPlot(9, 16) = 3;    %2,5-dimethylpyrazine 22c;
maskPlot(9, 17) = 3;    %2,5-dimethylpyrazine 42b;
maskPlot(9, 21) = 3;    %2,5-dimethylpyrazine 94a;

maskPlot(10, 1) = 1;    %pentyl acetate 33b; S
maskPlot(10, 2) = 2;    %pentyl acetate 45a; not flat yet
maskPlot(10, 4) = 1;    %pentyl acetate 35a; S
maskPlot(10, 5) = 3;    %pentyl acetate 42a;  <0.5
maskPlot(10, 7) = 2;    %pentyl acetate 1a; not flat yet
maskPlot(10, 10) = 3;   %pentyl acetate 24a; 
maskPlot(10, 11) = 2;   %pentyl acetate 67b; not flat yet
maskPlot(10, 12) = 1;   %pentyl acetate 85c; S
maskPlot(10, 13) = 2;   %pentyl acetate 13a;
maskPlot(10, 14) = 3;   %pentyl acetate 30a;
maskPlot(10, 15) = 3;   %pentyl acetate 82a;
maskPlot(10, 16) = 3;   %pentyl acetate 22c;
maskPlot(10, 17) = 3;   %pentyl acetate 42b; <0.5

maskPlot(11, 1) = 1;    %geranyl acetate 33b; S
maskPlot(11, 2) = 1;    %geranyl acetate 45a; S
maskPlot(11, 7) = 3;    %geranyl acetate 1a; <0.5
maskPlot(11, 10) = 3;    %geranyl acetate 24a;
maskPlot(11, 15) = 1;   %geranyl acetate 82a; S
maskPlot(11, 17) = 3;   %geranyl acetate 42b;

maskPlot(12, 1)  = 3;   %2-methoxyphenyl acetate 33b; 
maskPlot(12, 6)  = 3;   %2-methoxyphenyl acetate 59a; 
maskPlot(12, 8)  = 3;   %2-methoxyphenyl acetate 45b; 
maskPlot(12, 10)  = 3;   %2-methoxyphenyl acetate 24a; 
maskPlot(12, 12) = 3;   %2-methoxyphenyl acetate 85c; 
maskPlot(12, 16) = 3;   %2-methoxyphenyl acetate 22c; 
maskPlot(12, 21) = 2;   %2-methoxyphenyl acetate 94a; 

maskPlot(13, 2) = 2;    %trans,trans-2,4-nonadienal 45a; 
maskPlot(13, 4) = 3;    %trans,trans-2,4-nonadienal 35a; 
maskPlot(13, 12) = 3;   %trans,trans-2,4-nonadienal 85c; <0.5 
maskPlot(13, 13) = 3;   %trans,trans-2,4-nonadienal 13a; 
maskPlot(13, 20) = 1;   %trans,trans-2,4-nonadienal 74a; S

maskPlot(14, 3) = 2;    %4m5v 83a;
maskPlot(14, 6) = 1;    %4m5v 59a; S
maskPlot(14, 8) = 1;    %4m5v 45b; S
maskPlot(14, 10) = 3;    %4m5v 24a;
maskPlot(14, 14) = 3;   %4m5v 30a;
maskPlot(14, 16) = 3;   %4m5v 22c;
maskPlot(14, 21) = 3;   %4m5v 94a;

maskPlot(15, 3) = 3;    %4,5-dimethylthiazole 83a;
maskPlot(15, 6) = 2;    %4,5-dimethylthiazole 59a; not flat
maskPlot(15, 8) = 3;    %4,5-dimethylthiazole 45b;
maskPlot(15, 11) = 3;   %4,5-dimethylthiazole 67b;

maskPlot(16, 1) = 3;    %4-hexen-3-one 33b;
maskPlot(16, 2) = 3;    %4-hexen-3-one 45a;
maskPlot(16, 4) = 3;    %4-hexen-3-one 35a;
maskPlot(16, 5) = 1;    %4-hexen-3-one 42a; S
maskPlot(16, 10) = 3;    %4-hexen-3-one 24a;
maskPlot(16, 12) = 3;   %4-hexen-3-one 85c;
maskPlot(16, 17) = 2;   %4-hexen-3-one 42b;
maskPlot(16, 20) = 3;   %4-hexen-3-one 74a;

maskPlot(17, 1) = 2;    %2-nonanone 33b; 
maskPlot(17, 2) = 3;    %2-nonanone 45a; 
maskPlot(17, 4) = 3;    %2-nonanone 35a; 
maskPlot(17, 8) = 3;    %2-nonanone 45b; 
maskPlot(17, 10) = 2;    %2-nonanone 24a; 
maskPlot(17, 11) = 3;   %2-nonanone 67b; 
maskPlot(17, 12) = 2;   %2-nonanone 85c; 
maskPlot(17, 13) = 2;   %2-nonanone 13a; 
maskPlot(17, 17) = 3;   %2-nonanone 42b; 
maskPlot(17, 20) = 3;   %2-nonanone 74a; 

maskPlot(18, 2) = 3;    %acetal 45a;
maskPlot(18, 17) = 2;   %acetal 42b; not flat
maskPlot(18, 20) = 3;   %acetal 74a;

maskPlot(19, 4) = 3;    %2-phenyl ethanol 35a;
maskPlot(19, 10) = 3;    %2-phenyl ethanol 24a;
maskPlot(19, 11) = 2;   %2-phenyl ethanol 67b;
maskPlot(19, 12) = 3;   %2-phenyl ethanol 85c;

maskPlot(20, 1) = 2;	%butyl acetate 33b/47a;
maskPlot(20, 2) = 3;	%butyl acetate 45a;
maskPlot(20, 3) = 3;	%butyl acetate 83a;
maskPlot(20, 4) = 3;	%butyl acetate 35a;
maskPlot(20, 5) = 3;	%butyl acetate 42a;
% maskPlot(20, 10) = 3;	%butyl acetate 24a;
maskPlot(20, 11) = 3;	%butyl acetate 67b;
maskPlot(20, 12) = 1;	%butyl acetate 85c; S
maskPlot(20, 13) = 3;	%butyl acetate 13a;
maskPlot(20, 15) = 3;	%butyl acetate 82a;
maskPlot(20, 16) = 3;	%butyl acetate 22c;
maskPlot(20, 17) = 3;	%butyl acetate 42b;
% maskPlot(20, 21) = 3;	%butyl acetate 94a/94b;

maskPlot(21, 1) = 3;	%ethyl acetate 33b/47a;
% maskPlot(21, 3) = 3;	%ethyl acetate 83a;
% maskPlot(21, 4) = 3;	%ethyl acetate 35a;
maskPlot(21, 5) = 3;	%ethyl acetate 42a;
% maskPlot(21, 12) = 3;	%ethyl acetate 85c;
maskPlot(21, 17) = 1;	%ethyl acetate 42b; S

% maskPlot(22, 1) = 3;	%benzaldehyde 33b/47a;
maskPlot(22, 3) = 3;	%benzaldehyde 83a;
maskPlot(22, 4) = 3;	%benzaldehyde 35a;
maskPlot(22, 5) = 3;	%benzaldehyde 42a;
maskPlot(22, 7) = 3;	%benzaldehyde 1a;
maskPlot(22, 8) = 1;	%benzaldehyde 45b; S
maskPlot(22, 9) = 3;	%benzaldehyde 63a;
maskPlot(22, 10) = 1;	%benzaldehyde 24a; S
maskPlot(22, 11) = 3;	%benzaldehyde 67b;
% maskPlot(22, 13) = 3;	%benzaldehyde 13a;
maskPlot(22, 14) = 3;	%benzaldehyde 30a;
% maskPlot(22, 15) = 3;	%benzaldehyde 82a;
maskPlot(22, 16) = 3;	%benzaldehydee 22c;
% maskPlot(22, 20) = 3;	%benzaldehyde 74a;
% maskPlot(22, 21) = 3;	%benzaldehyde 94a/94b;

maskPlot(23, 1) = 1;	%2-heptanone 33b/47a; S
maskPlot(23, 2) = 3;	%2-heptanone 45a; 
maskPlot(23, 3) = 3;	%2-heptanone 83a; 
maskPlot(23, 4) = 1;	%2-heptanone 35a;  S
maskPlot(23, 5) = 1;	%2-heptanone 42a;  S
maskPlot(23, 7) = 3;	%2-heptanone 1a; 
maskPlot(23, 10) = 3;	%2-heptanone 24a; 
maskPlot(23, 11) = 2;	%2-heptanone 67b; 
maskPlot(23, 12) = 4;	%2-heptanone 85c; 
maskPlot(23, 13) = 2;	%2-heptanone 13a; 
maskPlot(23, 15) = 3;	%2-heptanone 82a; 
% maskPlot(23, 16) = 3;	%2-heptanone 22c; 
maskPlot(23, 20) = 3;	%2-heptanone 74a; 

% maskPlot(24, 1) = 3;	%methyl salicylate 33b/47a;
maskPlot(24, 6) = 3;	%methyl salicylate 59a;
maskPlot(24, 7) = 2;	%methyl salicylate 1a;
maskPlot(24, 8) = 3;	%methyl salicylate 45b;
maskPlot(24, 9) = 2;	%methyl salicylate 63a;
maskPlot(24, 10) = 1;	%methyl salicylate 24a; S
maskPlot(24, 12) = 2;	%methyl salicylate 85c;
% maskPlot(24, 13) = 3;	%methyl salicylate 13a;
maskPlot(24, 16) = 4;	%methyl salicylate 22c; S
% maskPlot(24, 21) = 3;	%methyl salicylate 94a/94b;

maskPlot(25, 1) = 3;	%ethyl butyrate 33b/47a;
maskPlot(25, 2) = 3;	%ethyl butyrate 45a;
maskPlot(25, 3) = 3;	%ethyl butyrate 83a;
maskPlot(25, 4) = 3;	%ethyl butyrate 35a;
maskPlot(25, 5) = 2;	%ethyl butyrate 42a;
maskPlot(25, 6) = 3;	%ethyl butyrate 59a;
% maskPlot(25, 7) = 3;	%ethyl butyrate 1a;
maskPlot(25, 9) = 3;	%ethyl butyrate 63a;
% maskPlot(25, 10) = 3;	%ethyl butyrate 24a;
maskPlot(25, 12) = 3;	%ethyl butyrate 85c;
maskPlot(25, 14) = 3;	%ethyl butyrate 30a;
maskPlot(25, 15) = 3;	%ethyl butyrate 82a;
maskPlot(25, 16) = 3;	%ethyl butyrate 22c;
maskPlot(25, 17) = 2;	%ethyl butyrate 42b;
maskPlot(25, 18) = 3;	%ethyl butyrate 33a;

maskPlot(26, 1) = 1;	%isoamyl acetate 33b/47a; S
maskPlot(26, 2) = 3;	%isoamyl acetate 45a;
maskPlot(26, 3) = 3;	%isoamyl acetate 83a;
maskPlot(26, 4) = 3;	%isoamyl acetate 35a;
maskPlot(26, 5) = 3;	%isoamyl acetate 42a;
% maskPlot(26, 6) = 3;	%isoamyl acetate 59a;
% maskPlot(26, 10) = 3;	%isoamyl acetate 24a;
maskPlot(26, 11) = 3;	%isoamyl acetate 67b;
maskPlot(26, 12) = 1;	%isoamyl acetate 85c; S
maskPlot(26, 13) = 3;	%isoamyl acetate 13a;
maskPlot(26, 16) = 3;	%isoamyl acetate 22c;
maskPlot(26, 17) = 3;	%isoamyl acetate 42b;
maskPlot(26, 20) = 3;	%isoamyl acetate 74a;

maskPlot(27, 1) = 3;	%4-methylcyclohexane 33b/47a;
maskPlot(27, 3) = 3;	%4-methylcyclohexane 83a;
maskPlot(27, 4) = 3;	%4-methylcyclohexane 35a;
maskPlot(27, 11) = 2;	%4-methylcyclohexane 67b;
maskPlot(27, 12) = 3;	%4-methylcyclohexane 85c;
maskPlot(27, 16) = 3;	%4-methylcyclohexane 22c;
maskPlot(27, 20) = 3;	%4-methylcyclohexane 74a;

maskPlot(28, 1) = 1;	%hexyl acetate 33b/47a;  S
maskPlot(28, 2) = 1;	%hexyl acetate 45a;  S
maskPlot(28, 4) = 1;	%hexyl acetate 35a;  S
maskPlot(28, 5) = 3;	%hexyl acetate 42a;  
maskPlot(28, 7) = 3;	%hexyl acetate 1a;  
maskPlot(28, 9) = 3;	%hexyl acetate 63a;  
maskPlot(28, 11) = 2;	%hexyl acetate 67b;  
maskPlot(28, 12) = 2;	%hexyl acetate 85c;  
maskPlot(28, 13) = 2;	%hexyl acetate 13a;  
% maskPlot(28, 15) = 3;	%hexyl acetate 82a;  
maskPlot(28, 16) = 3;	%hexyl acetate 22c; 
% maskPlot(28, 17) = 3;	%hexyl acetate 42b; 

% maskPlot(29, 2) = 3;	%linalool 45a; 
% maskPlot(29, 3) = 3;	%linalool 83a; 
% maskPlot(29, 4) = 3;	%linalool 35a; 
maskPlot(29, 5) = 3;	%linalool 42a; 
maskPlot(29, 6) = 3;	%linalool 59a; 
maskPlot(29, 7) = 3;	%linalool 1a; 
maskPlot(29, 8) = 3;	%linalool 45b; 
maskPlot(29, 9) = 3;	%linalool 63a; 
% maskPlot(29, 10) = 3;	%linalool 24a; 
maskPlot(29, 12) = 2;	%linalool 85c 
maskPlot(29, 13) = 2;	%linalool 13a 
% maskPlot(29, 15) = 3;	%linalool 82a 
maskPlot(29, 16) = 3;	%linalool 22c 
maskPlot(29, 17) = 3;	%linalool 42b 
% maskPlot(29, 21) = 3;	%linalool 94a/94b 

maskPlot(30, 1) = 2;	%benzyl acetate 33b/47a; 
maskPlot(30, 2) = 2;	%benzyl acetate 45a; 
% maskPlot(30, 5) = 3;	%benzyl acetate 42a; 
% maskPlot(30, 6) = 3;	%benzyl acetate 59a; 
maskPlot(30, 7) = 3;	%benzyl acetate 1a; 
maskPlot(30, 9) = 2;	%benzyl acetate 63a; 
maskPlot(30,11) = 3;	%benzyl acetate 67b; 
maskPlot(30,12) = 3;	%benzyl acetate 85c; 
maskPlot(30, 13) = 3;	%benzyl acetate 13a; 
maskPlot(30, 15) = 3;	%benzyl acetate 82a; 
maskPlot(30, 16) = 3;	%benzyl acetate 22c; 

% maskPlot(31, 2) = 3;	%4-pheny-2-butanol 45a; 
maskPlot(31, 4) = 3;	%4-pheny-2-butanol 35a; 
maskPlot(31, 7) = 3;	%4-pheny-2-butanol 1a; 
maskPlot(31, 8) = 3;	%4-pheny-2-butanol 45b; 
maskPlot(31, 9) = 2;	%4-pheny-2-butanol 63a; 
maskPlot(31, 10) = 2;	%4-pheny-2-butanol 24a; 
maskPlot(31, 11) = 3;	%4-pheny-2-butanol 67b; 
maskPlot(31, 12) = 3;	%4-pheny-2-butanol 85c; 
maskPlot(31, 13) = 3;	%4-pheny-2-butanol 13a; 
% maskPlot(31, 14) = 3;	%4-pheny-2-butanol 30a; 
maskPlot(31, 16) = 3;	%4-pheny-2-butanol 22c; 

maskPlot(32, 3) = 3;	%myrtenal 83a; 
maskPlot(32, 4) = 2;	%myrtenal 35a; 
% maskPlot(32, 5) = 3;	%myrtenal 42a; 
maskPlot(32, 8) = 3;	%myrtenal 45b; 
maskPlot(32, 9) = 3;	%myrtenal 63a; 
maskPlot(32, 10) = 3;	%myrtenal 24a; 
% maskPlot(32, 14) = 3;	%myrtenal 30a; 
% maskPlot(32, 17) = 3;	%myrtenal 42b; 
maskPlot(32, 19) = 3;	%myrtenal 49a; 

% maskPlot(33, 1) = 3;	%menthol 33b/47a; 
% maskPlot(33, 6) = 3;	%menthol 59a; 
maskPlot(33, 7) = 3;	%menthol 1a; 
maskPlot(33, 8) = 3;	%menthol 45b; 
maskPlot(33, 9) = 2;	%menthol 63a; 
% maskPlot(33, 10) = 3;	%menthol 24a; 
% maskPlot(33, 16) = 3;	%menthol 22c; 
maskPlot(33, 17) = 3;	%menthol 42b; 
maskPlot(33, 19) = 2;	%menthol 49a; 
maskPlot(33, 20) = 3;	%menthol 74a;
maskPlot(33, 21) = 3;	%menthol 94a/94b;

maskPlot(34, 4) = 1;	%nonane 35a; S
maskPlot(34, 5) = 3;	%nonane 42a;
maskPlot(34, 11) = 3;   %nonane 67b;
maskPlot(34, 12) = 3;   %nonane 85c;
maskPlot(34, 13) = 3;   %nonane 13a;
% maskPlot(34, 16) = 3;   %nonane 22c; <0.1
% maskPlot(34, 17) = 3;   %nonane 42b; <0.5

%% count the number of curves for each type
s1 = ['Count of saturated dose-respons curves:', num2str(length(find(maskPlot==1)))];
s2 = ['Count of unsaturated but strongly activated curves:', num2str(length(find(maskPlot==2)))];
s3 = ['Count of weak dose-respons curves:', num2str(length(find(maskPlot==3)))];
st = ['Count of all non-zero dose-response curves:', num2str(length(find(maskPlot~=0)))];

fprintf([s1, '\n', s2, '\n', s3, '\n', st '\n']);
%% define variables to store the fitted parameters
cMatrix = NaN(rowTotal, colTotal);     % the thresholds for each odor_ORN pair, 'c' in the equation
aMatrix = NaN(rowTotal, colTotal);     % the saturated amplitude for each odor-ORN pair
r2Matrix= NaN(rowTotal, colTotal);     % the R-square value of the fitting

%% estimate the EC50 of the saturated curves
[row, col] = find(maskPlot==1); %find the saturated curves.
coeffMatrix = zeros(length(row), 3);    %store the parameters for the simulation.

x = log10(concList); %log10(concentration)

% control if plot each saturated curve
plotCurve = 0;
if plotCurve == 1
    figCurveFitH = figure;	hold on;	title('Fit All Saturated Curves'); 
    pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 750, 420]);
end

% print out the fitted parameters
disp('----------FIT SATURATED CURVES----------');
disp('Equation: Y=a/(1+ exp(-b*(X-c)))');
fprintf('%35s\t%-5s\t%-5s\t%-5s\t%-5s\t\n', 'Curve Name', 'a', 'b', 'c', 'R^2 of the fit');

for i = 1:length(row) %go through all the saturated curves
    curveName = [odorList{row(i)} , '->', ORNList{col(i)}]; %define the curve name
    y = dataMean(row(i), col(i), :);  %retrive the y data
    
    if plotCurve == 1
        figure(figCurveFitH); hPoint = plot(x, y(:), 'o'); %plot the data point
        set(get(get(hPoint,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
        figParam.handle = figCurveFitH; %define the setting of plot
        figParam.lineColor = hPoint.Color;
        figParam.lineName = curveName;
        %fit the curve and plot it 
        [coeffs, gof] = Fit_DR(x, y(:), [], plotCurve, figParam);
    else
        [coeffs, gof] = Fit_DR(x, y(:), [], 0, []);
    end
    
    %print out the fitted parameters
    fprintf('%35s\t%.2f\t%.2f\t%.2f\t%.3f\t\n',curveName,coeffs(1),coeffs(2),coeffs(3), gof.rsquare);
    
    %store the fitted parameters
    coeffMatrix(i, :) = coeffs;
end

if plotCurve == 1
    figure(figCurveFitH); xlabel('Log10(c)'); ylabel('\Delta F/F'); hold off;
end

%% estimate the slop after shifiting EC50 and normalizing amplitude
figSlopH = figure; %figure plot shifted curves
title('Normalized Shifted Saturated Curves'); 
pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 540, 420]);

xMatrix = zeros(length(row), 5);    %store the shifted X
yMatrix = zeros(length(row), 5);    %store the normalized Y
for i = 1:length(row)
    xMatrix(i, :) = x - coeffMatrix(i, 3); %shift x using the value of EC50
    
    rawY = dataMean(row(i), col(i), :);
    rawY = rawY(:);
    normY = rawY./coeffMatrix(i, 1);
    yMatrix(i, :) = normY;              %rescale y using the maximum

    figure(figSlopH);                   %display each dataset
%     plot(xMatrix(i, :), normY, 'o:', 'LineWidth', 0.3); hold on;
    plot(xMatrix(i, :), normY, 'o', 'LineWidth', 0.3); hold on;
end

figParam.handle = figSlopH; %define the setting of plot
figParam.lineColor = [0 0 0];
figParam.lineName = 'Slop Fitting';
fitParam = [1, NaN, 0];

[coeffs, gof] = Fit_DR(xMatrix(:), yMatrix(:),fitParam, 1, figParam);
slop = coeffs(2);
figure(figSlopH);
xlabel('Relative Log10(c)'); ylabel('Normalized Activity');
legend('off'); 

disp('---------- FIND THE SLOP ----------');
disp('Normalize the curves using the parameter a.');
disp('Shift the curves using the parameter c.');
disp('Pool the data and fit the parameter of b in equation:');
disp('Y=1/(1+ exp(-b*X))');
fprintf('b = %.2f\n', slop);
fprintf('R^2 of the fit: %.3f\n', gof.rsquare);
disp('NOTE: if the x-axis is ln(c) instead of log10(c), the value of slop will be');
disp('Slop*log10(e), where e is the Euler number or the base of natural log, ');
fprintf('the value of which is %.3f\n', slop*log10(exp(1)));

%% apply the splo onto the saturated curves and fit the EC50 again
% settup the plot 
figCurveFitH1 = figure; hold on; 
title('Fit Saturated Curves Using Fixed Slop'); 
pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 750, 420]);

% print out the fitted parameters
disp('----------FIT SATURATED CURVES USING FIXED SLOP----------');
disp(['Equation: Y=a/(1+ exp(-', num2str(slop), '*(X-c)))']);
fprintf('%35s\t%-5s\t%-5s\t%-5s\t\n', 'Curve Name', 'a', 'c', 'R^2 of the fit');

%define the fitting parameter for the fixed slop case.
fitParam_Fixed_b = [NaN, slop, NaN];

for i = 1:length(row) %go through all the saturated curves
    curveName = [odorList{row(i)} , '->', ORNList{col(i)}]; %define the curve name
    y = dataMean(row(i), col(i), :);  %retrive the y data
    
    figure(figCurveFitH1); hPoint = plot(x, y(:), 'o'); %plot the data point
    set(get(get(hPoint,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    figParam.handle = figCurveFitH1; %define the setting of plot
    figParam.lineColor = hPoint.Color;
    figParam.lineName = curveName;
    %fit the curve and plot it 
    [coeffs, gof] = Fit_DR(x, y(:), fitParam_Fixed_b, plotCurve, figParam);

    %print out the fitted parameters
    fprintf('%35s\t%.2f\t%.2f\t%.3f\t\n',curveName,coeffs(1),coeffs(3), gof.rsquare);
    
    %rewrite the fitted parameters   
    cMatrix(row(i), col(i)) = coeffs(3);
    aMatrix(row(i), col(i)) = coeffs(1);
    r2Matrix(row(i), col(i))= gof.rsquare;
end

figure(figCurveFitH1);  xlabel('Log10(c)'); ylabel('\Delta F/F');   hold off;

% %% Hill plot the type 1 data
% figHillPlot = figure; hold on; 
% title('Hill Plot Saturated Curves'); 
% pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 750, 420]);
% 
% for i = 1:length(row)
%     r = dataMean(row(i), col(i), :);
%     r = reshape(r, [5, 1]);
%     rmax = aMatrix(row(i), col(i));
%     y = log(r./(rmax-r));
%     
%     ec50 = cMatrix(row(i), col(i));
%     x = log(concList) - log(10^ec50);
%     
%     plot(x, y, 'o'); hold on;
% end

% hold off; xlabel('Log10(c/EC50)'); ylabel('Log(R/Rmax-R)')



%% apply the slop, estimate type 2 (close to but not saturated curves) curves' threshold.
%set up the plot
figCurveFitH2 = figure; hold on; title('Fit Type 2 Curves'); 
pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 750, 420]);

% print out the fitted parameters
disp('----------FIT TYPE 2 CURVES USING FIXED SLOP----------');
disp(['Equation: Y=a/(1+ exp(-', num2str(slop), '*(X-c)))']);
fprintf('%35s\t%-5s\t%-5s\t%-5s\t\n', 'Curve Name', 'a', 'c', 'R^2 of the fit');

[row2, col2] = find(maskPlot==2);

for i = 1:length(row2)
    curveName = [odorList{row2(i)} , '->', ORNList{col2(i)}]; %define the curve name
    y = dataMean(row2(i), col2(i), :);  %retrive the y data
    

    figure(figCurveFitH2); hPoint = plot(x, y(:), 'o'); %plot the data point
    set(get(get(hPoint,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    
    figParam.handle = figCurveFitH2; %define the setting of plot
    figParam.lineColor = hPoint.Color;
    figParam.lineName = curveName;
    %fit the curve and plot it 
    [coeffs, gof] = Fit_DR(x, y(:), fitParam_Fixed_b,plotCurve, figParam);

    %print out the fitted parameters
    fprintf('%35s\t%.2f\t%.2f\t%.3f\t\n',curveName,coeffs(1),coeffs(3),gof.rsquare);
    
    %save the fitted parameters
    cMatrix(row2(i), col2(i)) = coeffs(3);
    aMatrix(row2(i), col2(i)) = coeffs(1);
    r2Matrix(row2(i), col2(i))= gof.rsquare;
end

figure(figCurveFitH2); xlabel('Log10(c)'); ylabel('\Delta F/F'); hold off;

%% Estimate the maximum values for each odor (for fitting the type 3 curves)
maxAofOdor = zeros(length(odorList), 1); % define parameter to store maximum amplitude 
lowerBound = 3; % set a lower bound of the maximum amplitude

disp('----------FIND AMPLITUDE OF EACH ODOR FOR TYPE 3 CURVE FITTING----------');
fprintf('%30s\t%-5s\t\n', 'Odor Name', 'Amplitude');

maxProj = max(dataMean, [], 3); %max of the data along the concentration
 
for i = 1:length(odorList)   
    index = ~isnan(aMatrix(i, :)); %find the nun-zero elements of each row (odor), from the saturated dataset
    maxSeqTemp = aMatrix(i, index);
    maxSeq = maxSeqTemp(maxSeqTemp>lowerBound); %select the max values higher than the lower bound
        
    maxEst = mean(maxSeq); % use the mean as the maximum
    if maxEst>lowerBound
        maxAofOdor(i) = maxEst;
    else %if there is no qualified elements, find the maximum in the raw data
        indexBackup = find(maxProj(i, :)>lowerBound);
        seqBackup = maxProj(i, indexBackup);
        maxEstBackup = mean(seqBackup);
        maxAofOdor(i) = maxEstBackup;
    end
    
	fprintf('%30s\t%.2f\t\n', odorList{i}, maxAofOdor(i));
end

%% apply the slop and amplitude to estimate type 3 curves' threshold.
[row3, col3] = find(maskPlot==3);

%set up the plot
figCurveFitH3 = figure; hold on; 
title('Fit Type 3 Curves'); 
set(gcf, 'pos', [600, 60, 750, 900]);

% print out the fitted parameters
disp('----------FIT TYPE 3 CURVES USING FIXED SLOP AND PREPARED AMPLITUDE----------');
disp(['Equation: Y = a0/(1+ exp(-', num2str(slop), '*(X-c))). a0 is a constant for each odor.']);
fprintf('%35s\t%-5s\t%-5s\t\n', 'Curve Name', 'c', 'R^2 of the fit');

for i = 1:length(row3)
    curveName = [odorList{row3(i)} , '->', ORNList{col3(i)}]; %define the curve name
    y = dataMean(row3(i), col3(i), :);  %retrive the y data
    
    figure(figCurveFitH3); hPoint = plot(x, y(:), 'o'); %plot the data point
    set(get(get(hPoint,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    
    figParam.handle = figCurveFitH3; %define the setting of plot
    figParam.lineColor = hPoint.Color;
    figParam.lineName = curveName;
    
    %adjust the fitting parameter
    if maxAofOdor(row3(i)) > maxProj(row3(i), col3(i))
        % if the max data value smaller than the preestimated, use the preestimated one 
        fitParam_3 = [maxAofOdor(row3(i)), slop, NaN];
    else
        % else, leave the amplitude free to fit
        fitParam_3 = [NaN, slop, NaN];
    end
    
    %fit the curve and plot it 
    [coeffs, gof] = Fit_DR(x, y(:), fitParam_3, plotCurve, figParam);

    %print out the fitted parameters
    fprintf('%35s\t%.2f\t%.3f\t\n',curveName, coeffs(3), gof.rsquare);
    
    %save the fitted parameters   
    cMatrix(row3(i), col3(i)) = coeffs(3);
    aMatrix(row3(i), col3(i)) = coeffs(1);
    r2Matrix(row3(i), col3(i))= gof.rsquare;
end

figure(figCurveFitH3); xlabel('Log10(c)'); ylabel('\Delta F/F'); hold off;

%% List the bad fitted curves
cutOff = 0.5;
[failedRow, failedCol] = find(r2Matrix<cutOff);

disp('----------FAILED FITTINGS ----------');
disp([num2str(length(failedRow)), '(out of ', num2str( sum(~isnan(r2Matrix(:)))), ') fittings have R-Square smaller than ', num2str(cutOff)]);
fprintf('%35s\t%-5s\t%-5s\t%-5s\t%-5s\t\n', 'Curve Name', 'a', 'b', 'c', 'R^2 of the fit');

%set up the plot
figCurveFailed = figure; hold on; title('Failed Fittings'); 
pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 750, 420]);

for i = 1:length(failedRow)
    %print out the fitting results
    curveName = [odorList{failedRow(i)} , '->', ORNList{failedCol(i)}]; %define the curve name
    fprintf('%35s\t%.2f\t%.2f\t%.2f\t%.3f\t\n',curveName, aMatrix(failedRow(i), failedCol(i)), ...
        slop, cMatrix(failedRow(i), failedCol(i)), r2Matrix(failedRow(i), failedCol(i)));
    
    % plot the data points
    y = dataMean(failedRow(i), failedCol(i), :);  %retrive the y data
    figure(figCurveFailed); hPoint = plot(x, y(:), 'o'); %plot the data point
    set(get(get(hPoint,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    
    % calculate and print the fitted curve
    xx = linspace(-8,-4,50);
    aa = aMatrix(failedRow(i), failedCol(i));
    bb = slop;
    cc = cMatrix(failedRow(i), failedCol(i));
    yy = aa./(1+ exp(-bb*(xx-cc)));
    
    hLine = plot(xx, yy);   %plot the fitted curve
    hLine.Color = hPoint.Color;   %set the color
    set(hLine, 'DisplayName',[curveName, ', R2=', num2str(r2Matrix(failedRow(i), failedCol(i)))]);   %set the name of the curve
    legend('off'); legend('show', 'Location', 'northeastoutside'); %control the display of legends
end

figure(figCurveFailed); xlabel('Log10(c)'); ylabel('\Delta F/F'); hold off;

%% Visualize the EC50 Matrix

% aMatrix; 
% cMatrix; 
% r2Matrix; 
% odorList; 

%replace NaN in the EC50 matrix with 0
cMatrix(isnan(cMatrix)) = 0;
% add two super senstive pairs, remove after measurement 
cMatrix(23, 12) = -9.06;   %2-heptanone, 85c
cMatrix(24, 16) = -8.85;  %methyl salicylate, 22c 

% apply the sequence of ORN and odor to order elements of the matrix 
% odorOrder = [17 12 15 2 10 3 4 16 9 1 18 8 6 5 7 13 14 11]; % the order is consistant to figure 2
% ORNOrder = [16 17 5 2 14 12 11 1 4 7 10 13 15 9 18 8 6 3];

% odorOrder = [19,33,12,32,27,15,14,7,8,9,6,22,24,31,30,29,1,5,10,17,28,3,4,23,20,26,13,25,16,2,11,21,34,18]; 
% ORNOrder  = [19,21,3,6,8,14,10,16,9,7,11,4,1,13,12,2,20,5,15,17,18];

odorOrder = [18,34,21,2,11,16,25,13,26,17,20,28,23,4,3,10,5,1,29,27,24,30,31,22,6,9,8,7,14,15,32,12,19,33]; 
ORNOrder  = [18,17,15,5,20,2,1,12,13,4,11,7,16,9,10,14,8,6,3,21,19];


[rowNum, colNum] = size(cMatrix);
newMStep1 = -cMatrix;
for i = 1:rowNum
    newMStep1(i,:) = -cMatrix(odorOrder(i),:);
end
newMStep2 = newMStep1;
for i = 1:colNum
    newMStep2(:,i) = newMStep1(:,ORNOrder(i));
end

% draw the heat map of the EC50 matrix
ec50Map = newMStep2;
figure;  pos = get(gcf, 'pos'); set(gcf, 'pos', [pos(1), pos(2), 610, 420]);
imagesc(ec50Map); 
set(gcf, 'Position', [100 250 560 700])
set(gca, 'CLim', [0 max(ec50Map(:))]);
set(gca,'XTick',1:colNum);
set(gca,'XTickLabel',ORNList(ORNOrder));
set(gca,'xaxisLocation','top');
set(gca,'YTick',1:rowNum);
set(gca,'YTickLabel',odorList(odorOrder));
set(gca, 'XTickLabelRotation', 45);
cmp = colormap(jet); cmp(1,:) = [0 0 0];
colormap(cmp); c = colorbar; 
c.TickLabels{1} = 'NaN'; c.Label.String = '-log10(EC50)';
title('EC50'); 

%% Verify the fitting
% Calculate the percentage of variance explained by the fitting
% Using the logistic equation and fitted parameters generate activity value
% and compare with the actual activity level

%claim variable to store the generated data 
yGen = NaN(rowTotal, colTotal, length(x));

%find out all the data elements need to be generated
[rowG, colG] = find(~isnan(cMatrix));

%calculate the 'predicted' activities
for i = 1: length(rowG)
    a = aMatrix(rowG(i), colG(i));
    b = slop;
    c = cMatrix(rowG(i), colG(i));
    yGen(rowG(i), colG(i), :) = a./(1+ exp(-b*(x-c)));
end

% calculate how many variance captured by the fitting
myIndex = find(~isnan(yGen));
residualData = dataMean(myIndex)- yGen(myIndex); %calculate the differences between the real and fitted data

varTotal = var(dataMean(myIndex));
varResidual = var(residualData(:));

rSquareFit = 1- varResidual/varTotal;

disp('----------GOODNESS OF THE FITTINGS ----------');
disp(['R-square of the fitting of the entire dataset: ', num2str(rSquareFit)]);

% scatter plot calculate-vs-actual data 
actualData = dataMean(myIndex);
genData = yGen(myIndex);
figure; plot(actualData, genData, 'ok', 'MarkerSize', 6);
axis([-1 8 -1 8]);
hold on; 
plot(linspace(-1, 8, 100), linspace(-1, 8, 100), '--k', 'LineWidth',1.5)
xlabel('Actual data');
ylabel('Generated data');
set(gcf, 'Position', [600 500 560 420])
title(['R^2 of the fitting: ', num2str(rSquareFit)]);

%% Save analyzed data 
save(fullfile('.', 'AnalysisResults', 'FitDoseResponse.mat'), 'aMatrix', 'cMatrix', 'slop', 'r2Matrix');
% diary off;