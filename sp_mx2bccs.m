%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%
%%%%%%
% Author: Γιώργος Πάκας, Ημ/νία εκκίνησης: 30/11/21 Ημ/νία ολοκλήρωσης: 01/12/21 




function [val,brow_idx,bcol_ptr] = sp_mx2bccs(A,nb)
    
    val = [];
    brow_idx = [];
    bcol_ptr = [];
    
    if(nargin~=2)
        error('sp_mx2bccs: Function requires 2 inputs');
    end
    
    if(length(size(A))~=2)
        error('sp_mx2bccs: Matrix can only be two-dimensional');
    end
    
    if(isempty(A))
        error('sp_mx2bccs: Matrix must not be empty, please input non-empty dimension(s)');
    end
    
    if((length(nb)>1) || (isempty(nb)) || (nb<1) || (nb~=floor(nb)))
        error('sp_mx2bccs: The size of a block must be a positive integer scalar');
    end
    
    
    [dimRow,dimCol]=size(A);
    if(dimRow*dimCol == 1)
        if(nb ~= 1)
            error('sp_mx2bccs: Matrix input was scalar, number of blocks can only be equal to 1');
        end
    elseif(mod(dimRow*dimCol,nb) ~= 0)
        error('sp_mx2bccs: Matrix must be perfectly divisible into equal-sized chunks')
    else
        tiledCA = mat2tiles(A,[nb,nb]); %Χώρισε το matrix σε ισομεγέθη blocks nbxnb
        %%%%%% NumOfNonZeroBlocks %%%%%%
        totalNumOfNonZero_blk = 0;
        for blk_iidx = 1:(dimRow/nb) %για κάθε block κατά γραμμή
            for blk_jidx = 1:(dimCol/nb) 
                if(any(tiledCA{blk_iidx,blk_jidx},'all')) %αν τουλάχιστον ένα απο τα στοιχεια του block δεν ειναι 0 
                    totalNumOfNonZero_blk = totalNumOfNonZero_blk + 1; % πρόσθεσέ το στο σύνολο μη-μηδενικών block
                end   
            end
        end
        %%%%%% val %%%%%%
        for blk_idx = 1:((dimRow*dimCol)/(nb^2)) %για κάθε block κατά σειρά εμφάνισης(default κατά στήλη)
            for j_idx = 1:(nb^2) %για κάθε στοιχείο του block
                if(~any(tiledCA{blk_idx},'all')) %αν όλα τα στοιχεια ενος block είναι 0 
                    break; %προσπέρασε το μπλοκ
                else
                    val = [val tiledCA{blk_idx}(j_idx)]; % αλλιώς append στο val τα στοιχεία του μπλοκ κατά στήλη block και κατά στήλη στοιχείων του block
                end       
            end
        end
        fprintf(1,'val = ');
        disp(val);
        %%%%%% brow_idx %%%%%%
        for blk_jidx = 1:(dimRow/nb) %για κάθε block κατά στήλη
            for blk_iidx = 1:(dimCol/nb) 
                if(~any(tiledCA{blk_iidx,blk_jidx},'all')) %αν πρόκειται για εξ'ολοκλήρου μηδενικό block 
                    continue; %προσπέρασε το block
                else
                    brow_idx = [brow_idx blk_iidx]; %διαφορετικά append το index γραμμής στο brow_idx
                end   
            end
        end
        fprintf(1,'brow_idx = ');
        disp(brow_idx);
            
        %%%%%% bcol_ptr %%%%%%
        posFirstNNZ_blk = 0; % θέση μη-μηδενικών block ως προς την ανά μεταξύ τους εμφάνιση
        for blk_jidx = 1:(dimRow/nb) % για κάθε block κατά στήλη
            foundFirst = 0; % boolean εύρεσης του πρώτου μη-μηδενικού block
            for blk_iidx = 1:(dimCol/nb)
                if(any(tiledCA{blk_iidx,blk_jidx},'all')) % αν δεν πρόκειται για εξ' ολοκλήρου μηδενικό block
                    posFirstNNZ_blk = posFirstNNZ_blk + 1; % βρήκα ένα μή-μηδενικό μπλοκ και ορίζω τη θέση του
                    if(foundFirst == 0) % αν πρόκειται για το πρώτο ανακαλυφθέν μη-μηδενικό μπλοκ
                        bcol_ptr = [bcol_ptr posFirstNNZ_blk]; % append τη θέση του στο διάνυσμα εξόδου
                        foundFirst = 1; % το_πρώτο_βρέθηκε = True
                    end
                    if(posFirstNNZ_blk == totalNumOfNonZero_blk) % αν πρόκειται για το τελευταίο μη-μηδενικό μπλοκ του μητρώου
                        bcol_ptr = [bcol_ptr (posFirstNNZ_blk + 1)]; % append την επόμενη από αυτού θέση block που ξεκινάει θεωρητικά καινούρια στήλη
                    end
                end
            end
        end
        fprintf(1,'bcol_ptr = ');
        disp(bcol_ptr);
            
    end
end
     
            
                        
                        












